
;~~~~~~~~~~~~~~~~~~~~~~~
; Tap tin LOCK-EXE.ASM
; Dich:               MASM LOCK-EXE;
; LINK LOCK-EXE;
; EXE2BIN LOCK-EXE.EXE LOCK-EXE.COM
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Byte_Header Equ 1Ch
CODE    Segment
Assume CS:Code,DS:Code
Org 80h
Param_Len      db   ?
Params         label byte
Org    100h
Assume CS:Code, DS:Code, ES:Code, SS:Code

Begin:
Mov    AL,Param_Len
Cmp    AL,1
JA     Continue1
Mov    DX,Offset No_Params
Call   Printf
Mov    AX,4C01h
Int    21h

Continue1:
Mov    BX,Offset Params ;Dat byte 0
Mov    AL,Param_Len
Xor    AH,AH
Add    BX,AX
Mov    Byte Ptr CS:[BX],0
Mov    AX,3D02h  ;Mo tap tin
Mov    DX,Offset Params+1
Int    21h
JNC    Opened
Jmp    Error

Opened:
Mov    Handle,AX
Mov    BX,AX  ;Dac 30 byte dau
Mov    AH,3Fh
Mov    DX,Offset Buffer
Mov    CX,Byte_Header
Int    21h
JNC    Continue2
Jmp    Error

Continue2:
Mov    SI,Offset Buffer
Cmp    Word Ptr [SI],'ZM' ;Kiem tra hai ky tu dau co phai la 'MZ' khong
JE     EXE_file ;
Call   Bell
Mov    AX,4C04h
Int    21h

EXE_File:
Cmp    Word Ptr [SI+12h],0FFFFh  ;Kiem tra xem tap tin duoc ga mat ma chua
JNE    Continue3
Jmp    Locked

Continue3:
Mov    AX,0FFFFh
Mov    Word Ptr [SI+12h],AX
Mov    AX,Word Ptr [SI+14h]  ;Luu lai CS v... IP
Mov    Old_IP,AX
Mov    AX,Word Ptr [SI+16h]
Mov    Old_CS,AX
Mov    AX,4202h  ;Di chuyŽn tôi cu-i
Xor    CX,CX    ;tçp tin
Xor    DX,DX    ;DX:AX chua kich thuoc
Int    21h                   ;tap tin
Push   DX
Push   AX
Mov    DX,Offset P_Msg
Call   Printf
Mov    AH,0Ah
Mov    DX,Offset Pass_Max
Int    21h
Mov    AL,Pass_Len
Or     AL,AL
JZ     No_Set
Pop    AX
Pop    DX
Mov    SI,Offset Buffer  ;Tinh doi cho
Mov    CX,200h                   ;doan ma them
Div    CX
Mov    BX,AX
Mov    CL,5
Shl    AX,CL
Sub    AX,[SI+8]
Mov    Word Ptr [SI+16h],AX
Mov    Word Ptr [SI+14h],DX
Mov    AX,DX   ;Tim chieu dai theo cac trang 512 byte, ke ca Header
Add    AX,Offset End_Ins - Offset Begin_Ins
Xor    DX,DX 
Mov    CX,200h
Div    CX
Add    BX,AX
Or     DX,DX
JZ     Continue4
Inc    BX

Continue4:
Mov    [SI+4],BX  ;Luu chieu dai tim duoc
Mov    [SI+2],DX  ;vao Header
Mov    AX,4200h  ;Ve dau tap tin
Mov    BX,Handle
Xor    CX,CX
Xor    DX,DX
Int    21h
Mov    AH,40h  ;Ghi Header da dieu chinh vao lai tap tin
Mov    CX,Byte_Header  
Mov    DX,Offset Buffer
Int    21h
Mov    AX,4202h  ;Xuong cuoi tap tin
Xor    CX,CX
Xor    DX,DX
Int    21h
Mov    AH,40h  ;Gan them phan cuoi
Mov    BX,Handle
Mov    DX,Offset Begin_Ins
Mov    CX,Offset End_Ins - Offset Begin_Ins
Int    21h

No_set:
Mov    AH,3Eh  ;Dong tap tin
Mov    BX,Handle
Int    21h
Mov    AX,4C00h  ;Thoat ra  DOS
Int    21h

Locked:
Mov    AH,3Eh  ;Dong tap tin
Mov    BX,Handle
Int    21h
Mov    AX,4C03h
Int    21h

Error:
Call   Bell
Mov    AX,4C02h
Int    21h

Handle    Dw   ?
No_Params Db   'Required parameters missing -',13,10,'$'
Buffer    Db   30 dup (?)
B_L       Db   5 dup (?) ;Doan ma gan vao cuoi tap tinEXE

Begin_Ins:
Call   Install

Install:
Pop    DI ;DI chua dia chi Install
Jmp    Continue
Old_IP  Dw     ?
Old_CS  Dw     ?
Old_SP  Dw     ?
Old_SS  Dw     ?

Continue:
Mov    AX,Offset Install - Offset Begin_Ins
Sub    DI,AX   ;DI chaa dia Begin_Ins
Mov    BX,Offset Old_IP - Offset Begin_Ins
Mov    CS:[DI+BX+6],SS ;Luu lai gia tri ngan xep
Mov    CS:[DI+BX+4],SP
Cli
Mov    AX,CS ;Tao ngan xep
Mov    SS,AX
Mov    AX,DI
Add    AX,Offset Pass_Max - Offset Begin_Ins
Mov    SP,AX
Sti

Push   DS
Push   ES
Push   CS
Pop    DS

Mov    B_Ins_Addr,DI
Mov    DX,Offset P_Msg - Offset Begin_Ins
Add    DX,DI
Call   Printf ;Ghi thong bao
Mov    AH,0Ah
Mov    DX,Offset N_Pass_Max - Offset Begin_Ins
Add    DX,DI   ;Nhap mat ma
Int    21h

Push   DS
Pop    ES
CLD
Mov    AX,DI
Mov    DI,Offset N_Password - Offset Begin_Ins
Add    DI,AX
Mov    SI,Offset Password - Offset Begin_Ins
Add    SI,AX
Mov    CX,15
Repe   CmpSb  ;So sanh hai chuoi
JE     True_Pass
Call   Bell
Mov    AX,4C01h
Int    21h
True_pass:
Call   LineFeed
Mov    DI,B_Ins_Addr
Mov    BX,Offset Old_IP - Offset Begin_Ins
Pop    ES
Pop    DS
Cli

Mov    SP,Word Ptr CS:[DI+BX+4]  ;Tra lai ngan xep cu
Mov    SS,Word Ptr CS:[DI+BX+6]
Mov    AX,DS
Add    AX,10h
Add    AX,Word Ptr CS:[DI+BX+2]  ;Dat dia chi tro ve vao ngan xep
Push   AX
Mov    AX,Word Ptr CS:[DI+BX]
Push   AX
Sti
Retf   ;Tro ve

Printf  Proc   Near ;Ghi chu
Push   AX
Mov    AH,9
Int    21h
Pop    AX
Ret
Printf  Endp

Bell    Proc   Near ;Chuong
Push   AX
Mov    AX,0E07h
Int    10h
Pop    AX
Ret
Bell    Endp

Read_P:
LineFeed Proc Near
Push   AX
Push   DX
Mov    DX,Offset CRLF - Offset Begin_Ins
Add    DX,AX
Mov    AH,9
Int    21h
Pop    DX
Pop    AX
Ret
CRLF    Db 13,10,'$'
LineFeed Endp
Stack       Db   20   dup ('STACK')
Pass_Max    Db   15
Pass_Len    Db   0
Password    Db   15 dup (0)
N_Pass_Max  Db   15
N_Pass_Len  Db   0
N_Password  Db   15 dup (0)
P_Msg       Db   ' Password (Enter for none): $'
B_Ins_Addr  Dw   ?

End_Ins:
Code    Ends
End     Begin
