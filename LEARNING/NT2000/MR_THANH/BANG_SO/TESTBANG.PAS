{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepDL = 'BS3.INP';
  TenTepKQ = 'n3.O';
  Next : Array[1..8, 1..2] Of ShortInt = ((-2, -1), (-2, 1), (-1, -2), (-1, 2),
                                          (1, -2), (1, 2), (2, -1), (2, 1));
  Size = 8;
  SoPhepBDMax = 10000;

Type
  BienDoi = Array[1..SoPhepBDMax, 1..4] Of Byte;

Var
  B, B0 : Array[1..Size, 1..Size] Of Byte;
  KTBD : Array[1..SoPhepBDMax] Of Byte;
  BD : ^BienDoi;
  SoPhepBD : Word;

Procedure Swap(y1, x1, y2, x2 :  Byte);
  Var
    Tmp : Byte;
  Begin
    Tmp := B[y1, x1];
    B[y1, x1] := B[y2, x2];
    B[y2, x2] := Tmp;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    For i := 1 To Size Do
      For j := 1 To Size Do
        Read(F, B[i ,j]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Rewrite(F);
    For i := 1 To Size Do
      For j := 1 To Size Do
        B[i, j] := (i-1)*Size+j;
    Randomize;
    For i := 1 To Random(20) Do
      For j := 1 To Size Do
        Swap(Random(Size)+1, Random(Size)+1, Random(Size)+1, Random(Size)+1);
    For i := 1 To Size Do
      Begin
        For j := 1 To Size Do
          Write(F, B[i, j]:3);
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Doc_Ket_Qua;
  Var
    F : Text;
    i : Word;
    ToaDo1, ToaDo2 : String[2];
    Ch : Char;
  Begin
    Assign(F, TenTepKQ);
    Reset(F);
    ReadLn(F, SoPhepBD);
    For i := 1 To SoPhepBD Do
      Begin
        Read(F, ToaDo1);
        Read(F, Ch);
        ReadLn(F, ToaDo2);
        BD^[i, 1] := Ord(ToaDo1[1])-96;
        BD^[i, 2] := 9-(Ord(ToaDo1[2])-48);
        BD^[i, 3] := Ord(ToaDo2[1])-96;
        BD^[i, 4] := 9-(Ord(ToaDo2[2])-48);
      End;
    Close(F);
  End;

Procedure Bieu_Dien_Ban_Co;
  Var
    i, j : Byte;
  Begin
    ClrScr;
    TextColor(7);
    For i := 1 To Size Do
      Begin
        GoToXY(1, i+3);
        Write((9-i):2, ' ³');
      End;
    For i := 1 To Size*3 Do
      Begin
        GoToXY(i+4, Size+4);
        Write('Ä');
      End;
    For i := 1 To Size Do
      Begin
        GoToXY((i-1)*3+5, Size+5);
        Write(Chr(i+96):3);
      End;
    GoToXY(4, Size+4);
    Write('À');
    For i := 1 To Size Do
      For j := 1 To Size Do
        Begin
          GoToXY((j-1)*3+5, i+3);
          Write(B[i, j] : 3);
        End;
  End;

Procedure Bieu_Dien;
  Var
    i : Word;
    Ch : Char;
    Stop : Boolean;
  Begin
    Write('Press Esc to stop or other keys to continue ...');
    Ch := ReadKey;
    If Ch = #0 Then Ch := ReadKey;
    If Ch = #27 Then Exit;
    i := 0;
    Stop := False;
    Bieu_Dien_Ban_Co;
    While (i < SoPhepBD)And(Not Stop) Do
      Begin
        Inc(i);
        If KTBD[i] < 2 Then
          Begin
            TextColor(15);
            GoToXY((BD^[i, 1]-1)*3+5, BD^[i, 2]+3);
            Write(B[BD^[i, 2], BD^[i, 1]]:3);
            GoToXY((BD^[i, 3]-1)*3+5, BD^[i, 4]+3);
            Write(B[BD^[i, 4], BD^[i, 3]]:3);
            TextColor(7);
          End;
        GoToXY(1, 1);
        WriteLn('So phep bien doi: ', SoPhepBD);
        Write('Phep bien doi thu ', i, ': ');
        Write(Chr(BD^[i, 1]+96), 9-BD^[i, 2], ' <=*=> ', Chr(BD^[i, 3]+96), 9-BD^[i, 4]);
        If KTBD[i] <> 0 Then Write(' (Sai)');
        GoToXY(1, Size+7);
        Write('Press Esc to stop or other keys to continue ...');
        Ch := ReadKey;
        If Ch = #0 Then Ch := ReadKey;
        Swap(BD^[i, 2], BD^[i, 1], BD^[i, 4], BD^[i, 3]);
        Bieu_Dien_Ban_Co;
        If Ch = #27 Then Stop := True;
      End;
  End;

Procedure Test;
  Var
    i, j, k : Word;
    KTraNuocDi, KTraKetQua : Boolean;
    Ch : Char;
  Begin
    B0 := B;
    KTraNuocDi := True;
    Write('Kiem tra cach di: ');
    FillChar(KTBD, SizeOf(KTBD), 0);
    For i := 1 To SoPhepBD Do
      Begin
        k := 0;
        For j := 1 To 4 Do
          If (BD^[i, j] < 1) Or (BD^[i, j] > Size) Then
            k := 1;
        If k = 1 Then Inc(KTBD[i]);
        k := 0;
        For j := 1 To 8 Do
          If (BD^[i, 2]+Next[j, 1] = BD^[i, 4])And
             (BD^[i, 1]+Next[j, 2] = BD^[i, 3]) Then k := 1;
        If k = 0 Then Inc(KTBD[i]);
        If KTBD[i] <> 0 Then
          Begin
            KTraNuocDi := False;
            WriteLn;
            Write('  Error!: (', i, ') ');
            Write(Chr(BD^[i, 1]+96), 9-BD^[i, 2], ' <=*=> ', Chr(BD^[i, 3]+96), 9-BD^[i, 4]);
          End;
        Swap(BD^[i, 2], BD^[i, 1], BD^[i, 4], BD^[i, 3]);
      End;
    WriteLn;
    KTraKetQua := True;
    For i := 1 To Size Do
      For j := 1 To Size Do
        If B[i, j] <> (i-1)*Size+j Then KTraKetQua := False;
    B := B0;
    If KTraNuocDi Then
      Begin
        GoToXY(19, 1);
        WriteLn('OK!');
      End;
    Write('Kiem tra ket qua bien doi: ');
    If KTraKetQua Then WriteLn('OK!')
                  Else WriteLn('SAI!');
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu;{}
  New(BD);
  Doc_Du_Lieu;
  Doc_Ket_Qua;
  Test;
  Bieu_Dien;
  Dispose(BD);{}
  ClrScr;
END.