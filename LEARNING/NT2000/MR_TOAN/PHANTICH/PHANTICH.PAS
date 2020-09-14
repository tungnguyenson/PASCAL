{
  Hay phan tich so nguyen duong N thanh tong  cac so nguyen duong khac nhau
  sao cho tich so cua chung la lon nhat.
  Du lieu vao:
    - So N
  Du lieu ra:
    - Dong dau la so so hang K cua phan tich
    - K dong tiep la K so hang trong phan tich  ghi cach nhau it nhat 1 dau
      cach hoac xuong dong.
}

Program Phan_Tich;

{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepDL = 'SO.INP';
  TenTepKQ = 'SO.OUT';

Var
  N, K, S, SSH : Word;
  A : Array[1..MaxInt] Of Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    Read(F, N);
    Close(F);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepKQ);
    ReWrite(F);
    If N = 1 Then 
      Begin
        WriteLn(F, 1);
        WriteLn(F, 1);
      End
     Else
      Begin
        WriteLn(F, SSH);
        For i := 1 To K+1 Do
          If A[i] = 1 Then WriteLn(F, i);
      End;
    Close(F);
  End;

Procedure PT;
  Var
    i : Word;
  Begin
    FillChar(A, SizeOf(A), 0);
    S := 2;
    K := 2;
    A[2] := 1;
    While S < N Do
      Begin
        Inc(K);
        A[K] := 1;
        Inc(S, K);
      End;
    SSH := K-1;
    If S <> N Then
      Begin
        i := S-N;
        If (i >=2) And(i <= K) Then
          Begin
            A[i] := 0;
            Dec(SSH);
          End
         Else If i = 1 Then
           Begin
             A[K] := 0;
             A[2] := 0;
             A[K+1] := 1;
             Dec(SSH);
           End;
      End;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  PT;
  Ghi_Ket_Qua;
END.
