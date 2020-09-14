{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S-,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepDL = 'BL3.IN8';
  TenTepKQ = 'BL3.OU8';
  MaxN = 100;
  MaxGiaTri = 200;

Var
  A : Array[1..MaxN, 1..MaxN] Of Byte;
  Xet, NguyenTo, B, FX : Array[1..MaxGiaTri] Of Byte;
  SoSoNT : Word;
  SoPT, N : Byte;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Tim_So_Nguyen_To;
  Var
    i, j : Byte;
  Begin
    FillChar(B, SizeOf(B), 1);
    B[1] := 0;
    For i := 2 To Round(Sqrt(MaxGiaTri)) Do
      For j := 2 To MaxGiaTri Div i Do
        B[i*j] := 0;
    SoSoNT := 0;
    For i := 1 To MaxGiaTri Do
      If B[i] = 1 Then
        Begin
          Inc(SoSoNT);
          NguyenTo[SoSoNT] := i;
        End;
  End;

Procedure PhanTich(i, X, Last : Byte);
  Var
    j : Byte;
  Begin
    For j := Last+1 To SoSoNT Do
      If (Xet[j] = 0)And(NguyenTo[j] <= X) Then
        Begin
          Xet[j] := 1;
          X := X-NguyenTo[j];
          If (X > 1)And(X >= NguyenTo[j+1]) Then PhanTich(i+1, X, j);
          If (X = 0)And(SoPT < i) Then SoPT := i
           Else If (X > 0)And(B[X] = 1)And(SoPT < i+1) Then SoPT := i+1;
          Xet[j] := 0;
          X := X+NguyenTo[j];
        End;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    Tim_So_Nguyen_To;
    FillChar(FX, SizeOf(FX), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        FX[A[i, j]] := 1;
    For i := 1 To MaxGiaTri Do
      If FX[i] = 1 Then
        Begin
          FillChar(Xet, SizeOf(Xet), 0);
          SoPT := 0;
          PhanTich(1, i, 0);
          FX[i] := SoPT;
        End;
    FX[1] := 1;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(F, FX[A[i, j]]:3);
        WriteLn(F);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Time := MemL[0:1132];
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn((MemL[0:1132]-Time)/18.2:0:11);
END.