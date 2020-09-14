new_location equ 0600h
load_add equ 7c00h
sector_size equ 200h
bootseg segment at 07c0h

assume cs:bootseg

boot_load label far

bootseg ends

code segment

org 0

assume cs:code

part_sec proc

assume ds:nothing, es:nothing

assume ss:code, cs:code

sub ax,ax

cli

mov ss,ax

mov ds,ax

mov es,ax

mov sp,load_add

sti

mov si,sp

push di

mov di,new_location

mov cx,200h

cld

rep movsw

mov bx,(offset continue-offset part_sec+new_location)

push ax

push bx

retf

continue:

mov si,(offset message - offset part_sec+new_location)

print:

mov ah,0eh

mov al,cs:[si]

int 10h

inc si

cmp byte ptr cs:[si],0

jnz print

jmp @while

@while:

mov cx,length_pas

mov si,(offset pass_w - offset part_sec+new_location)

jmp run

run:

mov ah,0

int 16h

cmp al,42

je tg

cmp al,cs:[si]

jne @while

inc si

loop run

tg:

mov si,(offset ket_thuc - offset part_sec+new_location)

inti:

mov ah,0eh

mov al,cs:[si]

int 10h

inc si

cmp byte ptr cs:[si],0

jnz inti

done:

mov ax,bootseg

mov es,ax

mov bx,offset boot_load

mov ax,0201h

mov cx,3

mov dh,0

mov dl,80h

int 13h

jmp boot_load

message db 'Enter Password: ',0

ket_thuc db 13,10,'Hello and Welcome to your computer !',13,10,0

pass_w db '230017'

length_pas equ 6

part_sec endp

code ends

end
