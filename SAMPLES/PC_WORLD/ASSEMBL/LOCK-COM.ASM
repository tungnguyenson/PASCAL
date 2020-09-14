; Chuong trinh 1
;~~~~~~~~~~~~~~~~~~~~
;  Tap tin LOCK-COM.ASM
; Dich:               MASM LOCK-COM;
; LINK LOCK-COM;
;  EXE2BIN LOCK-COM.EXE LOCK-COM.COM
;~~~~~~~~~~~~~~~~~~~~
Byte_N  Equ 8
CODE    	Segment
	Assume CS:Code,DS:Code
	Org 80h
Param_Len      	db   ?
Params         label byte
Org    	100h
Assume CS:Code,DS:Code, ES:Code, SS:Code

Begin:
Mov    	AL,Param_Len
Cmp    	AL,1
JA    	Continue1
Mov    	DX,Offset NO_Params
Call  	Printf
Mov    	AX,4C01h
Int    	21h

Continue1:
Mov    	BX,Offset Params ;Dat byte 0
Mov    	AL,Param_Len
Xor    	AH,AH
Add    	BX,AX
Mov    	Byte Ptr CS:[BX],0
Mov    	AX,3D02h ;Mo tap tin
Mov    	DX,Offset Params+1
Int    	21h
JNC    	Opened
Jmp    	Error

Opened:
Mov    	Handle,AX
Mov    	BX,AX ;Doc phan dau
Mov    	AH,3Fh
Mov    	DX,Offset Buffer
Mov    	CX,Byte_N
Int    	21h
JC     	Error
Mov    	SI,Offset Copyright  ;Kiem tra xem 
Mov    	DI,Offset Buffer+3 ;da khoa chua
Mov    	CX,5
Repe   Cmpsb ;Neu khoa roi, ngung
JE     Locked ;chuong trinh
Mov    DX,Offset P_Msg
Call   Printf
Mov    AH,0Ah ;Nhap ma
Mov    DX,Offset Pass_Max
Int    21h
Mov    AL,Pass_Len
Or     AL,AL
JZ     No_Set
Mov    DI,Offset  Old8Byte;Luu lai 8 byte
Mov    SI,Offset Buffer ;dau
Mov    CX,Byte_N
Rep    MovSb
Mov    AX,4202h ;Lay kich thuoc tap tin
Xor    CX,CX
Xor    DX,DX
Mov    BX,Handle ;AX chua kich thuoc
Int    21h                       ;tap tin
Sub    AX,3
Mov    Addr,AX
Mov    AH,40h ;Ghi doan ma them vao
Mov    DX,Offset Begin_Ins ;cuoi tap tin
Mov    CX,Offset End_Ins - Offset Begin_Ins
Int    21h
JC     Error
Mov    AX,4200h ;Ve dau tap tin
Xor    CX,CX
Xor    DX,DX
Int    21h
Mov    AH,40h ;Ghi lenh nhay
Mov    CX,Byte_N
Mov    DX,Offset Jmp_Cmd
Int    21h
JC     Error

No_Set:
Mov    BX,Handle ;Dong tap tin
Mov    AH,3Eh
Int    21h
Mov    AX,4C00h ;Thoat chuong trinh
Int    21h                       ;binh thuong

Error:
Call   Bell
Mov    AX,4C02h
Int    21h

Locked:
Mov    BX,Handle ;Dong tap tin
Mov    AH,3Eh
Int    21h
Mov    AX,4C03h
Int    21h

No_Params Db 'Required parameters missing -',13,10,'$'
Jmp_Cmd   Db   0E9h
Addr      Dw   ?
Copyright Db   'LC*96'
Handle  Dw     0
Buffer  db     Byte_N dup (0)

Begin_Ins:
Call   Read_P
Read_P:
Pop    AX  ;Lay dia chi Read_P
Mov    DX,Offset P_Msg - Offset Read_P
Add    DX,AX
Call   Printf  ;Ghi thong bao
Push   AX
Mov    DX,AX
Add    DX,Offset N_Pass_Max - Offset Read_P
Mov    AH,0Ah
Int    21h  ;Nhap mat ma
Pop    AX
Call   LineFeed
CLD
Mov    DI,DX ;So sanh
Add    DI,2
Mov    SI,Offset Password - Offset Read_P
Add    SI,AX
Mov    CX,15
Repe   CmpSb
JE     True_Pass
Call   Bell
Int    20h

True_pass:
Mov    DI,100h ;Tra lai 8 byte dau
Mov    SI,Offset Old8Byte - Offset Read_P
Add    SI,AX
Mov    CX,Byte_N
Rep    MovSb
Mov    DI,100h ;Nhay tro lai
Jmp    DI

Pass_Max  Db   15
Pass_Len  Db   0
Password  Db   15 dup (0)
Old8Byte  Db   Byte_N dup (?)
P_Msg     Db   'Password (Enter for none): $'

Printf  Proc   Near  ;Ghi chu
Push   AX
Mov    AH,9
Int    21h
Pop    AX
Ret
Printf  Endp

Bell    Proc   Near   ;Chuong
Push   AX
Mov    AX,0E07h
Int    10h
Pop    AX
Ret
Bell    Endp

LineFeed Proc Near
Push   AX
Push   DX
Mov    DX,Offset CRLF - Offset Read_P
Add    DX,AX
Mov    AH,9
Int    21h
Pop    DX
Pop    AX
Ret
CRLF    Db 13,10,'$'
LineFeed Endp

N_Pass_Max  Db   15
N_Pass_Len  Db   0
N_Password  Db   15 dup (0)

End_Ins:
Code    Ends
End     Begin
