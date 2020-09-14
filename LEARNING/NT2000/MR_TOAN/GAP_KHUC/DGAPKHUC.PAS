Program Duong_Gap_Khuc;

{$R-}

Uses CRT;

Const
  Max = 200;

Type
  RealPoint = Record
    x, y : Real;
  End;

Var
  P : Array[1..Max] Of RealPoint;
  N : Byte;
  ChuVi, DienTich : Real;

Function Khoang_Cach(P1, P2 : RealPoint) : Real;
  Begin
    Khoang_Cach := SQRT(SQR(P1.x-P2.x)+SQR(P1.y-P2.y));
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    TenTepDL : String;
    i : Byte;
  Begin
    TenTepDL := 'gk.in1';
{    Write('Nhap ten tep du lieu:');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, P[i].x, P[i].y);
    P[N+1] := P[1];
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    ChuVi := 0;
    For i := 1 To N Do
      ChuVi := ChuVi+Khoang_Cach(P[i], P[i+1]);
    DienTich := 0;
    For i := 1 To N Do
      DienTich := DienTich+(P[i+1].x-P[i].x)*(P[i+1].y+P[i].y);
    DienTich := DienTich/2;
  End;

Procedure Xuat_Ket_Qua;
  Begin
    WriteLn(ChuVi:15:6);
    WriteLn(Abs(DienTich):15:6);
    If DienTich >= 0 Then WriteLn(1)
                     Else WriteLn(0);
  End;

BEGIN
  ClrScr;
  Doc_Du_lieu;
  Thuc_Hien;
  Xuat_Ket_Qua;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.