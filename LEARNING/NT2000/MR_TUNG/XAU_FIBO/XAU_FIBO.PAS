Uses CRT;

Const
  TenTepDL = 'FIB.INP';
  TenTepKQ = 'FIB.OUT';
  MaxN = 35;
  MaxM = 51;

Var
  F : Array[1..20] Of String;
  Xau : Array[1..MaxM] Of String;
  SL : Array[1..MaxM] Of LongInt;
  P : Array[1..MaxN] Of LongInt;
  HS : Array[0..1] Of Byte;
  S1, S2 : String;
  M, N, K : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    ReadLn(F, S1);
    ReadLn(F, S2);
    M := 0;
    While Not EOF(F) Do
      Begin
        Inc(M);
        ReadLn(F, Xau[M]);
      End;
    Close(F);
  End;

Procedure Tim_K_Min(S : String);
  Begin
    F[1] := S1;
    F[2] := S2;
    K := 1;
    While Length(F[K]) < Length(S) Do
      Begin
        Inc(K);
        If K > 2 Then F[K] := F[K-1]+F[K-2];
      End;
    If K = 1 Then K := 2;
  End;

Function SoLanXH(S0, S : String) : Word;
  Var
    i, Dem : Byte;
  Begin
    Dem := 0;
    i := Pos(S0, S);
    While i <> 0 Do
      Begin
        Inc(Dem);
        Delete(S, 1, i);
        i := Pos(S0, S);
      End;
    SoLanXH := Dem;
  End;

Procedure Tinh_He_So(S : String);
  Var
    i : Byte;
  Begin
    For i := 1 To 3 Do
      F[K+i] := F[K+i-1]+F[K+i-2];
    For i := 1 To 4 Do
      P[K+i-1] := SoLanXH(S, F[K+i-1]);
    If K Mod 2 = 0 Then
      Begin
        HS[0] := P[K+2]-P[K+1]-P[K];
        HS[1] := P[K+3]-P[K+2]-P[K+1];
      End
     Else
      Begin
        HS[1] := P[K+2]-P[K+1]-P[K];
        HS[0] := P[K+3]-P[K+2]-P[K+1];
      End
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    For i := 1 To M Do
      Begin
        FillChar(P, SizeOf(P), 0);
        Tim_K_Min(Xau[i]);
        Tinh_He_So(Xau[i]);
        For j := K+4 To N Do
          P[j] := P[j-1]+P[j-2]+HS[j Mod 2];
        SL[i] := P[N];
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To M Do
      WriteLn(F, SL[i]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.

F1  = A
F2  = B
F3  = BA
F4  = BAB                                 0 1
F5  = BABBA                               1 2
F6  = BABBABAB                            1 3
F7  = BABBABABBABBA                       3 4
F8  = BABBABABBABBABABBABAB               4 5
F9  = BABBABABBABBABABBABABBABBABABBABBA  8 6
F10 =                                    13 7
F11 =                                    21 8
F12 =                                    35 9
BABBABABBABBABABBABABBABBABABBABBABABBABABBABBABABBABAB

123
ABC
ABC123
ABC123ABC
ABC123ABCABC123
