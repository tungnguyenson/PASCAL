;-------------------------------;
; Chuong trçnh MACRO ph°m;      ;
;                               ;
;KEYMAC.ASM                     ;
;                               ;
;-------------------------------;

NULL = 00h
F11 = 57h
F12 = 58h

locals

.model tiny
.code

assume ds:@code

         org 100h

start:   jmp begin


;Vung bien toan cuc

         dircmd db 'DIR'
         asciiz db NULL

         _ax dw 'AX'
         _bx dw 'BX'
         _cx dw 'CX'
         _dx dw 'DX'
         _bp dw 'BP'
         _si dw 'SI'
         _di dw 'DI'
         _ds dw 'DS'
         _es dw 'ES'
         _rf dw 'RF'

;--------------;
; Thu tuc nay dung de luu;
; lai tat ca cac thanh ghi ;
;--------------;

saveall  proc near

         mov cs:_ax,ax
         mov cs:_bx,bx
         mov cs:_cx,cx
         mov cs:_dx,dx
         mov cs:_bp,bp
         mov cs:_si,si
         mov cs:_di,di
         mov cs:_ds,ds
         mov cs:_es,es
         pushf
         pop cs:_rf

         ret

saveall  endp


;------------;
; Thu tuc nay dung deé phuc hoi;
; tat ca cac thanh ghi;
;---------------;

restore  proc near

         push cs:_rf
         popf
         mov es,cs:_es
         mov ds,cs:_ds
         mov di,cs:_di
         mov si,cs:_si
         mov bp,cs:_bp
         mov dx,cs:_dx
         mov cx,cs:_cx
         mov bx,cs:_bx
         mov ax,cs:_ax

         ret

restore  endp


;-------------;
; Thu tuc nay dung de dua
; mot ma ASCII ra
; vung dem ban phim (32 byte o dia chi 0:41Eh)
;--------------;

;Vao:  CL = ma ASCII   ;
;Ra:   AL = ma loi    ;

;--------------;
; Ma loi trong thanh ghi AL;
;    0 : thÖnh cìng    ;
;    1 : vung dem ban phim day ;
;    FF: ma dua vao la ASCIIZ;
;------------------;

outkey   proc near

         mov ch,0
         jcxz @@01
         mov ah,5
         sti
         int 16h
         cli
         ret
@@01:    mov al,0FFh
         ret

outkey   endp


;---------------;
; Ngat cung ban phim moi
; de :
;    Sua 2 ph°m chuc nang F11;
;    va F12 (nhu da noi tren);
;------------------;

newkbd   proc far

         call saveall
         cli

; doc phim tu
; cong ban phim (cong 60 hexa)

         in al,60h
         cmp al,F11
         je @@kF11
         cmp al,F12
         je @@kF12

; Neu ma phim khong phai
; la phim F11 hoac F12
; thi thuc hien ngat cu~

oldkbd:  call restore
         pushf

         db 9Ah
         ofskbd dw (?)
         segkbd dw (?)
         jmp @@iret

; Xuat chuoi lenh DIR
; ra vóng dem bÖn ph°m

@@kF11:  mov ax,cs
         mov ds,ax
         lea si,dircmd
         cld

@@loop:  lodsb
         mov cl,al
         call outkey
         or al,al
         je @@loop

;Dua ma cua ph°m ENTER
;ra vóng dem bÖn ph°m

@@kF12:  mov cl,0Dh
         call outkey

;Ba^.t bit "enable KBD"
; vÖ dua ra
; cong dieu khien bÖn ph°m

         in al,61h
         mov ah,al
         or al,80h
         out 61h,al
         mov al,ah
         out 61h,al

;Gui ma EOI
; ra bo dieu khien ngat 8259

         mov al,20h
         out 20h,al

@@iret:  call restore
         iret

newkbd   endp


begin:

;Luu ngat cu+'ng bÖn ph°m

         xor ax,ax
         mov ds,ax
         les ax,ds:[9*4]
         mov cs:ofskbd,ax
         mov cs:segkbd,es

;Sua ngat cu+'ng bÖn ph°m

         lea ax,newkbd
         cli
         mov ds:[9*4],ax
         mov ds:[9*4+2],cs
         sti
;Ket th£c vÖ thuong tr£
;tu+` nha~n begin tro làn

         lea dx,begin
         int 27h
end      start

;Tran Thanh Son
