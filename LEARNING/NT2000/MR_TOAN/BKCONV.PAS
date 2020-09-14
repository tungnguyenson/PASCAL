{$M 4096,0,655360}

Uses CRT;

Const
  MaxRow = 600;
  MaxCol = 100;

Type
  RowType = Array[1..MaxRow] Of String[MaxCol];

Var
  Row : ^RowType;
  BeginRow, RowPerPage : Byte;
  FirstRow, RowCount : Word;
  TepVNS, TepConv : String;

Procedure Init;
  Begin
    FirstRow := 1;
    BeginRow := 2;
    RowPerPage := 23;
    TepVNS := '';
    TepConv := '';
    If ParamCount > 0 Then
      Begin
        TepVNS := ParamStr(1);
        If ParamCount > 1 Then TepConv := ParamStr(2);
      End;
    New(Row);
  End;

Procedure Done;
  Begin
    TextColor(7);
    TextBackGround(0);
    ClrScr;
    Dispose(Row);
  End;

Procedure Read_File;
  Var
    F : Text;
  Begin
    TextColor(15);
    TextBackGround(3);
    GoToXY(1, 25);
    ClrEOL;
    If TepVNS = '' Then
      Begin
        Write('Nhap ten tep VNS: ');
        ReadLn(TepVNS);
        If TepVNS = '' Then
          Begin
            Done;
            Halt(0);
          End;
      End;
    Assign(F, TepVNS);
    Reset(F);
    RowCount := 0;
    While (Not EOF(F))And(RowCount < MaxRow) Do
      Begin
        Inc(RowCount);
        ReadLn(F, Row^[RowCount]);
      End;
    Close(F);
  End;

Procedure Save_File;
  Var
    F : Text;
    i : Word;
  Begin
    TextColor(15);
    TextBackGround(3);
    GoToXY(1, 25);
    ClrEOL;
    If TepConv = '' Then
      Begin
        Write('Nhap ten tep can ghi: ');
        ReadLn(TepConv);{}
        If TepVNS = '' Then
          Begin
            Done;
            Halt(0);
          End;
      End;
    Assign(F, TepConv);
    {$I-}
    Reset(F);
    {$I+}
    If IOResult <> 0 Then Rewrite(F)
     Else
       Begin
         Append(F);
         WriteLn(F);
       End;
    WriteLn(F, '{');
    For i := 1 To RowCount Do
      WriteLn(F, '  '+Row^[i]);
    WriteLn(F, '}');
    Close(F);
  End;

Procedure WriteRow(i : Word);
  Begin
    GoToXY(1, i-FirstRow+BeginRow);
    TextColor(7);
    TextBackGround(0);
    ClrEOL;
    Write(Row^[i]);
    TextBackGround(0);
  End;

Procedure Main_Screen;
  Begin
    TextBackGround(0);
    ClrScr;
    Window(1, BeginRow, 80, BeginRow+RowPerPage-1);
    TextBackGround(0);
    ClrScr;
    Window(1, 1, 80, 25);

    TextBackGround(3);
    TextColor(15);
    GoToXY(1, 1);
    ClrEOL;
    Write('           Chuong trinh chuyen font chu VNS -> Text - Written by NST');
    GoToXY(1, 25);
    ClrEOL;
  End;

Procedure Convert;
  Var
    i : Word;
    j : Byte;
    Ch : Char;
    S : String;
  Begin
    For i := 1 To RowCount Do
      Begin
        S := '';
        For j := 1 To Length(Row^[i]) Do
          Begin
            Case Row^[i, j] Of
              'µ', '¸', '¶', '·', '¹', '©', 'Ç', 'Ê', 'È', 'É', 'Ë',
                                       '¨', '»', '¾', '¼', '½', 'Æ' : Ch := 'a';
              'ß', 'ã', 'á', 'â', 'ä', '«', 'å', 'è', 'æ', 'ç', 'é',
                                       '¬', 'ê', 'í', 'ë', 'ì', 'î' : Ch := 'o';
              'Ì', 'Ð', 'Î', 'Ï', 'Ñ', 'Ò', 'Õ', 'Ó', 'Ô', 'Ö', 'ª' : Ch := 'e';
              '×', 'Ý', 'Ø', 'Ü', 'Þ'                               : Ch := 'i';
              'ï', 'ó', 'ñ', 'ò', 'ô', '­', 'õ', 'ø', 'ö', '÷', 'ù' : Ch := 'u';
              'ú', 'ý', 'û', 'ü', 'þ'                               : Ch := 'y';
              '¢', '¡' : Ch := 'A';
              '¤', '¥' : Ch := 'O';
              '¦' : Ch := 'U';
              '®' : Ch := 'd';
              '§' : Ch := 'D';
              #1..#7 : Ch := #0;
              Else Ch := Row^[i, j]
            End;
            S := S+Ch;
          End;
        Row^[i] := S;
      End;
  End;

Procedure Preview;
  Var
    KeyCode : Char;
    i : Byte;
  Begin
    Write('Nhan phim Enter de ghi vao file, Esc de thoat...');
    For i := 1 To RowPerPage Do
      If i < RowCount Then WriteRow(i);
    GoToXY(49, 25);
    Repeat
      KeyCode := ReadKey;
      If KeyCode = #0 Then
        Begin
          KeyCode := ReadKey;
          If KeyCode In [#72, #80] Then
            Case KeyCode Of
              #72 :
                If FirstRow > 1 Then
                  Begin
                    GoToXY(1, BeginRow);
                    Window(1, BeginRow, 80, BeginRow+RowPerPage-1);
                    InsLine;
                    Window(1, 1, 80, 25);
                    Dec(FirstRow);
                    WriteRow(FirstRow);
                    GoToXY(49, 25);
                  End;
              #80 :
                If FirstRow+RowPerPage-1 < RowCount Then
                  Begin
                    GoToXY(1, BeginRow);
                    Window(1, BeginRow, 80, BeginRow+RowPerPage-1);
                    DelLine;
                    Window(1, 1, 80, 25);
                    Inc(FirstRow);
                    WriteRow(FirstRow+RowPerPage-1);
                    GoToXY(49, 25);
                  End;
            End;
        End;
    Until KeyCode In [#27, #13];
    If KeyCode = #13 Then Save_File;
  End;

BEGIN
  Init;
  Main_Screen;
  Read_File;
  Main_Screen;
  Convert;
  Preview;
  Done;
END.