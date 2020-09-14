Program Shuffle_ScreenSaver;

Uses CRT;

Const
  Height = 5;
  Width  = 8;
  blTop    = 1;
  blLeft   = 2;
  blRight  = 3;
  blBottom = 4;
  MaxStepSaver = 100;

Type
  TBlock = Array[1..Height, 1..Width] Of Word;
  TScreen = Array[1..25, 1..80] Of Word;

Var
  Screen : TScreen Absolute $B800:0000;
  Saver : TScreen;
  Block, BlockSaver : TBlock;
  BlX, BlY : Byte;
  DelayTime : Byte;
  Direct, LastDirect : Byte;
  StepSaver : Array[1..MaxStepSaver] Of Byte;
  Step, IncStep : Integer;

Procedure GetBlock(Y, X : Byte; Var Block : TBlock);
  Var
    i, j : Byte;
  Begin
    For i := 1 To Height Do
      For j := 1 To Width Do
        Block[i, j] := Screen[Y+i-1, X+j-1];
  End;

Procedure ShowBlock(Y, X : Byte; Block : TBlock);
  Var
    i, j : Byte;
  Begin
    For i := 1 To Height Do
      For j := 1 To Width Do
        Screen[Y+i-1, X+j-1] := Block[i, j];
  End;

Procedure MoveTopBlock;
  Var
    i, j, X, Y : Byte;
  Begin
    Dec(BlY);
    Y := (BlY-1)*Height+1;
    X := (BlX-1)*Width+1;
    GetBlock(Y, X, Block);
    i := 0;
    Delay(DelayTime);
    Repeat
      For j := 1 To Width Do
        Screen[Y+i, X+j-1] := 0;
      Inc(i);
      ShowBlock(Y+i, X, Block);
      Delay(DelayTime);
    Until Keypressed Or (i >= Height);
  End;

Procedure MoveBottomBlock;
  Var
    i, j, X, Y : Byte;
  Begin
    Inc(BlY);
    Y := (BlY-1)*Height+1;
    X := (BlX-1)*Width+1;
    GetBlock(Y, X, Block);
    i := 0;
    Delay(DelayTime);
    Repeat
      For j := 1 To Width Do
        Screen[Y+Height-i-1, X+j-1] := 0;
      Inc(i);
      ShowBlock(Y-i, X, Block);
      Delay(DelayTime);
    Until Keypressed Or (i >= Height);
  End;

Procedure MoveLeftBlock;
  Var
    i, j, X, Y : Byte;
  Begin
    Dec(BlX);
    Y := (BlY-1)*Height+1;
    X := (BlX-1)*Width+1;
    GetBlock(Y, X, Block);
    j := 0;
    Delay(DelayTime);
    Repeat
      For i := 1 To Height Do
        Screen[Y+i-1, X+j] := 0;
      Inc(j);
      ShowBlock(Y, X+j, Block);
      Delay(DelayTime);
    Until Keypressed Or (j >= Width);
  End;

Procedure MoveRightBlock;
  Var
    i, j, X, Y : Byte;
  Begin
    Inc(BlX);
    Y := (BlY-1)*Height+1;
    X := (BlX-1)*Width+1;
    GetBlock(Y, X, Block);
    j := 0;
    Delay(DelayTime);
    Repeat
      For i := 1 To Height Do
        Screen[Y+i-1, X+Width-j-1] := 0;
      Inc(j);
      ShowBlock(Y, X-j, Block);
      Delay(DelayTime);
    Until Keypressed Or (j >= Width);
  End;

Procedure GetDirect;
  Var
    DrArray : String[4];
    i : Byte;
  Begin
    DrArray := '1234';
    If BlX = 1 Then DrArray[blLeft] := '0';
    If BlY = 1 Then DrArray[blTop] := '0';
    If BlX = 80 Div Width Then DrArray[blRight] := '0';
    If BlY = 25 Div Height Then DrArray[blBottom] := '0';
    If LastDirect <> $FF Then
      DrArray[5-LastDirect] := '0';
    While Pos('0', DrArray) <> 0 Do
      Begin
        i := Pos('0', DrArray);
        Delete(DrArray, i, 1);
      End;
    i := Random(Length(DrArray))+1;
    Direct := Ord(DrArray[i])-48;
  End;

Procedure Implement;
  Var
    Ch : Char;
  Begin
    Repeat
      Inc(Step, IncStep);
      If (Step > MaxStepSaver)Or(Step < 1) Then
        Begin
          IncStep := -IncStep;
          Inc(Step, IncStep);
          If IncStep > 0 Then
            Begin
              ShowBlock((BlY-1)*Height+1, (BlX-1)*Width+1, BlockSaver);
              Delay(1000);
              BlY := Random(25 Div Height)+1;
              BlX := Random(80 Div Width)+1;
              GetBlock((BlY-1)*Height+1, (BlX-1)*Width+1, BlockSaver);
              FillChar(Block, SizeOf(Block), 0);
              ShowBlock((BlY-1)*Height+1, (BlX-1)*Width+1, Block);
            End;
        End;
      If IncStep > 0 Then
        Begin
          GetDirect;
          StepSaver[Step] := Direct;
        End
       Else
        Direct := 5-StepSaver[Step];
{      Direct := blRight;
      blX := 1;
      blY := 1;{}
      Case Direct Of
        blTop    : MoveTopBlock;
        blBottom : MoveBottomBlock;
        blLeft   : MoveLeftBlock;
        blRight  : MoveRightBlock;
      End;
      LastDirect := Direct;
    Until Keypressed;
    Ch := ReadKey;
    If Ch = #0 Then Ch := ReadKey;
  End;

Procedure Init;
  Var
    i, j : Byte;
  Begin
{    ClrScr;
    For i := 1 To 25 Do
      For j := 1 To 80 Do
        Screen[i, j] := (1*16+Random(16))*256+Random(26)+65;{}
    LastDirect := $FF;
    Step := 0;
    IncStep := 1;
    Saver := Screen;
    Randomize;
    DelayTime := 50;
    BlY := Random(25 Div Height)+1;
    BlX := Random(80 Div Width)+1;
    GetBlock((BlY-1)*Height+1, (BlX-1)*Width+1, BlockSaver);
    FillChar(Block, SizeOf(Block), 0);
    ShowBlock((BlY-1)*Height+1, (BlX-1)*Width+1, Block);
  End;

Procedure Done;
  Begin
    Screen := Saver;
    Clrscr;
  End;

BEGIN
  Init;
  Implement;
  Done;
END.