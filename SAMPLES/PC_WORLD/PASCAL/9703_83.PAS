Uses Crt, Dos;
Type
RetBuff = Record
Sign : array [1..4] of char;
PriVerNo: Byte; SecVerNo: Byte;
ManuName	: ^String; Resever: LongInt;
ModeList	: ^String;
end;
Var CardInfo :RetBuff;
i,j:integer; Result:Boolean;
ss: string;

Function GetCardInfo(Var InfBuf: RetBuff): Boolean;
Var Reg :registers;
Begin	{GetCardInfo}
Reg.AX:=$4F00;
Reg.ES:=Seg(InfBuf);
Reg.DI:=Ofs(InfBuf);
Intr($10,Reg);
If Reg.AX<>$004F then GetCardInfo :=False
Else GetCardInfo := True;
End; 	{GetCardInfo}

Procedure SetSVGAMode(Mode: Integer);
Var Reg: Registers;
Begin	{SetSVGAMode}
Reg.AX:=$4F02;
Reg.BX:=Mode;
Intr($10,Reg);
End; 	{SetSVGAMode}

Procedure WinReposit(Var BankNum: Integer);
Var Reg	: Registers;
Begin
Reg.AX:=$4F05;
Reg.BX:=$0000;
Reg.DX:=BankNum;
Intr($10,Reg);
End;

Procedure PlotPixel(x,y: Integer; Color: Byte);
Var LinearAddress : Longint;
BankNumber : Integer;
PixelOffset 	: Word;
Begin	{PlotPixel}
LinearAddress := LongInt(y)*640 +x;
BankNumber := LinearAddress div 65536; {In wich window our pixel?}
PixelOffset := LinearAddress mod 65536; {Offset address of our pixel in this window}
WinReposit(BankNumber); 		{Select window in Video RAM}
    Mem[$A000:PixelOffset] := Color; 		{Set color of pixel}
End;	{PlotPixel}

BEGIN 	{Main Program}
ClrScr;
Result := GetCardInfo(CardInfo);
If Result = False then
Begin
Write('No SVGA card or card not supports VESA standars!');
Halt;
End;
Write('Manufacture :');
i:=0;
While CardInfo.ManuName^[i]<>#0 do Begin
 Write(CardInfo.ManuName^[i]);
inc(i);
End;
Writeln;
Write('Press any key to continue...');
Repeat until KeyPressed;
ReadKey;
Randomize;
SetSVGAMode($101);
Repeat
PlotPixel(Random(640), Random(480), Random(256));
Until Keypressed;
ReadKey;
SetSVGAMode($03);
END.
