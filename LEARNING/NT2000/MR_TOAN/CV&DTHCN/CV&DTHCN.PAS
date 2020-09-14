{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  MaxHCN = 100;

Type
  IntPoint = Record
    x, y : Integer;
  End;
  Hinh_Chu_Nhat = Record
    x1, y1, x2, y2 : Integer;
  End;

Var
  HCN : Array[1..MaxHCN]  Of Hinh_Chu_Nhat;
  DuongBao : Array[1..MaxHCN*4+1] Of IntPoint;
  Giao : Array[1..MaxHCN*MaxHCN] Of IntPoint;
  SoGD, N, DiemDB : Word;
  ChuVi, DienTich : LongInt;
  P0 : intPoint;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i : Byte;
  Begin
    TenTepDL := 'HCN.I1';
{    Write('Nhan ten tep du lieu: ');
    ReadLn(TentepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, HCN[i].x1, HCN[i].y1, HCN[i].x2, HCN[i].y2);
    Close(F);
  End;

Function Diem_Nam_Giua(A, B, C : IntPoint) : Boolean;
  Begin
  End;

Procedure Tim_Duong_Bao_Quanh;
  Var
    Direct, i, j, k, l, StartPoint : Byte;
    P1, P2 : IntPoint;
  Begin

    StartPoint := 1;
    P1.x := HCN[StartPoint].x2;
    P1.y := HCN[StartPoint].y1;
    For j := 2 To N Do
      If (HCN[j].y1 < P1.y)Or((HCN[j].y1 = P1.y) And (HCN[j].x2 > P1.x)) Then
        Begin
          P1.x := HCN[j].x2;
          P1.y := HCN[j].y1;
          StartPoint := j;
        End;
    P2.x := HCN[StartPoint].x2;
    P2.y := HCN[StartPoint].y2;
    i := StartPoint;

    FillChar(DuongBao, Sizeof(DuongBao), 0);
    DiemDB := 1;
    DuongBao[DiemDB] := P1;
    Direct := 1;
    Repeat
      k := i;
      i := N+1;
      Case Direct Of
        1 :
          Begin
            For j := 1 To N Do
              If (j <> k)And(HCN[j].x1 <= P1.x)And(HCN[j].x2 >= P1.x) And
                 (((HCN[j].y1 > P1.y)And(HCN[j].y1 <= P2.y)) Or
                 ((HCN[j].y2 > P1.y)And(HCN[j].y2 <= P2.y))) Then
                If (i > N)Or(HCN[j].y1 < HCN[i].y1) Then
                  i := j;
            If i <= N Then
              Begin
                If (HCN[i].y1 >= P1.y)And(HCN[i].y1 <= P2.y) Then
                  P1.y := HCN[i].y1
                 Else P1.y := HCN[i].y2;
                P2.x := HCN[i].x2;
                P2.y := P1.y;
                Direct := 4;
              End
             Else
              Begin
                P1 := P2;
                P2.x := HCN[k].x1;
                P2.y := HCN[k].y2;
                Direct := 2;
                i := k;
              End;
          End;
        3 :
          Begin
            For j := 1 To N Do
              If (j <> k)And(HCN[j].x1 <= P1.x)And(HCN[j].x2 >= P1.x) And
                 (((HCN[j].y1 >= P2.y)And(HCN[j].y1 < P1.y)) Or
                 ((HCN[j].y2 >= P2.y)And(HCN[j].y2 < P1.y))) Then
                If (i > N)Or(HCN[j].y2 > HCN[i].y2) Then
                  i := j;
            If i <= N Then
              Begin
                If (HCN[i].y2 >= P2.y)And(HCN[i].y2 <= P1.y) Then
                  P1.y := HCN[i].y2
                 Else P1.y := HCN[i].y1;
                P2.x := HCN[i].x1;
                P2.y := P1.y;
                Direct := 2;
              End
             Else
              Begin
                P1 := P2;
                P2.x := HCN[k].x2;
                P2.y := HCN[k].y1;
                Direct := 4;
                i := k;
              End;
          End;
        2 :
          Begin
            For j := 1 To N Do
              If (j <> k)And(HCN[j].y1 <= P1.y)And(HCN[j].y2 >= P1.y) And
                 (((HCN[j].x1 >= P2.x)And(HCN[j].x1 < P1.x)) Or
                 ((HCN[j].x2 >= P2.x)And(HCN[j].x2 < P1.x))) Then
                If (i > N)Or(HCN[j].x2 > HCN[i].x2) Then
                  i := j;
            If i <= N Then
              Begin
                If (HCN[i].x2 >= P2.x)And(HCN[i].x2 <= P1.x) Then
                  P1.x := HCN[i].x2
                 Else P1.x := HCN[i].x1;
                P2.x := P1.x;
                P2.y := HCN[i].y2;
                Direct := 1;
              End
             Else
              Begin
                P1 := P2;
                P2.x := HCN[k].x1;
                P2.y := HCN[k].y1;
                Direct := 3;
                i := k;
              End;
          End;
        4 :
          Begin
            For j := 1 To N Do
              If (j <> k)And(HCN[j].y1 <= P1.y)And(HCN[j].y2 >= P1.y) And
                 (((HCN[j].x1 > P1.x)And(HCN[j].x1 <= P2.x)) Or
                 ((HCN[j].x2 > P1.x)And(HCN[j].x2 <= P2.x))) Then
                If (i > N)Or(HCN[j].x1  < HCN[i].x1) Then
                  i := j;
            If i <= N Then
              Begin
                If (HCN[i].x1 <= P2.x)And(HCN[i].x1 >= P1.x) Then
                  P1.x := HCN[i].x1
                 Else P1.x := HCN[i].x2;
                P2.x := P1.x;
                P2.y := HCN[i].y1;
                Direct := 3;
              End
             Else
              Begin
                P1 := P2;
                P2.x := HCN[k].x2;
                P2.y := HCN[k].y2;
                Direct := 1;
                i := k;
              End;
          End;
      End;
      Inc(DiemDB);
      DuongBao[DiemDB] := P1;
      WriteLn(DiemDB);
    Until (P2.x = DuongBao[1].x)And(P2.y = DuongBao[1].y);
    Inc(DiemDB);
    DuongBao[DiemDB] := P2;
    DuongBao[DiemDB+1] := DuongBao[1];
  End;

Procedure Tinh_ChuVi_Va_Dien_Tich;
  Var
    i : Word;
  Begin
    ChuVi := 0;
    For i := 1 To DiemDB Do
      If DuongBao[i].x <> DuongBao[i+1].x Then
        ChuVi := ChuVi+Abs(DuongBao[i+1].x-DuongBao[i].x)
       Else
        ChuVi := ChuVi+Abs(DuongBao[i+1].y-DuongBao[i].y);
    DienTich := 0;
    For i := 1 To DiemDB Do
       DienTich := DienTich+(DuongBao[i+1].x-DuongBao[i].x)*(DuongBao[i+1].y+DuongBao[i].y);
    DienTich := Abs(Round(DienTich/2));
  End;

Procedure Tim_Giao_Diem;
  Var
    i, j : Word;
  Begin
    FillChar(Giao, SizeOf(Giao), 0);
    SoGD := 0;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        Begin
          If (HCN[j].x1 >= HCN[i].x1) And (HCN[j].x1 <= HCN[i].x2) And
             (HCN[j].y1 <= HCN[i].y2) And (HCN[j].y2 >= HCN[i].y2) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[j].x1;
              Giao[SoGD].y := HCN[i].y2;
            End;
          If (HCN[j].x1 >= HCN[i].x1) And (HCN[j].x1 <= HCN[i].x2) And
             (HCN[j].y1 <= HCN[i].y1) And (HCN[j].y2 >= HCN[i].y1) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[j].x1;
              Giao[SoGD].y := HCN[i].y1;
            End;
          If (HCN[j].x2 >= HCN[i].x1) And (HCN[j].x2 <= HCN[i].x2) And
             (HCN[j].y1 <= HCN[i].y2) And (HCN[j].y2 >= HCN[i].y2) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[j].x2;
              Giao[SoGD].y := HCN[i].y2;
            End;
          If (HCN[j].x2 >= HCN[i].x1) And (HCN[j].x2 <= HCN[i].x2) And
             (HCN[j].y1 <= HCN[i].y1) And (HCN[j].y2 >= HCN[i].y1) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[j].x2;
              Giao[SoGD].y := HCN[i].y1;
            End;

          If (HCN[j].y2 >= HCN[i].y1) And (HCN[j].y2 <= HCN[i].y2) And
             (HCN[j].x1 <= HCN[i].x1) And (HCN[j].x2 >= HCN[i].x1) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[i].x1;
              Giao[SoGD].y := HCN[j].y2;
            End;
          If (HCN[j].y2 >= HCN[i].y1) And (HCN[j].y2 <= HCN[i].y2) And
             (HCN[j].x1 <= HCN[i].x2) And (HCN[j].x2 >= HCN[i].x2) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[i].x2;
              Giao[SoGD].y := HCN[j].y2;
            End;
          If (HCN[j].y1 >= HCN[i].y1) And (HCN[j].y1 <= HCN[i].y2) And
             (HCN[j].x1 <= HCN[i].x1) And (HCN[j].x2 >= HCN[i].x1) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[i].x1;
              Giao[SoGD].y := HCN[j].y1;
            End;
          If (HCN[j].y1 >= HCN[i].y1) And (HCN[j].y1 <= HCN[i].y2) And
             (HCN[j].x1 <= HCN[i].x2) And (HCN[j].x2 >= HCN[i].x2) Then
            Begin
              Inc(SoGD);
              Giao[SoGD].x := HCN[i].x2;
              Giao[SoGD].y := HCN[j].y1;
            End;
        End;
  End;

Procedure Tim_Diem_Chung;
  Var
    i, j, k, Max : Word;
  Begin
    For i := 1 To N Do
      Begin
        Inc(SoGD);
        Giao[SoGD].x := HCN[i].x1;
        Giao[SoGD].y := HCN[i].y1;
        Inc(SoGD);
        Giao[SoGD].x := HCN[i].x1;
        Giao[SoGD].y := HCN[i].y2;
        Inc(SoGD);
        Giao[SoGD].x := HCN[i].x2;
        Giao[SoGD].y := HCN[i].y2;
        Inc(SoGD);
        Giao[SoGD].x := HCN[i].x2;
        Giao[SoGD].y := HCN[i].y1;
      End;
    If SoGD > MaxHCN*MaxHCN Then
       Begin
         WriteLn('Khong khai bao du mang!');
         Halt;
       End;

    Max := 0;
    For i := 1 To SoGD Do
      With Giao[i] Do
        Begin
          k := 0;
          For j := 1 To N Do
            With HCN[j] Do
              If (x >= x1)And(x <= x2)And(y >= y1)And(y <= y2) Then Inc(k);
          If k > Max Then
            Begin
              Max := k;
              P0 := Giao[i];
            End;
        End;
  End;

Procedure Xuat_Ket_Qua;
  Var
    i : Word;
  Begin
    WriteLn('Dien tich hinh bi phu : ', DienTich);
    WriteLn('Chu vi duong bao quanh: ', ChuVi);
    WriteLn('Diem thuoc nhieu hinh nhat: (', P0.x, ',', P0.y, ')');
    WriteLn('Thuoc nhung hinh: ');
    For i := 1 To N Do
      With HCN[i] Do
        If (P0.x >= x1)And(P0.x <= x2)And(P0.y >= y1)And(P0.y <= y2) Then
          Write(i:4);
    WriteLn;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Tim_Duong_Bao_Quanh;
  Tinh_ChuVi_Va_Dien_Tich;
  Tim_Giao_Diem;
  Tim_Diem_Chung;
  Xuat_Ket_Qua;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.