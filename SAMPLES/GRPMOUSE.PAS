PROGRAM Graphic_Mouse;

Uses CRT, DOS;

Type
 Font = Array[0..15] of Byte;
 Kytu = Record
  Chu: byte;
  Mau: byte;
 End;
 Char4 = Array[1..4] of byte;
Const
 MouseFormat: array[0..15] of Byte= (0, 64, 96, 112, 120, 124, 126, 126, 120, 76, 12, 4, 6, 6, 0, 0);
 MChar:char4=(193, 194, 195, 196);
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
 f : Font;

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

Procedure Write_Bin(Deg : Byte);
  Var
    i : Byte;
  Begin
    For i := 7 downto 0 do
      If Deg and(1 shl i) <> 0 then Write(1)
                               Else Write(0);
    WriteLn;
  End;

Procedure Mousepaint(x, y: word);
Var
 Deltax, Deltay,  i:  integer;
Begin
 Restore(oldchar);
 Mwherex:= x shr 3;
 Mwherey:= y shr 3;
 TextBackGround(1);
 GotoXy(38, 12); Write(y+1:3);
 GotoXy(50, 12); Write(x+1:3);
 GotoXy(38, 14); Write(mwherey+1:3);
 GotoXy(50, 14); Write(mwherex+1:3);
 Save;
 ReadMode;
 For i:=1 To 4 Do
  LayFont(Ord(OldChar[i]), MFont[i]);
 RestoreMode;
 GotoXY(1, 4);
 For i := 0 to 15 do
   Write_Bin(MFont[1, i]);
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
Var
  i : Byte;
Begin
TextBackGround(0);
ClrScr;
For i := 1 to 10 do Write('Nguyen Son Tung ');
TextBackGround(1);
GotoXY(1, 1);Write(#193);
TextBackGround(2);
GotoXY(2, 1);Write(#194);
TextBackGround(3);
GotoXY(1, 2);Write(#195);
TextBackGround(4);
GotoXY(2, 2);Write(#196);
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

Var
  i : Byte;
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
If Da_Cai
Then Begin
 Write('Ban Chua Cai Chuot.');
 Goto Thoat;
End;{}
 ClrScr;
 ReadMode;
 LayFont(65, F);
 RestoreMode;
 GotoXY(1, 4);
 For i := 0 to 15 do
   Write_Bin(F[i]);
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