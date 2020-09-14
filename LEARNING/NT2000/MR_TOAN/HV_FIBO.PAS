Uses CRT;

Const
  Direct : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0 ,1), (1, 0));
  Max = 100;
  HVMax = 46;

Type
  HinhVuong = Record
    x, y, a : LongInt;
  End;
  Point = Record
    x, y : Integer;
  End;

Var
  HV : Array[1..Max] Of HinhVuong;
  P : Point;

Procedure Xay_Dung_Hinh_Vuong(i : Word);
  Begin
    If i = 1 Then
      Begin
        HV[i].x := 0;
        HV[i].y := 0;
        HV[i].a := 1;
      End
     Else If i = 2 Then
      Begin
        HV[i].x := 1;
        HV[i].y := 0;
        HV[i].a := 1;
      End
     Else
      With HV[i] Do
        Begin
          a := HV[i-2].a+HV[i-1].a;
          Case (i-3) Mod 4+1 Of
            1 : Begin
                  x := HV[i-1].x+HV[i-1].a-a;
                  y := HV[i-1].y+HV[i-1].a;
                End;
            2 : Begin
                  HV[i].x := HV[i-1].x-a;
                  HV[i].y := HV[i-1].y+HV[i-1].a-a;;
                End;
            3 : Begin
                  HV[i].x := HV[i-1].x;
                  HV[i].y := HV[i-1].y-a;
                End;
            4 : Begin
                  HV[i].x := HV[i-1].x+HV[i-1].a;
                  HV[i].y := HV[i-1].y;
                End;
          End;
        End;
  End;

Procedure Phan_1;
  Var
    i : Word;
    P : Point;
  Begin
    WriteLn('Nhap toa do diem can kiem tra: ');
    Write('  X = ');  ReadLn(P.x);
    Write('  Y = ');  ReadLn(P.y);
    i := 0;
    FillChar(HV, SizeOf(HV), 0);
    Repeat
      Inc(i);
      Xay_Dung_Hinh_Vuong(i);
    Until (i >= HVMax)Or((P.x >= HV[i].x)And(P.y >= HV[i].y)And
          (P.x <= HV[i].x+HV[i].a)And(P.y <= HV[i].y+HV[i].a));
    WriteLn('Diem (', P.x, ',', P.y, ') thuoc hinh vuong:');
    WriteLn('  Do dai canh = ', HV[i].a);
    WriteLn('  Toa do: (', HV[i].x, ', ', HV[i].y, ')');
    WriteLn('  So thu tu: ', i);
  End;

Procedure Phan_2;
  Var
    N, i : Word;
  Begin
    WriteLn;
    Write('Nhap so N: ');
    ReadLn(N);
    i := 0;
    If (N > HVMax)Or(N = 0) Then
      WriteLn('Khong tim duoc hinh vuong thu ', N)
     Else
      Begin
        Repeat
          Inc(i);
          Xay_Dung_Hinh_Vuong(i);
        Until (i >= N)Or(i >= HVMax);
        WriteLn('Hinh vuong thu ', N, ' co toa do: (', HV[i].x, ',', HV[i].y, ')');
        WriteLn('Do dai canh: ', HV[i].a);
     End;
  End;

BEGIN
  ClrScr;
  Phan_1;
  Phan_2;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.