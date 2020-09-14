{$A+,B-,D+,E+,F+,G+,I+,L+,N+,O+,P+,Q+,R+,S+,T+,V+,X+}
{$M 16384,0,655360}
Program Plan;

Uses CRT;

Const
  TenTepDL = '1.';
  TenTepKQ = '';
  MaxN = 101;

Var
  ChiPhi, GiaBan, LoiNhuan, ChiSo : Array[1..MaxN] Of LongInt;
  SL, KQ, Luu : Array[1..MaxN] Of LongInt;
  N : Byte;
  Time, MaxLoiNhuan, S, LN, CP : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N, S);
    For j := 1 To N Do Read(F, ChiPhi[j]);
    For j := 1 To N Do Read(F, GiaBan[j]);
    Close(F);
  End;

Procedure Swap(Var x, y : LongInt);
  Var
    L : LongInt;
  Begin
    L := x;
    x := y;
    y := L;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do ChiSo[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If GiaBan[i]/ChiPhi[i] < GiaBan[j]/ChiPhi[j] Then
          Begin
            Swap(GiaBan[i], GiaBan[j]);
            Swap(ChiPhi[i], ChiPhi[j]);
            Swap(ChiSo[i], ChiSo[j]);
          End;
  End;

Procedure Duyet(i : Byte);
  Var
    j : LongInt;
  Begin
    For j := (S Div ChiPhi[i]) DownTo 0 Do
      Begin
        SL[i] := j;
        S := S-j*ChiPhi[i];
        LN := LN+j*GiaBan[i];
        If (i < N) And (LN+S*(GiaBan[i+1]/ChiPhi[i+1]) > MaxLoiNhuan)Then
          Duyet(i+1)
         Else
          If (LN > MaxLoiNhuan)And(i = N) Then
            Begin
              MaxLoiNhuan := LN;
              Luu := SL;
            End;
        LN := LN-j*GiaBan[i];
        S := S+j*ChiPhi[i];
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    j : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For j := 1 To N Do KQ[ChiSo[j]] := Luu[j];
    For j := 1 To N Do Write(F, KQ[j], ' ');
    Close(F);
  End;

Procedure Thuc_Hien;
  Begin
    CP := S;
    MaxLoiNhuan := 0;
    LN := 0;
    Khoi_Tao;
    Duyet(1);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Time := MemL[0:1132];
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn;
  WriteLn(MaxLoiNhuan);
  WriteLn((MemL[0:1132]-Time)/18.2:10:5);
  ReadLn;{}
END.