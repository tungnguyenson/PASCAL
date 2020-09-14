code_seg segment byte public 
	assume cs:code_seg, ds:code_seg 
	org 100h 

start: 
jmp init 
copyright db 'Copyright Nguyen Manh Cuong 1b_Dien tu tin hoc_DHBKHN, 1997.' 
int_13h_entry proc far 
cmp ah,0FFh 
jne nhan_3 
mov byte ptr cs:status,bl 
mov ah,0FEh 
retf 2 
int_13h_entry endp 

nhan_3: 
cmp byte ptr cs:status,0 
je nhan_7 
cmp dl,80h 
jae nhan_4 
jmp short nhan_7 

nhan_4: 
cmp ah,3 
je nhan_5 
cmp ah,5 
je nhan_5 
cmp ah,6 
je nhan_5 
cmp ah,7 
je nhan_5 
cmp ah,0Bh 
je nhan_5 
cmp ah,0Fh 
je nhan_5 
jmp short nhan_7 

nhan_5: 
cmp byte ptr cs:status,1 
jne nhan_6 
stc 
mov ah,3 
retf 2 

nhan_6: 
clc 
mov ah,0 
retf 2 

nhan_7: 
db 0EAh 
old_int13 dd ? 
status db 0 

init: 
mov ax,005dh 
mov si,ax 
mov bl,[si] 
sub bl,30h 
cmp bl,3 
jb nhan_9 
jmp nhan_15 

nhan_9: 
mov tam,bl 
cmp bl,1 
jne nhan_10 
mov ah,9 
mov dx,offset msg_7 
int 21h 

nhan_10: 
cmp bl,2 
jne nhan_11 
mov ah,9 
mov dx,offset msg_8 
int 21h 

nhan_11: 
cmp bl,0 
jne nhan_12 
mov ah,9 
mov dx,offset msg_9 
int 21h 

nhan_12: 
mov ah,0FFh 
int 13h 
cmp ah,0FEh 
jne nhan_13 
jmp nhan_14 

nhan_13: 
mov ax,3513h 
int 21h 
mov word ptr ds:old_int13,bx 
mov word ptr ds:old_int13 + 2,es 
mov ax,2513h 
mov dx,offset int_13h_entry 
int 21h 
mov ah,9 
mov dx,offset msg_4 
int 21h 
mov bl,tam 
mov ah,0FFh 
int 13h 
mov dx,offset init 
int 27h 
msg_4 db 'Chuong trinh da duoc cai dat vao bo nho an toan.',0dh,0ah 
db 'Copyright Nguyen Manh Cuong 1b Dien tu tin hoc DHBKHN, 1997.' 
db 0Dh, 0Ah,'$' 

nhan_14: 
mov ah,9 
mov dx,offset msg_5 
int 21h 
int 20h 
msg_5 db 'Chuong trinh da duoc cai dat vao bo nho tu truoc.',0dh,0ah 
db 'Copyright Nguyen Manh Cuong 1b Dien tu tin hoc DHBKHN' 
db ', 1997.', 0Dh, 0Ah, '$' 

nhan_15: 
mov ah,9 
mov dx,offset msg_10 
int 21h 
int 20h 
tam db 0 
msg_7 db 'Co thong bao loi.' ,0dh, 0ah, '$' 
msg_8 db 'Khong thong bao loi.', 0dh, 0ah,'$' 
msg_9 db 'Da cho phep ghi vao o cung.', 0ah, 0dh, '$' 
msg_10 db 'Tuy chon khong hop le, phai la:', 0ah, 0dh 
db '0= Cho phep ghi.', 0ah, 0dh 
db '1= Chong ghi co thong bao loi.', 0dh, 0ah 
db '2= Chong ghi khong co thong bao loi.', 0dh, 0ah 
db 'Copyright Nguyen Manh Cuong 1b Dien tu tin hoc DHBKHN' 
db ', 1997.', 0Dh, 0Ah, '$' 
code_seg ends 
end start 
