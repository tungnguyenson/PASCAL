{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Arithmetic_Power;

Uses CRT;

Const
  TenTepDL = 'APOWER.IN2';
  TenTepKQ = 'APOWER.OUT';
  MaxM = 1000;
  HS = 10;
  MaxN = 9;

Var
  A : Array[1..HS*MaxM] Of ShortInt;
  M : LongInt;
  N : Byte;
  Time : LongInt;

Function Ar(M : LongInt; N : Byte) : Byte;
  Var
    LT : Byte;
    i, j, Max : LongInt;
  Begin
    For i := 1 To HS*MaxM Do A[i] := 0;
    LT := 1;
    A[N] := 1;
    Max := N;
    While A[M] = 0 Do
      Begin
        Inc(LT);
        i := N;
        j := 1;
        While (i <= M*HS)And(j < LT) Do
          Begin
            i := i*10+N;
            Inc(j);
          End;
        If i <= M*HS Then
          If A[i] = 0 Then
	  	      Begin
			     A[i] := LT;
              Max := i;
            End;
        For i := 1 To Max Do
          If A[i] <> 0 Then
          For j := 1 To Max Do
            If (A[j] <> 0)And(A[i]+A[j] = LT) Then
              Begin
                If (i+j <= M*HS)And(A[i+j] = 0) Then
					   Begin
						  A[i+j] := LT;
                    If i+j > Max Then Max := i+j;
                  End;
                If (i-j > 0)And(A[i-j] = 0) Then A[i-j] := LT;
                If (i*j <= M*HS)And(A[i*j] = 0) Then
					   Begin
						  A[i*j] := LT;
                    If i*j > Max Then Max := i*j;
                  End;
                If (i Mod j = 0)And(i Div j > 0)
					    And(A[i Div j] = 0)Then A[i Div j] := LT;
                i := i;
                If A[M] <> 0 Then
                  i := i;
              End;
      End;
    Ar := A[m];
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, M, N);
        WriteLn(FO, Ar(M, N));
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Time := MemL[0:1132];
  Thuc_Hien;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.