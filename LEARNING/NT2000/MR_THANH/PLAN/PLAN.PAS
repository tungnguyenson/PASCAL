{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Plan;

Uses CRT;

Const
  TenTepDL = '1';
  TenTepKQ = '';
  MaxN = 100;

Var
  ChiPhi, GiaBan, LoiNhuan, ChiSo : Array[0..MaxN] Of Word;
  SL, KQ, Luu : Array[1..MaxN] Of LongInt;
  N : Byte;
  Time, MaxLoiNhuan, MaxChiPhi, S, LN, CP : LongInt;
  Found : Boolean;

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

Procedure Swap(Var x, y : Word);
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
    ChiPhi[0] := 0;
    GiaBan[0] := 0;
    For i := 0 To N Do
      LoiNhuan[i] := GiaBan[i]-ChiPhi[i];
  End;

Procedure Duyet(i : Byte);
  Var
    j, k : LongInt;
  Begin
    If Not Found Then
    For j := (CP Div ChiPhi[i]) DownTo 0 Do
      Begin
        SL[i] := j;
        CP := CP-j*ChiPhi[i];
        LN := LN+j*LoiNhuan[i];
        If (i < N) Then Duyet(i+1)
         Else
          Begin
            If MaxChiPhi > (S-CP) Then Found := True;
            If LN > MaxLoiNhuan Then
              Begin
                MaxLoiNhuan := LN;
                MaxChiPhi := (S-CP);
                Luu := SL;
              End;
          End;
        LN := LN-j*LoiNhuan[i];
        CP := CP+j*ChiPhi[i];
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
    MaxChiPhi := 0;
    LN := 0;
    Found := False;
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