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
	cmp	[cs:active],0	;cã ph¶i chuÈn bÞ gì
	je	Int21Exit	;(r)óng
	cmp	ax,2521h	;co ph¶i SetVector 21h
	je	SetVector21	;(r)óng
	cmp	ax,3521h	;cã ph¶i GetVector 21h
	je	GetVector21	;(r)óng
	cmp	ax,252fh	;cã ph¶i SetVector 2fh
	je	SetVector2f	;(r)óng
	cmp	ax,352fh	;cã ph¶i GetVector 2fh
	je	GetVector2f	;(r)óng
	cmp	ax,2509h	;cã ph¶i SetVector 09h
	je	SetVector09	;(r)óng
	cmp	ax,3509h	;cã ph¶i GetVector 09h
	je	GetVector09	;(r)óng
Int21Exit:			;nh¶y tíi ng3/4t cò
	popf
	jmp	[cs:SaveInt21]
SetVector21:			;SetVector21h Handler
	mov	word ptr [cs:SaveInt21],dx	;L­u vµo (r)Þa chØ ng3/4t cò
	mov	word ptr [cs:saveInt21+2],ds
	popf
	iret
GetVector21:					
	mov	bx,word ptr [cs:SaveInt21]	;tr¶ l¹i (r)Þa chØ ng3/4t cò.
	mov	es,word ptr [cs:Saveint21+2]
	popf
	iret
SetVector2f:
	mov	word ptr [cs:SaveInt2f],dx	;l­u vµo (r)Þa chØ ng3/4t cò
	mov	word ptr [cs:saveInt2f+2],ds
	popf
	iret
GetVector2f:					;tr¶ l¹i (r)Þa chØ ng3/4t cò
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
	cmp	ah,100			;co ph¶i kiÓm tra cµi (r)Æt
	je	CheckResident	;(r)óng
	cmp	ah,101			;cã ph¶i chuÈn bÞ gì
	je	Remove		;(r)óng
	popf				;kh«ng, nh¶y tíi ng3/4t
	jmp	[Cs:SaveInt2f] 	;cò
CheckResident:
	mov	al,1			;tr¶ vÒ al=1
	popf
	iret
Remove:
	mov	[cs:Active],0		;(r)Æt active=0
	mov	bx,cs			;tr¶ vÒ (r)Þa chØ 
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

	mov	ah,100			;gäi ng3/4t kiÓm tra
	int	2fh			;cµi (r)Æt
	cmp	al,1			;cã ph¶i (r)* cµi (r)Æt
	je	UnInstall		;(r)óng

	mov	ax,3521h		;lÊy vµ l­u (r)Þa chØ
	int	21h			;vector 21h cò
	mov	word ptr [cs:SaveInt21],bx
	mov	word ptr [cs:SaveInt21+2],es

	mov	ax,352fh		;lÊy vµ l­u (r)Þa chØ
	int	21h			;ng3/4t 2fh cò
	mov	word ptr [cs:SaveInt2f],bx
	mov	word ptr [cs:SaveInt2f+2],es

	mov	ax,3509h		;lÊy vµ l­u (r)Þa chØ
	int	21h			;ng3/4t 09 cò
	mov	word ptr [cs:SaveInt09],bx
	mov	word ptr [cs:SaveInt09+2],es

	mov	ax,252fh		;(r)Æt vector ng3/4t 2fh
	mov	dx,offset Int2fHandler
	int	21h

	mov	ax,2509h		;(r)Æt vector ng3/4t 09h
	mov	dx,offset Int09Handler
	int	21h

	mov	ax,2521h		;(r)Æt vector ng3/4t 21h
	mov	dx,Offset Int21Handler
	int	21h

	mov	dx, Offset ResidentMsg
	mov	ah,9
	int	21h

	mov	es,[cs:Env_Seg]	;gi¶i phãng khèi m«i tr­êng
	mov	ah,49h
	int	21h

	mov	dx,Offset Install	;th­êng tró
	int	27h

UnInstall:
	mov	ah,101			;chuÈn bÞ gì bá
	int	2fh			;es:bx: (r)Þa chØ ng3/4t 21h míi

	mov	ax,2509h		;(r)Æt l¹i vector ng3/4t 09h
	mov	dx,[es:bx+10]
	mov	ds,[es:bx+12]
	int	21h

	mov	ax,252fh		;(r)Æt l¹i vector ng3/4t 2fh
	mov	dx,[es:bx+6]
	mov	ds,[es:bx+8]
	int	21h

	mov	ax,2521h		;(r)Æt l¹i vector ng3/4t 21h
	mov	dx,[es:bx+2]
	mov	ds,[es:bx+4]
	int	21h

	mov	ah,49h			;gi¶i phãng khèi nhí
	int	21h

	push	cs			;ds=cs
	pop	ds
	
	mov	dx,Offset RemoveMsg
	mov	ah,9
	int	21h

	mov	ax,4c00h		;kÕt thóc
	int	21h
CopyrightMsg	db	'Flexible TSR',13,10,'Copyright Mai Chi Trung'
db	' A6 K33 Foreign Trade University',13,10,'$'
ResidentMsg	db	'Program is resident. Run me again to remove',13,10,'$'
RemoveMsg	db	'Program is removed from memory',13,10,'$'
code	ends
	end	start

