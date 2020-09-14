Uses Graph, spGraph;

Const
  King = 6;
  Bishop = 5;
  Elephant = 4;
  Xe = 3;
  Canon = 2;
  Horse = 1;
  Pawn = 0;
  ChessMask : Array[-1..12, -1..11] Of Byte =
              ((  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),
               (  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),
               (  0,  0, 15, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0),
               (  0,  0, 15, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0),
               (  0,  0, 15, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0),
               (  0,  0, 15, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0),
               (  0,  0, 15, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0),
               (  0,  0, 15, 14, 31, 14, 15, 14, 31, 14, 15,  0,  0),
               (  0,  0, 14, 14, 14, 14, 14, 14, 14, 14, 14,  0,  0),
               (  0,  0, 30, 14, 14,110, 94,110, 14, 14, 30,  0,  0),
               (  0,  0, 14, 14, 14, 78,110, 78, 14, 14, 14,  0,  0),
               (  0,  0, 14, 14, 30,110, 78,110, 30, 14, 14,  0,  0),
               (  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),
               (  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0));
  PawnNext     : Array[1..3, 1..2] Of ShortInt =
                 ((-1, 0), ( 0,-1), ( 0, 1));
  HorseNext    : Array[1..8, 1..2] Of ShortInt =
                 ((-2,-1), (-2, 1), (-1,-2), (-1, 2),
                  ( 1,-2), ( 1, 2), ( 2,-1), ( 2, 1));
  CanonNext    : Array[1..4, 1..2] Of ShortInt =
                 ((-1, 0), ( 0,-1), ( 0, 1), ( 1, 0));
  XeNext       : Array[1..4, 1..2] Of ShortInt =
                 ((-1, 0), ( 0,-1), ( 0, 1), ( 1, 0));
  ElephantNext : Array[1..4, 1..2] Of ShortInt =
                 ((-2,-2), (-2, 2), ( 2,-2), ( 2, 2));
  BishopNext   : Array[1..4, 1..2] Of ShortInt =
                 ((-1,-1), (-1, 1), ( 1,-1), ( 1, 1));
  KingNext     : Array[1..4, 1..2] Of ShortInt =
                 ((-1, 0), ( 0,-1), ( 0, 1), ( 1, 0));

Var
  H, V : Integer;

Procedure Ve_Ban_Co;
  Var
    i, j : Byte;
  Begin
  End;

Procedure ShowPic;
  Var
    i, j : Integer;
    F : Text;
    Color : Byte;
  Begin
    Assign(F, 'chess1.pic');
    Reset(F);
    ReadLn(F, V, H);
    For i := 0 To V-1 Do
      For j := 0 To H-1 Do
        Begin
          Read(F, Color);
          PutPixel(j, i, Color);
        End;
    Close(F);
  End;

Procedure Delay(T : Word);
  Var
    i, j : Word;
  Begin
    For i := 0 To T Do
      For j := 0 To 65535 Do
        ;
  End;

Procedure Test;
  Var
    P, P0 : Pointer;
    i, j, k : Integer;
  Begin
    i := ImageSize(2, 2, 39, 39);
    GetMem(P, i);
    GetMem(P0, i);
    GetImage(2, 2, 39, 39, P^);
    ClearDevice;
{    SetFillStyle(5, 8);
    Bar(0, 0, GetMaxX, GetMaxY);{}
    i := 0;
    Repeat
      GetImage(i, 50, i+37, 87, P0^);
      PutImage(i, 50, P^, NormalPut);
{      Asm
        Mov Ah, 0
        Int 16H
      End;{}
      Delay(1);{}
      PutImage(i, 50, P0^, NormalPut);
      Inc(i, 5);
      If i > 300 Then Begin i := 0; ReadLn;End;
    Until False;
  End;

Begin
  InitGraphMode('SVGA256', VGAHi);
  ShowPic;{}
  Test;{}
  ReadLn;
  CloseGraph;
End.