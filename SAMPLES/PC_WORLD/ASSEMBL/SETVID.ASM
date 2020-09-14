.Model TPascal
.Data
Extrn DirectVideo:Word
.Code
Public SetVideo
Public WritePixel
Public ReadPixel
Public GoXY
Public ClearScr
SetVideo Proc Far Vid:WORD,Dr:WORD
       MOV AX,Vid
       INT 10h
       MOV AX,Dr
       MOV DirectVideo,AX
       RET
SetVideo EndP

WritePixel Proc Far Col:WORD,Row:WORD,Color:Byte
       MOV AH,0Ch
       MOV AL,Color
       MOV BH,0
       MOV CX,Col
       MOV DX,Row
       INT 10h
       RET
WritePixel EndP

ReadPixel Proc Far Col:WORD,Row:WORD
       MOV AH,0Dh
       MOV BH,0
       MOV CX,Col
       MOV DX,Row
       INT 10h
       RET
ReadPixel EndP

GoXY Proc Far X:Byte,Y:Byte
       MOV AH,2
       MOV BH,0
       MOV DL,X
       MOV DH,Y
       INT 10h
       RET
GoXY EndP

ClearScr Proc Far X1:BYTE,Y1:BYTE,X2:BYTE,Y2:BYTE,Color:BYTE
       MOV AH,6
       MOV CH,Y1
       MOV CL,X1
       MOV DH,Y2
       MOV DL,X2
       MOV AL,0
       MOV BH,Color
       INT 10h
       RET
ClearScr EndP
       End