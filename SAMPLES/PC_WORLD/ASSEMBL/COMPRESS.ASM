;******* Chuong trinh nen ******
.MODEL   TPASCAL
.CODE
PUBLIC   Compress
PROC     Compress Src:dword, Dst:dword, Siz:word
         uses ds
         les di,Dst
         lds si,Src
         mov dx,256
         cld
@@1:     lodsb
         mov bx,1
         mov cx,7
@@2:     test al,bl
         jz @@3
         or dl,dh
@@3:     cmp dh,10000000b
         jne @@4
         mov es:[di],dl
         inc di
         sub dl,dl
         mov dh,1
         jmp short @@5
@@4:     shl dh,1
@@5:     shl bx,1
         loop @@2
         dec Siz
         jnz @@1
         mov es:[di],dl
         sub di,word ptr Dst
@@6:     mov ax,di
         ret
         ENDP
END
