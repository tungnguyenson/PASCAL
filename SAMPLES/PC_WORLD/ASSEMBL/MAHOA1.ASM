
;------------------------------------
;ma hoa
;------------------------------------
;ne^/u di.ch ba(\ng A86 (theo TG)
;code segment public
;	assume cs:code,ds:code
;	org 0100h

;ne^/u di.ch ba(\ng MASM (theo BT)
_TEXT	SEGMENT WORD PUBLIC 'CODE'
	ASSUME	cs:_TEXT, ds:_TEXT
	ORG	100h

main 	proc near
	
	mov si,81h
	mov cx,80

	lea di,file1
	mov al,byte ptr ds:[si]	

	cmp al,13
	je Synguide
	inc si
	mov al,byte ptr ds:[si]	
	cmp al,'/'
	jne e4
	cmp byte ptr ds:[si+1],'?'
	je help
e4:
	mov byte ptr [di],al
	inc di		
	inc si
loop1:
	mov al,byte ptr [si]	
	inc si
	cmp al, ' '
	je a1
	mov byte ptr [di],al
	inc di
	loop loop1
a1:
	lea di,file2	
	mov al,byte ptr [si]
	cmp al,' '
	je a2
loop2:
	mov al,byte ptr [si]
	inc si
	cmp al,13
	je a2
	mov byte ptr [di],al
	inc di
	loop loop2
	jmp a2
Synguide:
	mov ah,9
	lea dx,guide2
	int 21h
	jmp ketthuc	
a2:	
	mov al,2	;Open file1
	mov ah,3dh
	lea dx,file1
	int 21h
	jc Open_error	
	mov handle1,ax
	lea dx,guide1	;Nhan password
	mov ah,9
	int 021h
	lea si,pass
@@1:
	mov ah,7 	;Nhan passorwd tu ban phim
	int 21h
	cmp al,13  	; Het password
	je  @@2
	mov byte ptr [si],al ; Cat passord 
	inc si   
	jmp @@1
@@2:	
	call kiemtra ; Goi thu tuc kiem tra file output da ton tai chua
	cmp ah,0
	jne ketthuc 

	lea dx,file2	;Tao file output
	mov ah,3ch
        mov cx,20h
        int 21h
        jc create_error
	mov handle2,ax
	jmp @@0

help:
	lea dx,chuoi
	mov ah,9
	int 21h
	jmp ketthuc

Create_error:
	mov ah,9
	lea dx,error3
	int 21h
	jmp ketthuc
Open_error:

	mov ah,9
	lea dx,error4
	int 21h
	jmp ketthuc
Read_error:
	mov ah,9
	lea dx,error2
	int 21h
	jmp ketthuc

Write_error:

	mov ah,9
	lea dx,error1
	int 21h
	jmp ketthuc
ketthuc:

	mov bx,handle2 ;Ñoùng file output
	mov ah,3eh
	int 21h

	int 20h

@@0: 		;In dong  Waiting....
	mov ah,9
	lea dx,guide3
	int 21h

	mov cx,514
@@3:	
	lea si,chuoi
	mov byte ptr [si],0
	inc si
	loop @@3

	;Bat dau ma hoa
	mov bx,handle1	;doc file1 512 bytes
	mov cx,512
	mov ah,3fh
	lea dx,chuoi
	int 21h
	jc Read_error

	mov cx,ax	;Ax=so byte doc duoc
			;giu lai so byte de viet
	mov sobyte,ax
	cmp ax,512	; Neu doc khong du 512 co nghia la dong cuoi cung
	jae @@9
	lea si,check
	mov byte ptr [si],0
@@9:		
	lea di,chuoi
	lea si,pass 
@@6:			;Vong lap Ma hoa	
	mov al,byte ptr [di]
	mov ah,byte ptr [si]
	xor al,ah
	mov byte ptr [di],al
	inc di
	inc si
	mov al,byte ptr [si]
	cmp al,0
	je @@4
	jmp @@5
@@4:	
	lea si,pass ; Quay lai  tu dau chuoi password
@@5:
	loop @@6

	mov cx,sobyte  
	mov bx,handle2		;Ghi vao file output
	lea dx,chuoi
	mov ah,40h
	int 21h
	jc Write_error

	;Kiem tra het file chua
	lea si,check
	cmp byte ptr [si],0
	je ketthuc
e8:			; Chua het file ban in dau cham de chuong trinh dang chay
	mov dl,'.'
	mov ah,2
	int 21h
	jmp @@3
main 	endp

kiemtra proc
	mov al,2	;Kiem tra file2 ton tai chua
	mov ah,3dh
	lea dx,file2
	int 21h
	jc e9
	lea dx,error5
	mov ah,9
	int 21h
	lea si,file2
e11:
	mov dl,byte ptr [si]
	cmp dl,0
	je e10
	mov ah,2
	int 21h
	inc si
	jmp e11
e10:	
	lea dx,error6
	mov ah,9
	int 21h

	mov ah,0	; Cho doc phim tra loi
	int 16h
	cmp al,'Y'
	je e9
	mov ah,-1
	cmp al,'y'
	jne e12
e9:
	mov ah,0

e12:	
	ret
kiemtra endp 
pass	db 21 dup(0)
handle1	dw 0
handle2	dw 0 
sobyte	dw 0
file2	db 50 dup(0)
file1   db 50 dup(0)

guide1	db 13,10,'Enter your password:$'
guide2	db 13,10,'Use Syntax code <filename1> <filename2> ',13,10,'$'
guide3	db 13,10,'Waiting please ...$'

error1  db 13,10,'Writting errors. program terminated! ',13,10,'$'
error2  db 13,10,'Reading file error. program terminated!',13,10,'$'
error3	db 13,10,'Create file error . program terminate!',13,10,'$'
error4	db 13,10,'Open file error.Program terminated!',13,10,'$'
error5 	db 13,10,'File $ '
error6	db ' exist already. Overwrite (Y/N)?$'
check	db -1

chuoi      db  13,10,7,'Written by Le Hoai Nhan  Tel 8.243-341'
hello1     db 13,10,'        This is a safe way to code and protect your data' 
hello2     db 13,10,'When you code a file you must enter a password and this password'
hello3	  db 13,10,'is used to uncode file to the primary file by this program'
fff	db 13,10,13,10,'For example: At command line you type'
kkk	db 13,10,'Code code.asm  code.111 . Program will create file code.111,this file is coded '
hhh 	db 13,10,'When you want to uncode file code.111 you type'
mmm	db 13,10,'code code.111 code.222 '
nnn	db 13,10,'and then code.222 is the same with code.asm',13,10,'$'
qqq	db 20 dup(0)	

;ne^/u di.ch ba(\ng A86 (theo TG)
;Code	ends

;ne^/u di.ch ba(\ng MASM (theo BT)
_TEXT	ENDS

	end main
