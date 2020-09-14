Drive_No 	db 	-1 
C_Count 	dw 	0 
H_Count 	dw 	0 
SPT 	dw 0 ; SecPerTrack 

GetHD_parm proc near 
; DL = Drive_No 
; Thu tuc nay phai thuc hien truoc 
; khi dung ReadSec 
push 	ax 
push 	bx 
push 	cx 
push 	dx 
mov 	byte ptr Drive_No,dl 
mov 	ah,8 
int 	013h 
inc 	dh 
mov 	byte ptr H_Count,dh 
mov 	ax,cx 
and 	al,00111111b 
mov 	byte ptr SPT,al 
xchg 	ch,cl 
mov 	ax,cx 
mov 	cl,6 
shr 	ah,cl 
inc 	ax 
mov 	word ptr C_Count,ax 
pop 	dx 
pop 	cx 
pop 	bx 
pop 	ax 
ret 
GetHD_parm 	endp 

LogicToPhysic 	proc near 
push 	bx 
div 	word ptr SPT 
inc 	dx 
mov 	bx,dx ; so du la SecNo 
xor 	dx,dx 
div 	word ptr H_count 
mov 	dh,dl ; so du la HeadNo 
xchg 	ah,al ; thuong so la 
	; CylinderNo 
mov 	cl,6 
shl 	al,cl ; tao SecCyl value 
or 	ax,bx 
mov 	cx,ax 
mov 	dl,byte ptr Drive_No 
mov 	ax,bx 
sub 	ax,word ptr SPT 
neg 	ax 
inc 	ax ; AX = so sector toi da co the coc 
pop 	bx ; ( SPT - BeginSec +1 ) 
ret 
LogicToPhysic 	endp 

ReadSec1 	proc near 
; DX:AX = Relative sector number 
; ES:BX = dia chi buffer 
; Doc mot sector 
call 	LogicToPhysic 
mov 	ax,0201h 
int 	013h 
ret 
ReadSec1 	endp 

ReadSec2 	proc near 
; DX:AX = Relative sector number 
; ES:BX = àõa chó buffer 
; CX = Sector count 
; Doc nhieu sector , goi Int_13 n lan 
; (n = sector count) 
RS2a: 
push 	ax 
push 	cx 
push 	dx 
call 	LogicToPhysic 
mov 	ax,0201h 
int 	013h 
pop 	dx 
pop 	cx 
pop 	ax 
jc 	RS2b 
inc 	ax 
adc 	dx,0 
add 	bx,0200h 
loop 	RS2a 
RS2b: 
jnc 	RS2c 
mov 	ah,1 
int 	013h 
stc 
RS2c: 
ret 
ReadSec2 	endp 

BeginRS 	dw 	0,0 
TotalSec 	dw 	0 

ReadSec3 	proc near 
; DX:AX = Relative sector number 
; ES:BX = dia chi buffer 
; CX = Sector count 
; Doc nhieu sector , goi Int_13 voi so 
; lan it nhat. 
mov 	word ptr TotalSec,cx 
mov 	word ptr BeginRS[0],ax 
mov 	word ptr BeginRS[2],dx 
RS3_0: 
mov 	ax,word ptr BeginRS[0] 
mov 	dx,word ptr BeginRS[2] 
call 	LogicToPhysic 
cmp 	ax,TotalSec ; ax = SPT - 
	;BeginSec +1 
jbe 	RS3_1 
mov 	ax,TotalSec 
RS3_1: 
sub 	TotalSec,ax 
add 	word ptr BeginRS[0],ax 
adc 	word ptr BeginRS[2],0 
push 	ax 
mov 	ah,2 
int 	013h 
pop 	ax 
jc 	RS3_2 
xchg 	ah,al 
shl 	ax,1 
add 	bx,ax ; ax = ax*512 
cmp 	TotalSec,0 
jne 	RS3_0 
RS3_2: 
jnc 	RS3_3 
mov 	ah,1 
int 	013h 
stc 
RS3_3: 
ret 
ReadSec3 	endp 
