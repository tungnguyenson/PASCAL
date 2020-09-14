{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program An_Toan_Thi_Nghiem;

Uses CRT;

Const
  TenTepDL = 'TN.INP';
  TenTepKQ = 'TN.OUT';
  MaxN = 100;

Type
  DoanThang = Record
    x1, y1, x2, y2 : Integer;
    A, B, C : Real;
  End;

Var
  QD1, QD2 : Array[1..MaxN, 1..2] Of Integer;
  T1, T2 : Array[1..MaxN] OF Integer;
  DT1, DT2 : Array[1..MaxN] Of DoanThang;
  KQ : Array[1..MaxN*MaxN, 1..2] Of Byte;
  DemGiao : Word;
  N1, N2 : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N1);
    For i := 1 To N1 Do
      Read(F, QD1[i, 1], QD1[i, 2]);
    For i := 1 To N1 Do
      Read(F, T1[i]);
    ReadLn(F, N2);
    For i := 1 To N2 Do
      Read(F, QD2[i, 1], QD2[i, 2]);
    For i := 1 To N2 Do
      Read(F, T2[i]);
    Close(F);
  End;

Procedure LapPTDT(Var DT : DoanThang);
  Begin
    With DT Do
      Begin
        A := y2-y1;
        B := x1-x2;
        C := x2*y1-x1*y2;
      End;
  End;

Function NamGiua(x, x1, x2 : Real) : Boolean;
  Begin
    If ((x >= x1)And(x <= x2)) Or ((x <= x1)And(x >= x2)) Then
      NamGiua := True
     Else
      NamGiua := False;
  End;

Function CatDoan(D1, D2 : DoanThang) : Boolean;
  Var
    D, DX, DY : Real;
    x, y : Real;
  Begin
    D := D1.A*D2.B-D1.B*D2.A;
    DX := D1.B*D2.C-D1.C*D2.B;
    DY := D1.C*D2.A-D1.A*D2.C;
    CatDoan := True;
    If D <> 0 Then
      Begin
        X := DX/D;
        Y := DY/D;
        If Not (NamGiua(x, D1.x1, D1.x2) And NamGiua(y, D1.y1, D1.y2) And
                NamGiua(x, D2.x1, D2.x2) And NamGiua(y, D2.y1, D2.y2)) Then
             CatDoan := False;
      End
     Else CatDoan := False;
  End;

Procedure Khoi_Tao;
  Var
    i : Byte;
  Begin
    For i := 1 To N1-1 Do
      Begin
        DT1[i].x1 := QD1[i, 1];
        DT1[i].y1 := QD1[i, 2];
        DT1[i].x2 := QD1[i+1, 1];
        DT1[i].y2 := QD1[i+1, 2];
        LapPTDT(DT1[i]);
      End;
    For i := 1 To N2-1 Do
      Begin
        DT2[i].x1 := QD2[i, 1];
        DT2[i].y1 := QD2[i, 2];
        DT2[i].x2 := QD2[i+1, 1];
        DT2[i].y2 := QD2[i+1, 2];
        LapPTDT(DT2[i]);
      End;
  End;

Function Giao_Thoi_Gian(T1, T2, T3, T4 : Integer) : Integer;
  Var
    i : Integer;
  Begin
    If (T3 <= T1)And(T4 >= T2) Then
      Giao_Thoi_Gian := T2-T1 Else
    If (T1 <= T3)And(T2 >= T4) Then
      Giao_Thoi_Gian := T4-T3 Else
    If (T1 <= T3)And(T2 >= T3)And(T2 <= T4) Then
      Giao_Thoi_Gian := T2-T3 Else
    If (T1 >= T3)And(T1 <= T4)And(T2 >= T4) Then
      Giao_Thoi_Gian := T4-T1
    Else Giao_Thoi_Gian := 0;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    Khoi_Tao;
    DemGiao := 0;
    For i := 1 To N1-1 Do
      For  j := 1 To N2-1 Do
        If CatDoan(DT1[i], DT2[j]) Then
          If Giao_Thoi_Gian(T1[i], T1[i+1], T2[j], T2[j+1]) > 0 Then
            Begin
              Inc(DemGiao);
              KQ[DemGiao, 1] := i;
              KQ[DemGiao, 2] := j;
            End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, DemGiao);
    For i := 1 To DemGiao Do
      WriteLn(F, KQ[i, 1], ' ', KQ[i, 2]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.