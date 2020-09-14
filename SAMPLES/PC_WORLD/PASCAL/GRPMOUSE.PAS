PROGRAM Graphic_Mouse;
Uses
 Crt, Dos;
Type
 Font = Array[0..15] of Byte;
 Kytu = Record
  Chu: byte;
  Mau: byte;
 End;
 Char4 = Array[1..4] of byte;
Const
 MouseFormat: array[0..15] of Byte= (0, 64, 96, 112, 120, 124, 126, 126, 120, 76, 12, 4, 6, 6, 0, 0);
 MChar:char4=(209, 212, 206, 219);
Var
 MFont: Array[1..4] of Font;
 Handler: pointer;
 Mwherex, Mwherey: word;
 CaiDat, On_Off: boolean;
 Screen: Array[0..24, 0..79] Of Kytu Absolute $B800:0000;
 BangFont: Array[0..255, 0..31] Of Byte Absolute $A000:0000;
 Mx, My, Mb:word;
 oldchar: char4;
 m,n: Byte;
 Da_Cai: Boolean;

Procedure Writexy (Tdx, Tdy, Mau: Byte; S: String);
Begin
 For m:= 0 To (Length(s)-1) Do Begin
 Screen[Tdy, Tdx+m].Chu:= Ord(S[m+1]);
 Screen[Tdy,Tdx+m].Mau:= Mau;
End; End;

Procedure MouseGet;
Begin
 Asm
  Mov ax,$0003
  Int $33
  Mov Mx, Cx
  Mov My, Dx
  Mov Mb, Bx
 End;
End;

Procedure ReadMode;
Begin
{
line($B8/$02/$04/$BA/$C4/$03/$EF/
$B8/$04/$07/$EF/$BA/$CE/$03/$B8/
$04/$02/$EF/$B8/$05/$00/$EF/$B8/$06/$00/$EF);}
Inline($B8/$02/$04/$BA/$C4/$03/$EF/
$B8/$04/$07/$EF/$BA/$CE/$03/$B8/$04/
$02/$EF/$B8/$05/$00/$EF/$B8/$06/$00/
$EB/$0C/$90/$44/$6F/$20/$43/$6F/$6E/$67/$20/$41/$6E/$68/$EF);
End;

Procedure RestoreMode;
Begin
{
Inline($BA/$C4/$03/$B8/
$02/$03/$EF/$B8/$04/$03/
$EF/$BA/$CE/$03/$B8/$04/
$00/$EF/$B8/$05/$10/$EF/$B8/$06/$0E/$EF);}
Inline($BA/$C4/$03/$B8/$02/$03/$EF/$EB/
$0E/$90/$20/$44/$6F/$20/$43/$6F/$6E/$67/
$20/$41/$6E/$68/$20/$B8/$04/$03/$EF/$BA/
$CE/$03/$B8/$04/$00/$EF/$B8/$05/$10/$EF/$B8/$06/$0E/$EF);
End;

Procedure NapFont (Number: Byte; F: Font);
Begin
 Move(F, BangFont[Number, 0], 16);
End;

Procedure LayFont(Number: Byte; Var F: Font);
Begin
 Move(BangFont[Number, 0], F, 16);
End;

Procedure Save;
Var
 Ofs:word;
Begin
 If MwhereX=79 Then Dec(MWhereX);
 If MwhereY=24 Then Dec(MWhereY);
 oldchar[1]:= Screen[MWhereY, MWhereX].Chu;
 oldchar[2]:= Screen[MWhereY, MWhereX+1].Chu;
 oldchar[3]:= Screen[MWhereY+1, MWhereX].Chu;
 oldchar[4]:= Screen[MWhereY+1, MWhereX+1].Chu;
End;

Procedure Restore(c: char4);
Var
 ofs: word;
Begin
 Screen[MWhereY, MWhereX].Chu:= c[1];
 Screen[MWhereY+1,MWhereX].Chu:=c[3];
 If Mwherex <>79 Then
 Begin
  Screen[MWhereY,MWhereX+1].Chu:=c[2];
  Screen[MWhereY+1,MWhereX+1].Chu:=c[4];
 End;
End;

Procedure Mousepaint(x, y: word);
Var
 Deltax, Deltay,  i:  integer;
Begin
 Restore(oldchar);
 Mwherex:= x shr 3;
 Mwherey:= y shr 3;
 WriteXy(36,11, $74, '    ');
 WriteXy(50, 11, $74, '   ');
 WriteXy(36, 13, $74, '    ');
 WriteXy(50, 13, $74, '   ');
 GotoXy(38, 12); Write(y+1);
 GotoXy(50, 12); Write(x+1);
 GotoXy(38, 14); Write(mwherey+1);
 GotoXy(50, 14); Write(mwherex+1);
 Save;
 ReadMode;
 For i:=1 To 4 Do
  LayFont(Ord(OldChar[i]), MFont[i]);
 RestoreMode;
 Deltax:= x And 7;
 Deltay:= y And 7;
 For i:=0 To 15 Do
  Asm
   Mov bx, offset MFont
   Mov si, deltay
   Add si, si
   Add si, i
   Cmp si, 15
   Jbe @@1
   Add si, 16
@@1:
   Mov ah, byte ptr [bx+si]
   Mov al, byte ptr [bx+si+16]
   Mov di, offset MouseFormat
   Add di, i
   Mov dh, [di]
   Xor dl, dl
   Mov cx, deltax
   Shr dx, cl
   Or  ax, dx
   Mov byte ptr [bx+si], ah
   Mov byte ptr [bx+si+16], al
  End;
 ReadMode;
 for i:=1 to 4 do
  NapFont(MChar[i], MFont[i]);
 RestoreMode;
 Restore(MChar);
End;

Procedure Mousestartup; Assembler;
Asm
 Mov On_Off, 1
 Mov CaiDat, 1
 Xor ax, ax
 Int 33h
 Or ax, ax
 Jnz @@1
 Mov CaiDat, 0
 Jmp @@2
@@1:
 Mov ax, 0002h
 Int 33h
 Mov ax, 0003h
 Int 33h
 {Shr cx,3
 Shr dx,3}
 shr cx,1
 shr cx,1
 shr cx,1
 shr dx,1
 shr dx,1
 shr dx,1
 Mov mwherex, cx
 Mov mwherey, dx
 {Shr mwherex, 3
 Shr mwherey, 3}
 Shr mwherex, 1
 Shr mwherex, 1
 Shr mwherex, 1
 Shr mwherey, 1
 Shr mwherey, 1
 Shr mwherey, 1
 Push cx
 Push dx
 Call Save
 Call Mousepaint
@@2:
End;

Procedure Mhandler; Assembler;
Asm
 Mov ax, Seg MFont
 Mov ds, ax
 {Shr cx, 3
 Shr dx, 3}
 Shr cx, 1
 Shr cx, 1
 Shr cx, 1
 Shr dx, 1
 Shr dx, 1
 Shr dx, 1
 Push cx
 Push dx
 Call mousepaint
 Retf
End;

Procedure MouseOff;
Begin
 If not On_Off Then Exit;
 On_Off:= false;
 Restore(OldChar);
 Asm
  Mov ax, 0Ch
  Xor cx, cx
  Les dx, Handler
  Int 33h
 End;
End;

Procedure mouseon;
Begin
 If On_Off Then Exit;
 On_Off:= True;
 Asm
  Mov ax, 0Ch
  Mov cx, 01
  Les dx, Handler
  Int 33h
 End;
End;

Procedure MouseInit;
Begin
For n:= 0 To 24 Do
Writexy(0, n, $1A, 'Cong Anh **ABCDEFGHIJKLMNOPQ'+
'TWVXYZ1234567890** Cong Anh');
Writexy(24, 10, $74, 'Toa do chuot thuc: ');
Writexy(24, 11, $74, 'Hang:         Cot:         ');
Writexy(24, 12, $74, 'Toa do chuot ao:');
Writexy(24, 13, $74, 'Hang:         Cot:         ');
TextColor(4);
TextBackGround(7);
MwhereX:=0;
MwhereY:= 0;
MouseStartup;
Handler:= @Mhandler;
Asm
 mov Ax, 000fh {toc do chuot }
 Mov Cx, 2
 Mov Dx, 2
 Int 33h
 Mov ax, 0007h    { chieu rong cua cua so}
 Xor cx, cx
 Mov dx, 639*8
 Int 33h
 Mov ax, 0008h    {chieu dai}
 Xor cx, cx
 Mov dx, 199*8
 Int 33h
 Mov ax, 0Ch      {cai dat}
 Mov cx, 01
 Les dx, Handler
 Int 33h
End;
End;
Label Thoat;

BEGIN
Asm
 xor ax, ax;
 int 33h;
 cmp Ax, 0;
 je @1;
 mov Da_Cai, True
@1:
 mov Da_Cai, False;
End;
If Not(Da_Cai)
Then Begin
 Write('Ban Chua Cai Chuot.');
 Goto Thoat;
End;
MouseInit;
MouseOn;
Repeat
 MouseGet;
Until (Mb=2) or Keypressed;
MouseOff;
ClrScr;
Thoat:
TextColor(15);
TextBackGround(0);
END.
