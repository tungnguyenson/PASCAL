;==========================;
; Include file TSRDEBUG.ASM                                     
; Assemble this code if you will debug with Turbo Debugger   ;
; You must assemble with the /DDEBUG option.         ;
;==========================;
public param, command_com
public tsr_simulate, unchain_vector, int9handler

BREAKPOINT   equ <int 3>   ; Debugger break point
ctrlflag   equ 4      ; Ctrl key BIOS indicator flag.
enterscan   equ 28      ; Scan code for Enter key.
kbdflags   equ 417h   ; BIOS keyboard flags location

; Load & Execute parameter block structure
execparam struc
  envstr_addr    dw 0      ; Environment pointer
  cmdline_ofs    dw 0      ; Offset to command line.
  cmdline_seg    dw 0      ; Segment to command line.
  fcb1_ofs       dw 0      ; Offset of fcb1.
  fcb1_seg       dw 0      ; Segment of fcb1
  fcb2_ptr       dw 0      ; Offset of fcb2.
  fcb2_seg       dw 0      ; Segment of fcb2.
execparam ends
oldint9      dd 0      ; Area for old int 9 vector.

paramvals    equ <0,offset cmd_line,?,offset fcb1,?,offset fcb2,?>
; Shows below how the data above is initialized.
comment ^
   0,         ; Use current environment
   offset cmd_line,?    ; Point to command line.
   offset fcb1,?      ; Offset & Seg of fcb1.
   offset fcb2,?       ; Offset & Seg of fcb2.
^
param         execparam <paramvals>
command_com   db 'c:\command.com',0
cmd_line      db 0, 0dh   ; Command line is null.
savess        dw 0      ; Save SS here.
savesp        dw 0      ; Save SP here.
fcb1          db 16 dup(0)   ; Blank area for FCB1
fcb2          db 27 dup(0)   ; Blank area for FCB2

;==========================;
; Int 9 handler. Ctrl-Enter key check.      ;
; Each time a key is pressed it is checked   ;
;    if the Ctrl & Enter key were pressed   ;
;   simultaneously. If they were then we   ;
;   interrupt Turbo Debugger      ;
;==========================;
int9handler proc far
   pushf         ; Save the flags
   push ax         ; Save ax
   push ds         ; Save ds
   xor  ax, ax      ; Point DS to segment 0
   mov ds, ax
   ; Is the Ctrl key pressed?
   test byte ptr ds:[kbdflags], ctrlflag
   je exitint9      ; No - call old int 9 & exit.
   in al, 60h            ; Yes - get the scan code of key.
   cmp al, enterscan      ; Is it the Enter key?
   je breakkey      ; Yes - go to break Turbo Debug
exitint9:         ; No - call old int 9 & exit
   pop ds         ; Pop ds & ax before jump.
   pop ax
   popf         ; Pop flags
   jmp cs:oldint9      ; Jump to the old int 9

breakkey:
   pop ds         ; Pop ds & ax before jump.
   pop ax
   popf         ; Pop flags
   in al, 61h      ; Reset the keyboard controller
   mov ah, al      ;   for next key.
   or al, 80h
   out 61h, al
   xchg ah, al
   out 61h, al
   mov al, 20h      ; Enable interrupts
   out 20h, al

   BREAKPOINT           ; Execute our break point.
            ; Turbo Debugger STOPS HERE!.
            ;   To find out what the program
            ;   was doing press F7 (Trace)
            ;   twice.
   iret
int9handler endp

;==========================;
; Simulate Terminate and stay resident   ;
; Frees unecessary memory 
; and loads & executes COMMAND.COM         ;
;==========================;
tsr_simulate proc
   ; Free unused memory.

   LOADSEG ES, CS      ; Point ES to our segment.
   mov bx, offset load_tsr   ; Get offset address of program
   mov cl, 4      ;   code to discard.
   shr bx, cl
   inc bx         ; round off to the next paragraph
   mov ah, 4ah      ; Shrink allocated block function
   DOSCALL         ; call DOS

   ; Save stack registers
   mov savess, ss      ; Save stack segment.
   mov savesp, sp      ; Save stack pointer.
   ; Chain unto int 9 for debugger break key.

   mov ax, 3509h      ; Get the int 9 keyboard vector.
   DOSCALL
   mov word ptr oldint9, bx; Save old vector in our data area.
   mov word ptr oldint9[2], es
   mov ax, 2509h   ; Set the new vector of our
   mov dx, offset int9handler; interrupt 9 keyboard handler.
   DOSCALL
   ; Load and execute COMMAND.COM

   LOADSEG ES, CS      ; Point ES to our segment
   mov dx, offset command_com; Point to COMMAND.COM file path.
   mov bx, offset param   ; Get address of param block.
   mov [bx].cmdline_seg, ds; Get segment of the command line.
   mov [bx].fcb1_seg, ds  ; Get segment of fcb1
   mov [bx].fcb2_seg, ds   ; Get segment of fcb2
   mov ax, 4b00h
   DOSCALL         ; Load and execute COMMAND.COM.
   ; Upon return form load and execute, all registers are
   ; destroyed and the necessary ones, must be recovered.

   cli         ; Turn interrupts off.
   mov ss, cs:savess  ; Recover stack segment.
   mov sp, cs:savesp   ; Recover stack pointer.
   sti
   LOADSEG DS, CS      ; Recover data segment
   ; Unchain all our handlers, and terminate program.

   mov ax, 2509h      ; Unchain our int 9 vector and put
   lds dx, oldint9      ;    original in.
   DOSCALL
   call unchain_vector   ; Unchain our keyboard handler
   mov ax, 4c00h      ; Terminate program.
   DOSCALL
tsr_simulate endp

;==========================;
; Unchain vectors before exiting debugger 
;==========================;
unchain_vector proc ; uses ds ax
   mov ax, 2516h   ; Unchain our vector and put
   lds dx, oldint16   ;    original in.
   DOSCALL
   ret
unchain_vector endp