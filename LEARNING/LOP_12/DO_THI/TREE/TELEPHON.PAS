{$S-,R-}
Program Mang_Dien_Thoai;

{  Problem:
       Mot cong ty lap mot du an mac dien thoai cho N (N < 100) nhan vien
     cua minh bang mot luoi cac doan noi tu may cua mot nguoi nay den may
     cua mot nguoi khac (khong phai hai nguoi nao cung duoc noi voi nhau).
     Du an phai dam bao yeu cau sau (goi la yeu cau ve 'tinh thong suot'
     cua mang): Tren luoi dien thoai do, moi nhan vien cua cong ty deu co
     the nhan tin cho bat cu mot nhan vien khac hoac truc tiep hoac thong
     qua mot so nhan vien trung gian.
     Du lieu ve du an duoc ghi trong file van ban co ten 'NETW.INP' co cau
     truc nhu sau:
     - Dong dau tien chua so N.
     - Dong tiep theo chua so duong noi.
     - Trong cac dong tiep theo chua cac duong noi cua du an: moi dong gom
       3 so nguyen theo thu tu la chi so cua hai may duoc noi va chi phi
       noi hai may nay.
     Hay lap trinh nhap du lieu tu file sau do:
     a) Kiem tra xem du an co dap ung yeu cau ve tinh thong suot hay khong?
     b) Trong truong hop du an dap ung yeu cau thong suot, hay tim cach
        loai bo mot so duong noi sao cho mang van la thong suot dong thoi
        giam den muc toi thieu chi phi noi mang.
}

USES CRT;

CONST
  Max     = 100;
  DaXet   = 1;
  ChuaXet = 0;
  GiuLai  = 9;
  VoCung  = 255;

VAR
  Canh : Array[1..Max, 1..Max] Of Byte;
  Xet : Array[1..Max] Of Byte;
  N, M, SoTPLT : Byte;
  F : Text;
  ChiPhi : Word;
  TenTepDL, TenTepKQ : String;

PROCEDURE Doc_Du_lieu;
  Var
    i, j, k, l : Byte;
  Begin
    TenTepDL := 'telephon.inp';
{    Write('Nhan ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, N);
    ReadLn(F, M);
    FillChar(Canh, SizeOf(Canh), 0);
    For i := 1 To M Do
      Begin
        ReadLn(F, j, k, l);
        Canh[j, k] := l;
        Canh[k, j] := l;
      End;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Canh[i, j] = 0 Then
          Begin
            Canh[i, j] := VoCung;
            Canh[j, i] := VoCung;
          End;
    Close(F);
  End;

FUNCTION Kiem_Tra_Thong_Suot : Boolean;
  Var
    Stack : Array[1..Max] Of Byte;
    Top, i : Byte;

  Procedure DFS(i, SoLT : Byte);
    Var
      j : Byte;
    Begin
      FillChar(Stack, SizeOf(Stack), 0);
      Top := 1;
      Stack[Top] := i;
      Xet[i] := SoLT;
      Repeat
        j := 1;
        While (j <= N)And((Xet[j] <> ChuaXet)Or(Canh[i, j] = 0)) Do Inc(j);
        If j <= N Then
          Begin
            Xet[j] := SoLT;
            Inc(Top);
            Stack[Top] := j;
            i := j;
          End
         Else
          Begin
            Dec(Top);
            i := Stack[Top];
          End;
      Until Top <= 0;
    End;  {DFS}

  Begin  {Kiem_Tra_Thong_Suot}
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    SoTPLT := 0;
    For i := 1 To N Do
      If Xet[i] = ChuaXet Then
        Begin
          Inc(SoTPLT);
          DFS(i, SoTPLT);
        End;
    Kiem_Tra_Thong_Suot := SoTPLT = 1;
  End;

{Thu tuc giam chi phi bang thuat toan PRIM}
PROCEDURE Giam_Chi_Phi;
  Var
    Stack : Array[1..Max] Of Byte;
    i, j, k, l : Byte;
    Top, Min : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    Min := VoCung;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Canh[i, j] < Min Then
          Begin
            Min := Canh[i, j];
            Stack[1] := i;
            Stack[2] := j;
          End;
    Xet[Stack[1]] := DaXet;
    Xet[Stack[2]] := DaXet;
    Canh[Stack[1], Stack[1]] := GiuLai;
    ChiPhi := Min;
    Top := 2;
    Repeat
      Min := VoCung;
      For i := 1 To Top Do
        For j := 1 To N Do
          If (Xet[j] = ChuaXet)And(Canh[Stack[i], j] < Min) Then
            Begin
              Min := Canh[Stack[i], j];
              k := i;
              l := j;
            End;
      If Min <> VoCung Then
        Begin
          Inc(Top);
          Stack[Top] := l;
          Xet[l] := DaXet;
          Canh[Stack[k], l] := GiuLai;
          Canh[l, Stack[k]] := GiuLai;
          ChiPhi := ChiPhi+Min;
        End;
    Until Min = VoCung;
  End;

PROCEDURE Xuat_Ket_Qua;
  Var
    i, j : Word;
  Begin
    TenTepKQ := 'con';
{    Write('Nhan ten tep ghi ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    ReWrite(F);
    WriteLn(F, ChiPhi);
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Canh[i, j] = GiuLai Then
          WriteLn(F, i, ' ', j);
    Close(F);
    WriteLn('Ket qua duoc ghi vao tep ''', TenTepKQ, '''');
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  If Kiem_Tra_Thong_Suot = True Then
    Begin
      WriteLn('Mang dien thoai la thong suot!');
      Giam_Chi_Phi;
      Xuat_Ket_Qua;
    End
   Else WriteLn('Mang dien thoai da cho khong thong suot!');
  Write('Nhan Enter de ket thuc chuong trinh ...');
  ReadLn;
END.