Uses CRT, Graph, Graph256;

Type
  TBlockArray = Array[1..4, 1..4] Of Byte;

Procedure PaletteDemo;
  Var
    y, x : Integer;
  Begin
    ClearDevice;
    SetColor(Random(256));
    Rectangle(100, 100, 100+16*35, 100+16*25);
    For y := 0 To 15 Do
      For x := 0 To 15 Do
        Begin
          SetFillStyle(1, y*16+x);
          Bar(10+x*35+1, 10+y*25+1, 10+(x+1)*35-1, 10+(y+1)*25-1);
        End;{}
  End;

Procedure DrawBlock(x, y : Integer; Color : Byte);
  Var
    i, ColorOffset : Byte;
  Begin
    ColorOffset := (Color Mod 8)*32;
    For i := 1 To 3 Do
      Begin
        SetColor(ColorOffset+31-(8+i*4-1));
        Rectangle(x-i-6, y-i-6, x+i+6, y+i+6);
      End;
    SetFillStyle(1, ColorOffset+31);
    Bar(x-6, y-6, x+6, y+6);
  End;

Procedure DrawBlockArray(x, y : Integer; Bl : TBlockArray; Color : Byte);
  Var
    i, j : Byte;
  Begin
    For i := 1 To 4 Do
      For j := 1 To 4 Do
        If Bl[i, j] = 1 Then
          DrawBlock(x+(j-1)*19, y+(i-1)*19, Color);
  End;

Const
  MaxBlock = 7;

Var
  Block : Array[1..MaxBlock] Of TBlockArray;
  i : Byte;

Procedure InitBlock;
  Var
    i, j : Byte;
  Begin
    FillChar(Block, SizeOf(Block), 0);
    Block[1, 1, 1] := 1;
    Block[1, 1, 2] := 1;
    Block[1, 2, 1] := 1;
    Block[1, 2, 2] := 1;

    Block[2, 1, 1] := 1;
    Block[2, 1, 2] := 1;
    Block[2, 2, 2] := 1;
    Block[2, 2, 3] := 1;

    Block[3, 1, 1] := 1;
    Block[3, 2, 1] := 1;
    Block[3, 2, 2] := 1;
    Block[3, 3, 2] := 1;

    Block[4, 1, 1] := 1;
    Block[4, 2, 1] := 1;
    Block[4, 3, 1] := 1;
    Block[4, 3, 2] := 1;

    Block[5, 1, 1] := 1;
    Block[5, 1, 2] := 1;
    Block[5, 1, 3] := 1;
    Block[5, 2, 3] := 1;

    Block[6, 1, 1] := 1;
    Block[6, 1, 2] := 1;
    Block[6, 1, 3] := 1;
    Block[6, 1, 4] := 1;

    Block[7, 1, 1] := 1;
    Block[7, 2, 1] := 1;
    Block[7, 2, 2] := 1;
    Block[7, 3, 1] := 1;
  End;

BEGIN
  Init256Mode(2);
{  PaletteDemo;{}
  InitBlock;
  SetFillStyle(1, 0);
  Bar(0, 0, GetMaxX, GetMaxY);
  For i := 1 To MaxBlock Do
    DrawBlockArray(50+(i-1)*80, 100, Block[i], i);{}
  ReadLn;
  CloseGraph;
END.