Uses CRT;

Const

  InputFile = 'thu.pud';

  GoldOfs   = $19F6;
  LumberOfs = $1A1E;
  OilOfs    = $1A46;

  StColor : Array[1..8] Of String[6] = (
            'Red', 'Blue', 'Green', 'Violet', 'Orange', 'Black', 'White', 'Yellow');
  PlayerColor : Array[1..8] Of Byte = (4, 1, 2, 5, 6, 8, 15, 14);

  kbEsc        = #27;
  kbEnter      = #13;
  kbBackSpace  =  #8;

  kbRightArrow = #77;
  kbLeftArrow  = #75;
  kbUpArrow    = #72;
  kbDownArrow  = #80;
  kbDelete     = #83;

Var
  Gold, Lumber, Oil : Array[1..8] Of Word;
  Buf : Array[0..32767] Of Byte;

Procedure WriteXY(X, Y : Byte; S : String; FG, BG : Byte);
  Begin
    GoToXY(X, Y);
    TextAttr := BG Shl 4+FG;
    Write(S);
  End;

Procedure MainScreen;
  Var
    i : Byte;
    S : String;
  Begin
    TextAttr := 7;
    ClrScr;
    WriteXY(22, 2, 'Money for WAR2 - Written by NST', 11, 0);
    WriteXY(10, 6, '        Player        Gold      Lumber      Oil', 11, 0);
    WriteXY(9, 7, '+------------------+----------+----------+----------+', 11, 0);
    For i := 1 To 8 Do
      Begin
        Str(i, S);
        S := 'Player ' + S + ' (' + StColor[i] + ')';
        While Length(S) < 17 Do S := S + ' ';
        WriteXY(10, i+7, S+' : ', PlayerColor[i], 0);

        Str(Gold[i], S);
        While Length(S) < 10 Do S := ' ' + S;
        WriteXY(29, i+7, S, PlayerColor[i], 0);

        Str(Lumber[i], S);
        While Length(S) < 10 Do S := ' ' + S;
        WriteXY(40, i+7, S, PlayerColor[i], 0);

        Str(Oil[i], S);
        While Length(S) < 10 Do S := ' ' + S;
        WriteXY(51, i+7, S, PlayerColor[i], 0);
      End;
    WriteXY(9, 16, '+------------------+----------+----------+----------+', 11, 0);
    WriteXY(1, 18, 'D : Duplicate  ESC : Exit', 11, 0);
  End;

Procedure ReadData;
  Var
    F : File;
    i : Byte;
  Begin
    Assign(F, InputFile);
    Reset(F, 1);
    BlockRead(F, Buf, GoldOfs);
    For i := 1 To 8 Do
      BlockRead(F, Gold[i], 2);
    Reset(F, 1);
    BlockRead(F, Buf, LumberOfs);
    For i := 1 To 8 Do
      BlockRead(F, Lumber[i], 2);
    Reset(F, 1);
    BlockRead(F, Buf, OilOfs);
    For i := 1 To 8 Do
      BlockRead(F, Oil[i], 2);
    Close(F);
  End;

Procedure WriteData;
  Var
    F : File;
    i : Byte;
  Begin
    Assign(F, InputFile);
    Reset(F, 1);
    BlockRead(F, Buf, GoldOfs);
    For i := 1 To 8 Do
      BlockWrite(F, Gold[i], 2);
    Reset(F, 1);
    BlockRead(F, Buf, LumberOfs);
    For i := 1 To 8 Do
      BlockWrite(F, Lumber[i], 2);
    Reset(F, 1);
    BlockRead(F, Buf, OilOfs);
    For i := 1 To 8 Do
      BlockWrite(F, Oil[i], 2);
    Close(F);
  End;

Procedure Modify;
  Var
    Ch : Char;
    IsExit : Boolean;
    x, y : Byte;
    X0, Y0 : Byte;
    A : Array[1..8, 1..3] Of Word;
    St : Array[1..8, 1..3] Of String[10];
    i, j : Integer;
    l : LongInt;

  Procedure DrawCell(y, x, BG : Byte);
    Var
      S : String;
    Begin
      Str(A[y, x], S);
      While Length(S) < 10 Do S := ' ' + S;
      WriteXY(X0+(x-1)*11+2, Y0+y, S, PlayerColor[y], BG);
      GoToXY(X0+x*11, Y0+y);
    End;

  Procedure ShowCell(y, x : Byte);
    Begin
      DrawCell(y, x, 7);
    End;

  Procedure HideCell(y, x : Byte);
    Begin
      DrawCell(y, x, 0);
    End;

  Begin
    IsExit := False;
    For y := 1 To 8 Do A[y, 1] := Gold[y];
    For y := 1 To 8 Do A[y, 2] := Lumber[y];
    For y := 1 To 8 Do A[y, 3] := Oil[y];
    For y := 1 To 8 Do
      For x := 1 To 3 Do
        Str(A[y, x], St[y,x]);
    x := 1;
    y := 1;
    X0 := 27;
    Y0 :=  7;
    ShowCell(y, x);
    Repeat
      Ch := ReadKey;
      HideCell(y, x);
      If Ch = #0 Then
        Begin
          Ch := ReadKey;
          If Ch = kbRightArrow Then
            If X < 3 Then Inc(x);
          If Ch = kbLeftArrow Then
            If X > 1 Then Dec(x);
          If Ch = kbUpArrow Then
            If Y > 1 Then Dec(Y);
          If Ch = kbDownArrow Then
            If Y < 8 Then Inc(Y);
          If Ch = kbDelete Then
            If St[y, x] <> '' Then
              Begin
                Delete(St[y, x], Length(St[y, x]), 1);
                If St[y, x] = '' Then A[y, x] := 0
                                 Else Val(St[y, x], A[y, x], i);
              End;
        End
       Else
        Begin
          Case Ch Of
            kbEsc : IsExit := True;
            '0'..'9':
              If Length(St[y, x]) < 10 Then
                Begin
                  Val(St[y, x]+Ch, l, i);
                  If l <= 65535 Then
                    Begin
                      St[y, x] := St[y, x]+Ch;
                     A[y, x] := l;
                   End;
                End;
            'D', 'd':
              Begin
                For i := 2 To 8 Do
                  For j := 1 To 3 Do
                    A[i, j] := A[i-1, j];
                For i := 1 To 8 Do
                  For j := 1 To 3 Do
                    HideCell(i, j);
              End;
          End;
        End;
      ShowCell(y, x);
    Until IsExit;
    For y := 1 To 8 Do Gold[y] := A[y, 1];
    For y := 1 To 8 Do Lumber[y] := A[y, 2];
    For y := 1 To 8 Do Oil[y] := A[y, 3];
  End;

BEGIN
  ReadData;
  MainScreen;
  Modify;
  WriteData;
  TextAttr := 7;
  ClrScr;
END.