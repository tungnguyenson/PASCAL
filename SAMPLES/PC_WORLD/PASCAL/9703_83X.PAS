Uses Crt, Dos;
Type
 RetBuff = Record
            {cau truc cho thong tin tra ve chuc nang ax=4f00H,int10}
  Sign : array [1..4] of char; {dau hieu nhan dang}
  PriVerNo: Byte; {so hieu phien ban chinh}
  SecVerNo: Byte; {so hieu phien ban phu}
  ManuName: ^String; {con tro Far den ten hang sna xuat}
  Resever: LongInt; {}
  ModeList: ^String;
   {con tro den danh sach cac che do video duoc ho tro}
 end;

Var
 CardInfo :RetBuff;
 i,j:integer;
 Result:Boolean;
 ss: string;
 cc: char;

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

Procedure GetSVGAMode(var Mode: Integer);
Var Reg: Registers;
Begin	{GetSVGAMode}
 Reg.AX:=$4F03;
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
Var
 LinearAddress : Longint;
 BankNumber : Integer;
 PixelOffset 	: Word;
Begin	{PlotPixel}
 LinearAddress := LongInt(y)*640 +x;
 BankNumber := LinearAddress div 65536;
  {In wich window our pixel?}
 PixelOffset := LinearAddress mod 65536;
  {Offset address of our pixel in this window}
 WinReposit(BankNumber);
  {Select window in Video RAM}
 Mem[$A000:PixelOffset] := Color;
  {Set color of pixel}
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
 While CardInfo.ManuName^[i]<>#0 do
 Begin
  Write(CardInfo.ManuName^[i]);
  inc(i);
 End;
 Writeln;
 Write('Press any key to continue...');
 Repeat until KeyPressed;
 cc:=ReadKey;

 Randomize;
 SetSVGAMode($101);
 Repeat
  PlotPixel(Random(640), Random(480), Random(256));
 Until Keypressed;
 cc:=ReadKey;

 SetSVGAMode($103);
 Repeat
  PlotPixel(Random(800), Random(600), Random(256));
 Until Keypressed;
 cc:=ReadKey;

 SetSVGAMode($105);
 Repeat
  PlotPixel(Random(1024), Random(768), Random(256));
 Until Keypressed;
 cc:=ReadKey;

 SetSVGAMode($106);
 Repeat
  PlotPixel(Random(1280), Random(1024), Random(16));
 Until Keypressed;
 cc:=ReadKey;

 SetSVGAMode($03);
END.
