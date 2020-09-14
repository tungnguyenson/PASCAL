include capmac.inc
;-----------------------------------------------------------------------
code	segment
	assume	cs:code,ds:code,es:code
	org	100h
start:
	jmp	start_init
id_buf		db	'HIEN'
count		dw	1
filename	db	'screen??.thp',0
n_dta_ofs	dw	0		;dia chi DTA cua chuong trinh SAVE
n_dta_seg	dw	0		
n_psp		dw	0		;dia chi doan PSP cua chuong trinh SAVE
key_mask	dw	0000000000000001b
recur		db	0		;ngan khong cho goi de quy phan thuong tru
in_bios		db	0		;trang thai hoat dong cua dia o muc BIOS
dfptr		equ	this dword
dfptr_ofs	dw	0		;dia chi co noi tai cua DOS
dfptr_seg	dw	0
int09_ptr	equ	this dword
int09_ofs	dw	0		;dia chi cua thu tuc xu ly ngat 9 cu
int09_seg	dw	0
int13_ptr	equ	this dword
int13_ofs	dw	0		;dia chi cua thu tuc xu ly ngat 13 hex cu
int13_seg	dw	0
int28_ptr	equ	this dword
int28_ofs	dw	0		;dia chi cua thu tuc xu ly ngat 28 hex cu
int28_seg	dw	0
int60_ofs	dw	0
int60_seg	dw	0
u_dta_ofs	dw	0		;dia chi DTA cua chuong trinh bi gian doan
u_dta_seg	dw	0
u_psp		dw	0		;dia chi doan PSP chuong trinh bi gian doan
uprg_ss		dw	0		;SS
uprg_sp		dw	0		;SP cua chuong trinh bi gian doan
stack		dw	128 dup (0)
n_sp		dw	0
pallete		db	768 dup (?)
;--------------------------------------------------------------------------
int09		proc	far		;thu tuc xu ly ngat 9 moi
		pushf			 
		call	cs:int09_ptr	;goi thu tuc xu ly ngat 9 cu
		cli
		cmp	cs:recur,0	;SAVE bi goi de quy ?
		jne	ik_end		;dung ! tro ve ngay
		cmp	cs:in_bios,0	;dia dang hoat dong ?
		jne	ik_end		;dung ! tro ve ngay
		push	ax		;bay gio co the luu man hinh
		push	es
		xor	ax,ax
		mov	es,ax
		mov	ax,word ptr es:[417h]	;xem word tai 0:417 hex
		and	ax,cs:key_mask
		cmp	ax,cs:key_mask		;co nhan Shift phai ?
		pop	es
		pop	ax
		jne	ik_end		;khong ! hay tro ve
		push	ds		;co ! lam tiep
		push	bx
		lds	bx,cs:dfptr	;kiem tra co noi tai cua DOS
		cmp	byte ptr [bx],0
		pop	bx
		pop	ds
		jne	ik_end		;dang co ham thuc hien do dang, hay tro ve
		call	start_save	;luu man hinh vao SAVE.THP
ik_end:
		iret
int09		endp		
;-------------------------------------------------------------------------------
int13		proc	far		;thu tuc xu ly ngat 13 hex moi
		mov	cs:in_bios,1	;moi khi co hoat dong dia thi dat in_bios=1
		pushf
		call	cs:int13_ptr
		mov	cs:in_bios,0
		ret	2
int13		endp
;--------------------------------------------------------------------
int28		proc	far		;thu tuc xu ly ngat 28 hex moi
		pushf			;se cho phep goi SAVE khi go Shift(phai)
		call	cs:int28_ptr	;tai dau nhac cua DOS
		cmp	cs:recur,0
		je	id01
id_end:
		iret
id01:
		cmp	cs:in_bios,0
		jne	id_end
		push	ax
		push	es
		xor	ax,ax
		mov	es,ax 
		mov	ax,word ptr es:[417h]
		and	ax,cs:key_mask
		cmp	ax,cs:key_mask
		pop	es
		pop	ax
		jne	id_end
		call	start_save
		iret
int28		endp
;-------------------------------------------------------------------
start_save	proc	near		;thu tuc chuan bi cho viec luu man hinh 
		mov	cs:recur,1	;bao SAVE dang duoc goi
		mov	cs:uprg_ss,ss	;luu ngan xep cua chuong trinh bi gian doan
		mov	cs:uprg_sp,sp
		mov	ax,cs		;tao ngan xep moi
		mov	ss,ax
		mov	sp,offset cs:n_sp
		push	ax		;luu cac thanh ghi vao ngan xep moi
		push	bx
		push	cx
		push	dx
		push	bp
		push	si
		push	di
		push	ds
		push	es
		mov	cx,64		;luu them mot so thong tin trong ngan
		mov	ds,cs:uprg_ss	;xep cu cho chac an
		mov	si,cs:uprg_sp
save1:
		push	word ptr [si]
		inc	si
		inc	si
		loop	save1
		mov	ah,51h		;lay dia chi doan cua PSP cua
		int	21h		;chuong trinh bi gian doan roi luu vao
		mov	cs:u_psp,bx	;u_psp
		mov	ah,2fh		;lay dia chi DTA cua chuong trinh bi
		int	21h		;gian doan roi luu vao 
		mov	cs:u_dta_ofs,bx	;u_dta_ofs
		mov	cs:u_dta_seg,es	;va u_dta_seg
		mov	ah,50h		;dat lai PSP la cua SAVE
		mov	bx,cs:n_psp
		int	21h
		mov	ah,1ah		;dat lai DTA la cua SAVE
		mov	dx,cs:n_dta_ofs
		mov	ds,cs:n_dta_seg
		int	21h
		sti
		call	save		;luu man hinh vao SAVE.THP
		cli
		mov	ah,1ah		;phuc hoi DTA, PSP, ngan xep
		mov	dx,cs:u_dta_ofs ;va cac thong tin tren ngan xep
		mov	ds,cs:u_dta_seg ;cua chuong trinh bi gian doan
		int	21h
		mov	ah,50h
		mov	bx,cs:u_psp
		int	21h
		mov	cx,64
		mov	ds,cs:uprg_ss
		mov	si,cs:uprg_sp
		add	si,128
save2:
		dec	si
		dec	si
		pop	word ptr [si]
		loop	save2
		pop	es
		pop	ds
		pop	di
		pop	si
		pop	bp
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		mov	ss,cs:uprg_ss
		mov	sp,cs:uprg_sp
		mov	cs:recur,0
		ret
start_save	endp
;----------------------------------------------------------------------
save		proc
;-------------- doi count thanh chuoi so ------------------------------
		mov	ax,count
		mov	bl,10
		div	bl			;chia ax cho 10
		add	al,48			;al chua chu so hang chuc
		add	ah,48			;ah chua chu so hang don vi
		mov	bx,offset filename
		mov	byte ptr cs:[bx+6],al	;chuyen so ?? vao screen??.thp
		mov	byte ptr cs:[bx+7],ah
		inc	count
;-------------- ket thuc doi so thanh chuoi ----------------------------
;-------------- bat dau tao file screen??.thp --------------------------
		mov	ah,3ch			;ham tao hay mo file
		mov	cx,20h			;cx = 20h : thuoc tinh file archive
		mov	dx,offset cs:filename	;ds:dx = dia chi filename
		int	21h			;tra lai the file trong ax
		mov	bx,ax			;chuyen the file vao bx
		push	bx			;cat the file vao ngan xep
;-------------- ket thuc tao file, the file trong bx -------------------
;-------------- bat dau doc bang mau vao pallete -----------------------
		mov	ax,ds
		mov	es,ax
		mov	ah,10h			;ham doc bang mau
		mov	al,17h
		xor	bx,bx			
		mov	cx,256			;cx = so mau
		mov	dx,offset pallete	;es:dx = dia chi bang mau
		int	10h			
;-------------- ket thuc viec doc bang mau ------------------------------
;-------------- bat dau iec ghi bang mau --------------------------------
		pop	bx			;lay the file tu ngan xep
		mov	ah,40h			;ghi bang mau vao file
		mov	dx,offset cs:pallete	;ds:dx = dia chi bang mau
		mov	cx,768			;cx = kich thuoc bang mau
		int	21h			
;--------------- ket thuc ghi bang mau, bat dau ghi man hinh ------------
		mov	ax,0a000h
		mov	ds,ax
		xor	dx,dx			;ds:dx = dia chi bo nho man hinh
		mov	ah,40h
		mov	cx,64000		;cx = 64000 : so byte can ghi
		int	21h			
		mov	ah,3eh			;dong file
		int	21h
		ret
save		endp
;-------------------------------------------------------------------------------
uninstall	proc
		push	ds
		mov	ds,es:int09_seg
		mov	dx,es:int09_ofs
		@set_vecto	9
		pop	ds
		push	ds
		mov	ds,es:int13_seg
		mov	dx,es:int13_ofs
		@set_vecto	13h
		pop	ds
		push	ds
		mov	ds,es:int28_seg
		mov	dx,es:int28_ofs
		@set_vecto	28h
		pop	ds
		push	ds
		mov	ds,es:int60_seg
		mov	dx,es:int60_ofs
		@set_vecto	60h
		pop	ds
		@write	<'Capture had uninstall. Thank you for using this program.',cr,lf>
		ret
uninstall	endp
;----------------------------------------------------------------------------
start_init:					;phan khoi dong SAVE
		mov	ax,3560h		;kiem tra SAVE da thuong tru hay 
		int	21h			;chua bang cach xem vecto ngat
		mov	si,offset id_buf	;60 hex co chua 'HIEN'
		mov	di,bx
		mov	cx,4
		repe	cmpsb
		or	cx,cx
		jnz	continue
		call	uninstall
		int	20h
continue:
		mov	ah,2fh			;luu dia chi DTA cua capture
		int	21h
		mov	cs:n_dta_ofs,bx 	;
		mov	cs:n_dta_seg,es 	;
		mov	n_psp,cs		; luu dia chi segment cua PSP
		mov	ah,34h			; luu co noi tai cua DOS
		int	21h
		mov	cs:dfptr_ofs,bx
		mov	cs:dfptr_seg,es
		@get_vecto	9h		;luu vecto ngat	9 hex cu
		mov	cs:int09_ofs,bx
		mov	cs:int09_seg,es
		@get_vecto	13h		;luu vecto ngat	13 hex cu
		mov	cs:int13_ofs,bx
		mov	cs:int13_seg,es
		@get_vecto	28h		;luu vecto ngat	28 hex cu
		mov	cs:int28_ofs,bx
		mov	cs:int28_seg,es
		@get_vecto	60h		;luu vecto ngat	60 hex cu
		mov	cs:int60_ofs,bx
		mov	cs:int60_seg,es
		mov	dx,offset int09		
		@set_vecto	9		;dat vecto ngat 9 moi
		mov	dx,offset int13
		@set_vecto	13h		;dat vecto ngat 13 hex moi
		mov	dx,offset int28
		@set_vecto	28h		;dat vecto ngat 28 hex moi
		mov	dx,offset id_buf
		@set_vecto	60h		;dat vecto ngat 60 hex = HIEN
		@write	<'Capture 1.0 - Written by Vu Huy Phuong - Luong The Vinh high school',cr,lf>
		@write  <'Bien Hoa - Dong Nai. Tel : (061) 827732. Press right Shift to capture the screen'>
		@write  <'Run capture one more to uninstall this program',cr,lf>
		mov	dx,offset start_init	
		int	27h			;ket thuc va cho SAVE thuong tru
code		ends
		end	start
