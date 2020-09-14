;***************
;;Chuong trinh bung
;**********
.MODEL TPASCAL
.CODE

PUBLIC Expand
PROC Expand Src:dword,Dst: dword, Siz:word
     uses ds
     les di,Dst
     lds si,Src
     mov dx,256
     cld
     lodsb
     mov dl,al
@@1: sub al,al
     mov bx,1
     mov cx,7
@@2: test dl,dh
     jz @@3
     or al,bl
@@3: cmp dh,10000000b
     jne @@4
     mov dl,[si]
     inc si
     mov dh,01
     jmp short @@5
@@4: shl dh,1
@@5: shl bx,1
     loop @@2
     stosb
     dec Siz
     jnz @@1
@@6: ret
     ENDP
END
