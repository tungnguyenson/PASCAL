{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O+,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  TenTepDL = 'BL1.IN4';
  TenTepKQ = 'BL1.OUT';
  MaxMN = 200;

Type
  Dong = Array[0..MaxMN] Of Word;

Var
  Grid : Array[0..MaxMN] Of ^Dong;
  Mau : Array[0..MaxMN] Of Byte;
  M, N : Word;
  K, MaxMau : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j, x, y : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N, K);
    If LongInt(M*N)*2 <= MemAvail Then
      Begin
        For i := 0 To N Do New(Grid[i]);
        For i := 0 To N Do
          For j := 0 To M Do
            Grid[i]^[j] := 0;
        For i := 1 To K Do
          Begin
            ReadLn(F, x, y);
            Grid[y]^[x] := 1;
          End;
      End
     Else
      Begin
        WriteLn('Not enough memory to continue!');
        Halt;
      End;
    Close(F);
  End;

Procedure ShowGrid;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do
      Begin
        For j := 1 To M Do Write(Grid[i]^[j]:3);
        WriteLn;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    FI, FO : Text;
    i, j, x, y : Word;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    ReadLn(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    WriteLn(FO, MaxMau);
    For i := 1 To K Do
      Begin
        ReadLn(FI, x, y);
        WriteLn(FO, Grid[y]^[x]);
      End;
    Close(FO);
    Close(FI);
  End;

Procedure Greedy;
  Var
    i, j, k, u, v : Word;
  Begin
    MaxMau := 0;
    For i := 0 To N Do
      For j := 0 To M Do
        If Grid[i]^[j] <> 0 Then
          Begin
            FillChar(Mau, SizeOf(Mau), 0);
            If i > 0 Then
              For u := 1 To i-1 Do
                If Grid[u]^[j] <> 0 Then Mau[Grid[u]^[j]] := 1;
            If j > 0 Then
              For v := 1 To j-1 Do
                If Grid[i]^[v] <> 0 Then Mau[Grid[i]^[v]] := 1;
            k := 1;
            While Mau[k] <> 0 Do Inc(k);
            Grid[i]^[j] := k;
          End;
  End;

Procedure FreeMemory;
  Var
    i : Word;
  Begin
    For i := 1 To N Do
      Dispose(Grid[i]);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
{  ShowGrid;{}
  Greedy;
  Ghi_Ket_Qua;
  FreeMemory;
END.