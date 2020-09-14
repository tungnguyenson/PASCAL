;--------------------------------------------------------;
; KEYSWAP program					 ;
; This program will swap the F8 & F10 key for the	 ;
;   Up and Down arrow keys.				 ;
; Demonstrator program for debugging memory resident	 ;
;   program using Turbo Debugger.			 ;
;--------------------------------------------------------;
   .model small
; Set key values.
; For the SCAN and ASCII codes of any other keys, see the BIOS manual
f8key   equ 4200h      ; define the F8 key
f10key   equ 4400h      ; define the F10 key
upkey   equ 4800h      ; define the up arrow key
downkey   equ 5000h      ; define the down arrow key

DOSCALL   equ <int 21h>       ; DOS interrupt call
LOADSEG MACRO segr1, segr2   ; Load segment register
   push segr2      ;   macro.
   pop segr1
   ENDM

; Publics area
public start, oldint16, int16handler, exit, test_for_key
public load_tsr, tsr_terminate, chain_vector, f10pressed

; Start Code
   .code
   assume cs:_text, ds:_text, es:_text, ss:nothing
;=========;
; Our program start ;
;=========;
   org 100h      ; COM file starting program address.
start:
   jmp load_tsr      ; Load our program resident.

; Data area. Since this is COM file all data
; and code are in the Code segment.
   evendata
oldint16    dd   0   ; Area for old interrupt 16h vector.
stackbot   dw  128 dup('?'); Our stack bottom.
stacktop   equ $-2      ; Our stack top.
;=================;
; Entry to keyboard handler.          ;
; We get here when any application or DOS   ;
; executes an INT 16h.            ;
;=================;
int16handler proc far
   pushf         ; Save flags status.
   or ah, ah      ; Are we getting a key?
   je test_for_key      ; Yes - goto to test for F10.
   cmp ah,10h  
   je test_for_key      ; Yes - goto to test for F10.

   popf         ; No - pop flags and
   jmp cs:oldint16      ;   jump to old interrupt handler.

; Get a pressed key and test if it was
;   and F10
test_for_key:
   popf         ; Pop the original flags.
   pushf         ; Push them again
   call cs:oldint16   ;   and simulate INT 16h.

   pushf         ; Save flags.
   cmp ax, f10key       ; is this an F10 key?
   jne is_it_f8      ;   no - check for F8.
f10pressed:          ; Is it neccessary ? 
   mov ax, downkey      ;   yes - set swap key in ax.
   jmp short exit
is_it_f8:
   cmp ax, f8key       ; is this an F8 key?
   jne exit      ;   no - exit
   mov ax, upkey      ;   yes - set swap key in ax.
exit:
   popf         ; Pop the saved flags.

   iret         ; Return to caller with key in ax.
int16handler endp

IFDEF DEBUG
   ; Assemble this section to debug the TSR with Turbo Debugger.
   ; You must assemble with the /DDEBUG option.
   include tsrdebug.asm
ENDIF

;=================;
; Load KEYSWAP, and terminate but stay resident.;
; Once KEYSWAP is loaded all code from here on  ;
;   is discarded.            ;
;=================;
load_tsr:

   ; Set SP to our internal stack area
   cli         ; Do not interrupt while
   mov sp, offset stacktop   ;   stack pointer is being adjusted.
   sti         ; Now interrupt.

   call chain_vector   ; Install our keyboard interrupt.

IFDEF DEBUG
   ; Assemble this section to debug the TSR with Turbo Debugger.
   ; You must assemble with the /DDEBUG option.
   call tsr_simulate
ELSE
   ; Assemble this section to run without the debugging.
   call tsr_terminate
ENDIF
;==============;
; Save old interrupt 16 vector;
; and point it to our handler ;
;==============;
chain_vector proc ;uses ax bx dx es
   mov ax, 3516h      ; Get the int 16h keyboard vector.
   DOSCALL
   mov word ptr oldint16, bx; Save old vector in our data area.
   mov word ptr oldint16[2], es

   mov ax, 2516h      ; Set the new vector of our
   mov dx, offset int16handler; interrupt 16h keyboard handler.
   DOSCALL
   ret
chain_vector endp
;==============;
; Terminate and stay resident ;
;==============;
tsr_terminate proc
   mov dx, offset load_tsr   ; Get offset address of program
   mov cl, 4      ;   code to discard.
   shr dx, cl      ; Convert to pargraphs.
   inc dx         ; Round off to the next paragraph.
   mov ax, 3100h      ; Terminate & stay resident function.
   DOSCALL
tsr_terminate endp
@CurSeg ends
   end start
