{
  Trong mat phang toa do cho 1 hinh chu nhat co 2 dinh doi dien la (0,0,W,H).
  Tren cac canh cua hinh chu nhat nguoi ta xet cac cap diem sao cho moi cap
  diem xac dinh 1 duong thang cat hinh chu nhat. Gia thiet cac duong thang
  nay la khac nhau.
  Hay xac dinh so phan bi cat cua hinh chu nhat.
  DL vao: HCN.INP
    - Dong dau la W va H
    - So cap diem K
    - K dong tiep moi dong  mo ta 1  cap diem gom  4 gia tri  toa do (2 gia
      tri toa do cho 1 diem).
      Cac gia tri  toa do la nguyen  0..32767. K <= 100
      Gia thiet du lieu vao la dung dan.
  DL ra: HCN.OUT
    - So phan bi cat.

    Vi du:
    HCN.INP
      6 4
      6
      0 2 6 2
      0 3 6 0
      1 0 3 4
      4 0 5 4
      0 4 2 4
      3 0 6 3

    HCN.OUT
      13
}

Program Mien_Hinh_Chu_Nhat;

{$M 16384,0,655360}
{$N+,Q+,R+}

Uses CRT;

Const
  TenTepDL = 'HCN.INP';
  TenTepKQ = 'HCN.OUT';
  Max = 100;

Type
  DoanThang = Record
    x1, y1, x2, y2 : LongInt;
    A, B, C : Single;
  End;

Var
  DT : Array[1..Max] Of DoanThang;
  QH : Array[1..Max, 1..Max] Of Word;
  DC : Array[0..(Max*Max-1) Div 2, 1..2] Of Single;
  W, H, K, SoDiemCat, SoMien : Word;

Function GiaTri(DT : DoanThang; x, y : Single) : Single;
  Begin
    GiaTri := DT.A*x+DT.B*y+DT.C;
  End;

Procedure LapPTDT(Var DT : DoanThang);
  Begin
    With DT Do
      Begin
        A := y2-y1;
        B := x1-x2;
        C := x2*y1-x1*y2;
      {  Note: (x2*y1) and (x1*y2) may be overflow!}
      End;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Word;
    x1, y1, x2, y2 : LongInt;
    thu : Single;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, W, H);
    ReadLn(F, K);
    j := 0;
    For i := 1 To K Do
      Begin
        ReadLn(F, x1, y1, x2, y2);
        If ((y1 <> H)Or(y2 <> H))And((y1 <> 0)Or(y2 <> 0))And
           ((x1 <> 0)Or(x2 <> 0))And((x1 <> W)Or(x2 <> W)) Then
          Begin
            Inc(j);
            DT[j].x1 := x1;
            DT[j].y1 := y1;
            DT[j].x2 := x2;
            DT[j].y2 := y2;
            LapPTDT(DT[j]);
          End;
      End;
    K := j;
    Close(F);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
  Begin
    Assign(F, TenTepKQ);
    ReWrite(F);
    WriteLn(F, SoMien);
    Close(F);
  End;

Function Cat(D1, D2 : DoanThang; Var X, Y : Single) : Boolean;
  Var
    D, DX, DY : Single;
  Begin
    D := D1.A*D2.B-D1.B*D2.A;
    DX := D1.B*D2.C-D1.C*D2.B;
    DY := D1.C*D2.A-D1.A*D2.C;
    Cat := True;
    If D <> 0 Then
      Begin
        X := DX/D;
        Y := DY/D;
        If (X <= 0)Or(Y <= 0)Or(X >= W)Or(Y >= H) Then Cat := False;
      End
     Else Cat := False;
  End;

Procedure Khoi_Tao;
  Var
    i, j, l : Word;
    x, y : Single;
  Begin
    FillChar(QH, SizeOf(QH), 0);
    SoDiemCat := 0;
    For i := 1 To K-1 Do
      For j := i+1 To K Do
      Begin
            If (i = 4)And(j = 7) Then
              l := l;
        If Cat(DT[i], DT[j], x, y) Then
          Begin
            l := 1;
            While (l <= SoDiemCat) And
              ((DC[l, 1] <> x)Or(DC[l, 2] <> y)) Do Inc(l);
            If l > SoDiemCat Then
              Begin
                Inc(SoDiemCat);
                DC[SoDiemCat, 1] := x;
                DC[SoDiemCat, 2] := y;
                l := SoDiemCat;
              End;
            QH[i, j] := l;
            QH[j, i] := l;
          End;
          End;
  End;

Procedure Tinh_So_Mien;
  Var
    i, j, SoDC : Word;
    XetDC : Array[1..(Max*Max-1) Div 2] Of Byte;
  Begin
    SoMien := 1;
    For i := 1 To K Do
      Begin
        FillChar(XetDC, SizeOf(XetDC), 0);
        SoDC := 0;
        For j := 1 To i-1 Do
          If (QH[i, j] <> 0)And(XetDC[QH[i, j]] = 0) Then
            Begin
              Inc(SoDC);
              Inc(SoMien);
              XetDC[QH[i, j]] := 1;
            End;
        Inc(SoMien);
      End;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Tinh_So_Mien;
  Ghi_Ket_Qua;
END.