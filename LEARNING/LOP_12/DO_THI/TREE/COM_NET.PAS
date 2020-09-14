Program Mang_May_Tinh;

{  Problem:
     Nguoi ta dinh to chuc mot mang may tinh gom M*N may duoc bo tri theo
   mot mang o vuong gom M*N nut. Nut cua luoi o hang i cot j goi la nut
   (i, j), i = 1, 2,..., M; j = 1, 2,..., N. Moi may tinh se duoc dat o mot
   nut va cac may duoc noi voi nhau theo canh cua cac o vuong (goi la cac
   duong noi cua mang). Trong khi mang con dang trong qua trinh xay dung
   (moi chi co mot so duong noi nao do duoc xay dung xong), vi phai dua
   mang vao phuc vu kip thoi ky thi Olimpic Tin hoc Quoc te, nguoi ta muon
   kiem tra xem tat ca cac may da trao doi thong tin duoc voi nhau chua
   (hai may bat ky trong mang goi la trao doi thong tin duoc voi nhau neu
   nhu chung co the trao doi thong tin duoc voi nhau hoac la truc tiep,
   hoac thong qua cac may trung gian). Trong truong hop cau tra loi la phu
   dinh, can xac dinh so duong noi it nhat can phai gap rut xay dung truoc
   ao cho tat ca cac may deu trao doi thong tin duoc voi nhau, nham phuc vu
   kip thoi nhiem vu dot xuat noi tren.
   Du lieu ve cac duong noi da xay dung xong duoc cho trong mot file van
   ban co ten 'COMNET.INP' co cau truc nhu sau:
   - Dong dau tien chua hai so M, N.
   - Trong cac dong tiep theo, moi dong chua thong tin ve mot duong noi da
     xay dung xong trong thoi diem hien tai gom 4 so nguyen duong xac dinh
     toa do cua hai may duoc noi voi nhau boi duong noi nay.
   Hay lap trinh nhap du lieu vao tu file, sau do thuc hien cac yeu cac noi
   tren.
}

Uses CRT;

Const
  Max = 50;
  DaXet = 1;
  ChuaXet = 0;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Var
  Canh : Array[1..Max, 1..Max, 1..4] Of Byte;
  Xet : Array[1..Max, 1..Max] Of Byte;
  Stack : Array[1..Max*Max] Of Byte;
  N, M : Byte;
  SoTPLT : Word;
  TenTepDL, TenTepKQ : String;
  F : Text;

Procedure Doc_Du_Lieu;
  Var
    i, j, k, l, m : Byte;
  Begin
    TenTepDL := 'comnet1.inp';
{    Write('Nhan ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, M, N);
    FillChar(Canh, SizeOf(Canh), 0);
    Repeat
      ReadLn(F, i, j, k, l);
      For m := 1 To 4 Do
        If (i = k+Next[m, 1])And(j = l+Next[m, 2]) Then
          Begin
            Canh[i, j, m] := 1;
            Canh[k, l, 5-m] := 1;
          End;
    Until EOF(F);
    Close(F);
  End;

Function Kiem_Tra_Lien_Thong : Boolean;
  Var
    i, j : Byte;

    Procedure DFS(i, j : Byte; SoLT : Word);
      Var
        Top : Word;
        k : Byte;
      Begin
        FillChar(Stack, SizeOf(Stack), 0);
        Top := 0;
        Xet[i, j] := DaXet;
        Repeat
          k := 1;
          While (k <= 4)And((Xet[i+Next[k, 1], j+Next[k, 2]] <> ChuaXet)Or
                (Canh[i, j, k] = 0)) Do Inc(k);
          If k <= 4 Then
            Begin
              Inc(Top);
              Stack[Top] := k;
              Xet[i+Next[k, 1], j+Next[k, 2]] := SoLT;
            End
           Else
            Begin
              i := i+Next[5-Stack[Top], 1];
              j := j+Next[5-Stack[Top], 2];
              Stack[Top] := 0;
              Dec(Top);
            End;
        Until Top <= 0;
      End;

  Begin
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    SoTPLT := 0;
    For i := 1 To M Do
      For j := 1 To N Do
        If Xet[i, j] = ChuaXet Then
          Begin
            Inc(SoTPLT);
            DFS(i, j, SoTPLT);
          End;
  End;

Procedure Xay_Dung;
  Begin
  End;

Procedure Ghi_Ket_Qua;
  Var
    i, j, k, l, m : Byte;
  Begin
    TenTepDL := 'con';
{    Write('Nhan ten tep ghi ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    ReWrite(F);
    Close(F);
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  If Kiem_Tra_Lien_Thong = False Then WriteLn('Luoi may tinh la lien thong!')
   Else
    Begin
      WriteLn('Luoi may tinh khong lien thong!');
    End;
  ReadLn;
End.