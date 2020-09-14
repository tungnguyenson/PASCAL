Uses CRT;

Type
  ST2 = String[2];

Const
  Max = 10000;

Var
  A : Array[1..Max] Of Word;
  Xet : Array[1..Max] Of Boolean;
  i : Word;
  N : Word;
  Dem, TimeStart, TimeFinish : LongInt;
  Timer : LongInt Absolute $0000:$046C;
  Kp : Char;

Procedure WriteXY(X, Y : Word; St : String);
  Begin
    GoToXY(X, Y);
    Write(St);
  End;

Procedure Nhap_Du_Lieu;
  Begin
    Repeat
      GoToXY(1, 12);
      ClrEOL;
      Write('So can phan tich: ');
      ReadLn(N);
    Until N <= Max;
    GoToXY(28, 4);
    ClrEOL;
    Write(N,')');
    GoToXY(1, 12);
    ClrEOL;
  End;

Procedure Khoi_Tao;
  Begin
    FillChar(A, SizeOf(A), 0);
    FillChar(Xet, SizeOf(Xet), False);
    i := 0;
    Dem := 0;
  End;

Procedure Xuat(j : Word; Link : ST2);
  Var
    i : Word;
  Begin
    Inc(Dem);
    Write(N, ' = ');
    For i := 1 To j Do
      If i < j Then Write(A[i], Link)
       Else
        Begin
          If (Link= '*')And(j = 1) Then Write('1*');
          Write(A[i]);
          WriteLn;
        End;
  End;

Procedure Phan_Tich_Thanh_Tong(N, Last : Word);
  Var
    j : Word;
  Begin
    For j := Last To N Do
    Begin
      Dec(N, j);
      Inc(i);
      A[i] := j;
      If N > 0 Then Phan_Tich_Thanh_Tong(N, j)
               Else Xuat(i, '+');
      Inc(N, j);
      Dec(i);
    End;
  End;

Procedure Phan_Tich_Thanh_Tong_Binh_Phuong(N, Last : Word);
  Var
    j : Word;
  Begin
    For j := Last To Trunc(SQRT(N)) Do
    Begin
      Dec(N, j*j);
      Inc(i);
      A[i] := j;
      If N > 0 Then Phan_Tich_Thanh_Tong_Binh_Phuong(N, j)
               Else Xuat(i, 'ý+');
      Inc(N, j*j);
      Dec(i);
    End;
  End;

Procedure Phan_Tich_Thanh_Tong_Khac_Nhau(N, Last : Word);
  Var
    j : Word;
  Begin
    For j := Last To N Do
      If Xet[j] = False Then
      Begin
        Dec(N, j);
        Inc(i);
        A[i] := j;
        Xet[j] := True;
        If N > 0 Then Phan_Tich_Thanh_Tong_Khac_Nhau(N, j)
                 Else Xuat(i, '+');
        Inc(N, j);
        Xet[j] := False;
        Dec(i);
      End;
  End;

Procedure Phan_Tich_Thanh_Tich(N, Last : Word);
  Var
    j : Word;
  Begin
    For j := Last To N Do
      If N Mod j = 0 Then
      Begin
        N := N Div j;
        Inc(i);
        A[i] := j;
        If N > 1 Then Phan_Tich_Thanh_Tich(N, j)
                 Else Xuat(i, '*');
        N := N*j;
        Dec(i);
      End;
  End;

Procedure Phan_Tich_Thanh_Tich_Khac_Nhau(N, Last : Word);
  Var
    j : Word;
  Begin
    For j := Last To N Do
      If (Xet[j] = False)And(N Mod j = 0) Then
      Begin
        N := N Div j;
        Inc(i);
        A[i] := j;
        Xet[j] := True;
        If N > 1 Then Phan_Tich_Thanh_Tich_Khac_Nhau(N, j)
                 Else Xuat(i, '*');
        N := N*j;
        Xet[j] := False;
        Dec(i);
      End;
  End;

Procedure Menu;
  Begin
    Window(1, 1, 80, 25);
    TextAttr := 7;
    ClrScr;
    WriteXY(25, 1, 'BAI TOAN TONG HOP VE PHAN TICH');
    WriteXY(1, 3, 'Chon mot trong cac muc sau:');
    GoToXY(3, 4);
    Write('1. Nhap so can phan tich(', N, ')');
    WriteXY(3, 5, '2. Phan tich thanh tong cac so tu nhien');
    WriteXY(3, 6, '3. Phan tich thanh tong cac so tu nhien doi mot khac nhau');
    WriteXY(3, 7, '4. Phan tich thanh tong binh phuong cac so tu nhien');
    WriteXY(3, 8, '5. Phan tich thanh tich cac so tu nhien');
    WriteXY(3, 9, '6. Phan tich thanh tich cac so tu nhien doi mot khac nhau');
    WriteXY(3, 10, '7. Dung chuong trinh');
    WriteXY(1, 11, 'Muc duoc chon(1..7): ');
  End;

Begin
  N := 0;
  Menu;
  Nhap_Du_Lieu;
  Repeat
    GoToXY(22, 11);
    KP := ReadKey;
    If KP In ['1'..'6'] Then
      If KP = '1' Then Nhap_Du_Lieu
      Else
        Begin
          ClrScr;
          Write('Cac cach phan tich ', N, ' thanh ');
          Case KP Of
            '2' : Write('tong cac so tu nhien la:');
            '3' : Write('tong cac so tu nhien khac nhau la:');
            '4' : Write('tong binh phuong cac so tu nhien la:');
            '5' : Write('tich cac so tu nhien la:');
            '6' : Write('tich cac so tu nhien khac nhau la:');
          End;
          Window(1, 2, 80, 25);
          Khoi_Tao;
          TimeStart := Timer;
          Case KP Of
            '2' : Phan_Tich_Thanh_Tong(N, 1);
            '3' : Phan_Tich_Thanh_Tong_Khac_Nhau(N, 1);
            '4' : Phan_Tich_Thanh_Tong_Binh_Phuong(N, 1);
            '5' : Phan_Tich_Thanh_Tich(N, 2);
            '6' : Phan_Tich_Thanh_Tich_Khac_Nhau(N, 2);
          End;
          TimeFinish := Timer;
          WriteLn('So cach phan tich: ', Dem);
          WriteLn('Thoi gian chay: ', (TimeFinish-TimeStart)/18.2:5:2, ' giay');
          Write('Nhan phim Enter de quay ve MENU...');
          ReadLn;
          Menu;
        End;
  Until KP = '7';
  ClrScr;
End.