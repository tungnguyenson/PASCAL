Program Money_For_War2_Saving_File;

Uses CRT;

Const

  GoldOfs   = $1F4;
  LumberOfs = $1B4;
  OilOfs    = $234;

  StColor : Array[1..8] Of String[6] = (
            'Red', 'Blue', 'Green', 'Violet', 'Orange', 'Black', 'White', 'Yellow');
  PlayerColor : Array[1..8] Of Byte = (4, 1, 3, 5, 6, 8, 15, 14);

  kbEsc        = #27;

  kbRightArrow = #77;
  kbLeftArrow  = #75;
  kbUpArrow    = #72;
  kbDownArrow  = #80;
  kbDelete     = #83;

Var
  Gold, Lumber, Oil : Array[1..8] Of LongInt;
  Buf : Array[0..32767] Of Byte;
  InputFile : String;

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
    WriteXY(1, 25, '   D = Duplicate   R = Reset to default   S = Save change   ESC = Exit', 11, 0);
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
      BlockRead(F, Gold[i], 4);
    Reset(F, 1);
    BlockRead(F, Buf, LumberOfs);
    For i := 1 To 8 Do
      BlockRead(F, Lumber[i], 4);
    Reset(F, 1);
    BlockRead(F, Buf, OilOfs);
    For i := 1 To 8 Do
      BlockRead(F, Oil[i], 4);
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
      BlockWrite(F, Gold[i], 4);
    Reset(F, 1);
    BlockRead(F, Buf, LumberOfs);
    For i := 1 To 8 Do
      BlockWrite(F, Lumber[i], 4);
    Reset(F, 1);
    BlockRead(F, Buf, OilOfs);
    For i := 1 To 8 Do
      BlockWrite(F, Oil[i], 4);
    Close(F);
  End;

Procedure Modify;
  Const
    X0 = 27;
    Y0 =  7;
  Var
    Ch : Char;
    IsExit : Boolean;
    x, y : Byte;
    A : Array[1..8, 1..3] Of LongInt;
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

  Procedure Refresh;
    Var
      i, j : Byte;
    Begin
      For i := 1 To 8 Do A[i, 1] := Gold[i];
      For i := 1 To 8 Do A[i, 2] := Lumber[i];
      For i := 1 To 8 Do A[i, 3] := Oil[i];
      For i := 1 To 8 Do
        For j := 1 To 3 Do
          Begin
            Str(A[i, j], St[i, j]);
            HideCell(i, j);
          End;
    End;

  Begin
    IsExit := False;
    Refresh;
    x := 1;
    y := 1;
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
                  If l <= MaxLongInt Then
                    Begin
                      If St[y, x] = '0' Then St[y, x] := Ch
                                        Else St[y, x] := St[y, x]+Ch;
                      A[y, x] := l;
                    End;
                End;
            'D', 'd':
              Begin
                For i := 1 To 8 Do Gold[i] := A[i, 1];
                For i := 1 To 8 Do Lumber[i] := A[i, 2];
                For i := 1 To 8 Do Oil[i] := A[i, 3];
                For i := 1 To 8 Do
                  Begin
                    Gold[i] := Gold[y];
                    Lumber[i] := Lumber[y];
                    Oil[i] := Oil[y];
                  End;
                Refresh;
              End;
            'R', 'r':
              Begin
                ReadData;
                Refresh;
              End;
            'S', 's':
              Begin
                For i := 1 To 8 Do Gold[i] := A[i, 1];
                For i := 1 To 8 Do Lumber[i] := A[i, 2];
                For i := 1 To 8 Do Oil[i] := A[i, 3];
                WriteData;
                Refresh;
              End;
          End;
        End;
      ShowCell(y, x);
    Until IsExit;
  End;

Var
  i : Byte;

BEGIN
  If ParamCount > 0 Then
    Begin
      InputFile := ParamStr(1);
      ReadData;
      MainScreen;
      Modify;
{      WriteData;{}
      TextAttr := 7;
      ClrScr;
    End
   Else
    Begin
      WriteLn;
      WriteLn('Money for War2');
      WriteLn('Usage:  MONEYSAV.EXE <SAVEXXXX.SAV>');
      WriteLn;
    End;
END.