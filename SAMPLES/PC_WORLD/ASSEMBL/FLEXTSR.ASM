code	segment
	assume	cs:code,ds:code
	org	02Ch
Env_Seg	label	word
	org	100h
start:
	jmp	Install
Int21Handler:
	jmp	short	over_data
SaveInt21	dd	?
SaveInt2f	dd	?
SaveInt09	dd	?
Active		db	1
over_data:
	pushf
	cmp	[cs:active],0	;c� ph�i chu�n b� g�
	je	Int21Exit	;(r)�ng
	cmp	ax,2521h	;co ph�i SetVector 21h
	je	SetVector21	;(r)�ng
	cmp	ax,3521h	;c� ph�i GetVector 21h
	je	GetVector21	;(r)�ng
	cmp	ax,252fh	;c� ph�i SetVector 2fh
	je	SetVector2f	;(r)�ng
	cmp	ax,352fh	;c� ph�i GetVector 2fh
	je	GetVector2f	;(r)�ng
	cmp	ax,2509h	;c� ph�i SetVector 09h
	je	SetVector09	;(r)�ng
	cmp	ax,3509h	;c� ph�i GetVector 09h
	je	GetVector09	;(r)�ng
Int21Exit:			;nh�y t�i ng3/4t c�
	popf
	jmp	[cs:SaveInt21]
SetVector21:			;SetVector21h Handler
	mov	word ptr [cs:SaveInt21],dx	;L�u v�o (r)�a ch� ng3/4t c�
	mov	word ptr [cs:saveInt21+2],ds
	popf
	iret
GetVector21:					
	mov	bx,word ptr [cs:SaveInt21]	;tr� l�i (r)�a ch� ng3/4t c�.
	mov	es,word ptr [cs:Saveint21+2]
	popf
	iret
SetVector2f:
	mov	word ptr [cs:SaveInt2f],dx	;l�u v�o (r)�a ch� ng3/4t c�
	mov	word ptr [cs:saveInt2f+2],ds
	popf
	iret
GetVector2f:					;tr� l�i (r)�a ch� ng3/4t c�
	mov	bx,word ptr [cs:SaveInt2f]
	mov	es,word ptr [cs:Saveint2f+2]
	popf
iret
SetVector09:
	mov	word ptr [cs:SaveInt09],dx
	mov	word ptr [cs:SaveInt09+2],ds
	popf
	iret
GetVector09:
	mov	bx,word ptr [cs:SaveInt09]
	mov	es,word ptr [cs:SaveInt09+2]
	popf
	iret


Int2fHandler:
	pushf
	cmp	ah,100			;co ph�i ki�m tra c�i (r)�t
	je	CheckResident	;(r)�ng
	cmp	ah,101			;c� ph�i chu�n b� g�
	je	Remove		;(r)�ng
	popf				;kh�ng, nh�y t�i ng3/4t
	jmp	[Cs:SaveInt2f] 	;c�
CheckResident:
	mov	al,1			;tr� v� al=1
	popf
	iret
Remove:
	mov	[cs:Active],0		;(r)�t active=0
	mov	bx,cs			;tr� v� (r)�a ch� 
	mov	es,bx			;Int21Handler trong
	mov	bx,offset Int21Handler;es:bx

	popf
	iret
Int09Handler:
	jmp	[cs:SaveInt09]

Install:
	mov	dx,offset CopyrightMsg
	mov	ah,9
	int	21h

	mov	ah,100			;g�i ng3/4t ki�m tra
	int	2fh			;c�i (r)�t
	cmp	al,1			;c� ph�i (r)* c�i (r)�t
	je	UnInstall		;(r)�ng

	mov	ax,3521h		;l�y v� l�u (r)�a ch�
	int	21h			;vector 21h c�
	mov	word ptr [cs:SaveInt21],bx
	mov	word ptr [cs:SaveInt21+2],es

	mov	ax,352fh		;l�y v� l�u (r)�a ch�
	int	21h			;ng3/4t 2fh c�
	mov	word ptr [cs:SaveInt2f],bx
	mov	word ptr [cs:SaveInt2f+2],es

	mov	ax,3509h		;l�y v� l�u (r)�a ch�
	int	21h			;ng3/4t 09 c�
	mov	word ptr [cs:SaveInt09],bx
	mov	word ptr [cs:SaveInt09+2],es

	mov	ax,252fh		;(r)�t vector ng3/4t 2fh
	mov	dx,offset Int2fHandler
	int	21h

	mov	ax,2509h		;(r)�t vector ng3/4t 09h
	mov	dx,offset Int09Handler
	int	21h

	mov	ax,2521h		;(r)�t vector ng3/4t 21h
	mov	dx,Offset Int21Handler
	int	21h

	mov	dx, Offset ResidentMsg
	mov	ah,9
	int	21h

	mov	es,[cs:Env_Seg]	;gi�i ph�ng kh�i m�i tr��ng
	mov	ah,49h
	int	21h

	mov	dx,Offset Install	;th��ng tr�
	int	27h

UnInstall:
	mov	ah,101			;chu�n b� g� b�
	int	2fh			;es:bx: (r)�a ch� ng3/4t 21h m�i

	mov	ax,2509h		;(r)�t l�i vector ng3/4t 09h
	mov	dx,[es:bx+10]
	mov	ds,[es:bx+12]
	int	21h

	mov	ax,252fh		;(r)�t l�i vector ng3/4t 2fh
	mov	dx,[es:bx+6]
	mov	ds,[es:bx+8]
	int	21h

	mov	ax,2521h		;(r)�t l�i vector ng3/4t 21h
	mov	dx,[es:bx+2]
	mov	ds,[es:bx+4]
	int	21h

	mov	ah,49h			;gi�i ph�ng kh�i nh�
	int	21h

	push	cs			;ds=cs
	pop	ds
	
	mov	dx,Offset RemoveMsg
	mov	ah,9
	int	21h

	mov	ax,4c00h		;k�t th�c
	int	21h
CopyrightMsg	db	'Flexible TSR',13,10,'Copyright Mai Chi Trung'
db	' A6 K33 Foreign Trade University',13,10,'$'
ResidentMsg	db	'Program is resident. Run me again to remove',13,10,'$'
RemoveMsg	db	'Program is removed from memory',13,10,'$'
code	ends
	end	start

