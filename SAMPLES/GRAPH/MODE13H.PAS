{$G+} { Enables 80286 code generation }

Uses CRT;

Const
  grm320x200x8 = $13;
  txm8x16x4 = $03;

Procedure SetGraphMode(Mode : Byte);  Assembler;
  Asm
    Mov AH, $00
    Mov AL, Mode
    Int $10
  End;

Procedure PutPixel(X, Y : Integer; Color : Byte);
  Var
    Addr : LongInt;
  Begin
    Addr := LongInt(Y)*320+x;
    Mem[$A000:Addr] := Color;
  End;

Const
  MaxX = 319;
  MaxY = 199;

Type
  TScreen = Array[0..199, 0..319] Of Byte;

Var
  Screen : ^TScreen;

Procedure DrawScreen1(K : Byte);
  Var
    i, j : Integer;
  Begin
    For i := 0 To MaxY Do
      For j := 0 To MaxX Do
        PutPixel(j, i, (j+K) Mod 256);
  End;

Procedure WaitRetrace;  Assembler;
  Asm
    PushA
    Mov DX, $3DA
    @Returning:
    In AL, DX
    And AL, 8
    Cmp AL, 8
    Jz @Returning
    @Drawing:
    In AL, DX
    And AL, 8
    Or AL, AL
    Jz @Drawing
    PopA
  End;

Procedure FlipToScreen;  Assembler;
  Asm
    PushA
    Push ES
    Mov CX, $7D00
    Lea SI, Screen
    Mov AX, $A000
    Mov ES, AX
    XOr DI, DI
    Rep MovSW
    Pop ES
    PopA
  End;

Procedure DrawScreen2(K : Byte);
  Var
    i, j : Integer;
  Begin
    For i := 0 To MaxY Do
      For j := 0 To MaxX Do
        Screen^[i, j] := (j+K) Mod 256;
    WaitRetrace;
    FlipToScreen;
  End;

Procedure MoveScreen;
  Var
    K : Byte;
  Begin
    New(Screen);
    K := 0;
    Repeat
      DrawScreen2(K);
      If K < 255 Then Inc(K)
                 Else K := 0;
    Until KeyPressed;
    Dispose(Screen);
  End;

BEGIN
  SetGraphMode(grm320x200x8);
  MoveScreen;
  SetGraphMode(txm8x16x4);
END.