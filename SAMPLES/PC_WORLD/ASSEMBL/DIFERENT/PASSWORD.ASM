bootseg segment at 07c0h
assume cs:bootseg
bootload label far
bootseg ends
code segment
assume cs:code
org   0
start:
cli
xor ax,ax
mov ss,ax
mov sp,7c00h
mov si,sp
mov es,ax
mov ds,ax
sti
cld
mov di,600h
mov cx,100h
rep movsw
mov bx,offset continue-offset start+600h
push es
push bx
retf
continue:
mov si,offset partition-offset start+600h
write:
mov al,cs:[si]
mov ah,4dh
xor ax,4343h
int 10h
inc si
cmp byte ptr cs:[si],43h
jnz write
restart:
mov cx,word ptr ds:[7eeh]
xor cx,43h
mov si,7f0h
testpw:
mov ah,0
int 16h
xor al,43h
cmp al,cs:[si]
jnz  restart
inc si
loop testpw
mov ax,bootseg
mov es,ax
mov bx,offset bootload
mov ax,0201h
mov dx,0080h
mov cx,0005h
int 13h
xor ax,ax
mov es,ax
mov ds,ax
mov si,13h*4
mov di,offset old_int13-offset start+600h
movsw
movsw
mov si,413h
dec word ptr [si]
mov ax,word ptr [si]
mov cl,0ah
ror ax,cl
mov es,ax
xor di,di
mov si,offset old_int13-offset start+600h
mov cx,offset end_int13-offset old_int13+4
rep movsb
mov si,13h*4
cli
mov word ptr [si],offset new_int13-offset old_int13
mov word ptr [si+2],es
sti
jmp bootload
old_int13 dd ?
new_int13:
		cmp dl,80h
		jne done
		cmp dh,0
		jnz done
		cmp cx,0001h
		jne done
		mov dx,0080h
		mov cx,0005h
done:
		pushf
		call dword ptr cs:0
		retf  2
end_int13:
partition db 19,34,48,48,52,44,49,39,99,43,34,49,39,99,39,42,48,40,109,78,73
	  db 0,44,51,58,49,42,36,43,55,99,107,0,106,99,13,14,0,54,44,45,36,99
	  db 114,33,28,7,55,55,43,28,7,11,1,8,11,13,109,78,73,6,45,55,38,49,99
	  db 51,34,48,48,52,44,49,39,99,121,67		
endpr equ $-start
db (200h-endpr-3) dup (0)
db 43h,55h,0aah
code ends
end 		