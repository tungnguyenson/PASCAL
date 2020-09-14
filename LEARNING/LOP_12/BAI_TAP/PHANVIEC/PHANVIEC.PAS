{  De bai:
   1 nguoi can thuc hien N cong viec trong N ngay, moi ngay chi thuc hien 1
   cong viec cac cong viec va ngay duoc danh so tu 1..N. Gia thiet hieu qua
   moi cong viec phu thuoc vao ngay thuc hien no va duoc luong hoa boi 1 so
   nguyen khong am. Goi H[i, j] la hieu qua thuc hien cong viec j vao ngay i.
   Hay sap xep trinh tu thuc hien cac cong viec de tong cac hieu qua la lon
   nhat.
   Du lieu vao cho boi File van ban co dang:
     - Dong thu nhat : so N
     - Ma tran H
   Ket qua ghi ra file van ban gom N so, trong do so thu i (i=1,2..N) la so
   hieu cua cong viec thuc hien tai ngay i. Cac so nay co the ghi cach nhau
   boi dau cach hoac xuong dong.
   VD:
   Du lieu vao:
     5
     4 8 17 19 7
     12 6 17 19 10
     8 19 19 7 7
     17 9 17 3 7
     7 16 12 16 8
   Ket qua:
     Tong hieu qua = 81
     4 5 3 1 2
   Han che kich thuoc N <= 100
  }

Program Phan_Viec;

Uses CRT;

Const
  MaxN = 100;

Type
  TrangThai = (DaXet, ChuaXet);

Var
  H : Array[1..MaxN, 1..MaxN] Of Integer;
  Dong, Cot : Array[1..MaxN]Of TrangThai;
  XetX, XetY : Array[1..MaxN] Of Byte;
  Ghep : Array[1..MaxN] Of Byte;
  Queue, F, UN : Array[1..MaxN*2] Of Integer;
  N : Byte;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    TenTepDL := 'pv.i1';
{    Write('Nhap ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, H[i, j]);
    Close(F);
  End;

{*---------------------*}
{  Thuat toan tham lam  }
{*---------------------*}
Function Tim_Max(Var y, x : Byte) : Boolean;
  Var
    i, j : Byte;
    M : Integer;
  Begin
    M := 0;
    For i := 1 To N Do
      If Dong[i] = ChuaXet Then
        For j := 1 To N Do
          If Cot[i] = ChuaXet Then
            If M < H[i, j] Then
              Begin
                M := H[i, j];
                y := i;
                x := j;
              End;
    Tim_Max := M <> 0;
  End;

Procedure Tham_Lam;
  Var
    i, j : Byte;
    Stop : Boolean;
  Begin
    FillChar(Dong, SizeOf(Dong), ChuaXet);
    FillChar(Ghep, SizeOf(Ghep), 0);
    FillChar(Cot, SizeOf(Cot), ChuaXet);
    Stop := False;
    Repeat
      Stop := Not Tim_Max(i, j);
      If Not Stop Then
        Begin
          Dong[i] := DaXet;
          Cot[j] := DaXet;
          Ghep[i] := j;
        End;
    Until Stop;
  End;

{*---------------------*}
{  Thuat toan ghep cap  }
{*---------------------*}
Procedure Khoi_Tao;
  Var
    i, j : Byte;
    Max : Integer;
  Begin
    FillChar(F, SizeOf(F), 0);
    FillChar(XetX, SizeOf(XetX), 0);
    FillChar(XetY, SizeOf(XetY), 0);
    For i := 1 To N Do
      Begin
        Max := H[i, 1];
        For j := 1 To N Do
          If H[i, j] > Max Then Max := H[i, j];
        F[i] := Max;
      End;
  End;

Function Dinh_Tu_Do : Byte;
  Var
    i : Byte;
  Begin
    Dinh_Tu_Do := 0;
    i := 1;
    While (i <= N)And(XetX[i] <> 0) Do Inc(i);
    If i <= N Then Dinh_Tu_Do := i;
  End;

Function Tim_Duong_Tang_Cap_Ghep(u : Byte; Var z : Byte) : Boolean;
  Var
    Left, Right : Integer;
    i, j : Byte;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    FillChar(UN, SizeOf(UN), 0);
    Left := 1;
    Right := 1;
    Queue[Left] := u;
    UN[u] := u;
    While Left <= Right Do
      Begin
        If u <= N Then
          Begin
            For j := 1 To N Do
              If (F[u]+F[j+N] = H[u, j])And(UN[j+N] = 0) Then
                Begin
                  Inc(Right);
                  Queue[Right] := j+N;
                  UN[j+N] := u;
                End;
          End
         Else If XetY[u-N] = 0 Then
          Begin
            Tim_Duong_Tang_Cap_Ghep := True;
            z := u;
            Exit;
          End
         Else
          Begin
            j := XetY[u-N];
            Inc(Right);
            Queue[Right] := j;
            UN[j] := u;
          End;
        Inc(Left);
        u := Queue[Left];
      End;
    Tim_Duong_Tang_Cap_Ghep := False;
    z := u;
  End;

Procedure Tang_Cap_Ghep(u, z : Byte);
  Var
    y, x : Byte;
    ThuocY : Boolean;
  Begin
    ThuocY := True;
    y := z;
    While y <> u Do
      Begin
        x := UN[y];
        If ThuocY Then
          Begin
            XetX[x] := y-N;
            XetY[y-N] := x;
          End;
        y := x;
        ThuocY := Not ThuocY;
      End;
  End;

Procedure Sua_Nhan;
  Var
    Min, D : Integer;
    i, j : Byte;
  Begin
    Min := $7FFF;
    For i := 1 To N Do
      If UN[i] > 0 Then
        For j := 1 To N Do
          If UN[j+N] = 0 Then
            Begin
              D := F[i]+F[j+N]-H[i, j];
              If D < Min Then Min := D;
            End;
    For i := 1 To N Do
      If UN[i] > 0 Then F[i] := F[i]-Min;
    For j := 1 To N Do
      If UN[j+N] > 0 Then F[j+N] := F[j+N]+Min;
  End;

Procedure Thuc_Hien;
  Var
    u, z : Byte;
  Begin
    Khoi_Tao;
    u := Dinh_Tu_Do;
    While u > 0 Do
      Begin
        If Tim_Duong_Tang_Cap_Ghep(u, z) Then
          Begin
            Tang_cap_Ghep(u, z);
            u := Dinh_Tu_Do;
          End
         Else Sua_Nhan;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    TenTepKQ : String;
    F : Text;
    i : Byte;
  Begin
    TenTepKQ := '';
{    Write('Nhap ten tep ghi ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do Write(F, XetX[i], ' ');
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
{  Write('Nhan phim Enter de ket thuc chuong trinh ...');
  ReadLn;{}
END.