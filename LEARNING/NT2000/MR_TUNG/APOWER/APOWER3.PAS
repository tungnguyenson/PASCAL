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
  Q : Array[1..HS*MaxM] Of LongInt;
  M : LongInt;
  N : Byte;
  Time : LongInt;

Function Ar(M : LongInt; N : Byte) : Byte;
  Var
    LT : Byte;
    i, j, u, v, Top : LongInt;
  Begin
    FillChar(A, SizeOf(A), 0);
    LT := 1;
    Q[1] := N;
    A[N] := 1;
    Top := 1;
    While Q[Top]*10+N < M*HS Do
      Begin
        Inc(Top);
        Q[Top] := Q[Top-1]*10+N;
        A[Q[Top]] := Top;
      End;
    While A[M] = 0 Do
      Begin
        Inc(LT);
        For i := 1 To Top Do
          For j := 1 To Top Do
            If A[Q[i]]+A[Q[j]] = LT Then
              Begin
                u := Q[i];
                v := Q[j];
                If (u+v <= M*HS)And(A[u+v] = 0) Then
					   Begin
						  A[u+v] := LT;
                    Inc(Top);
                    Q[Top] := u+v;
                  End;
                If (u-v > 0)And(A[u-v] = 0) Then
					   Begin
						  A[u-v] := LT;
                    Inc(Top);
                    Q[Top] := u-v;
                  End;
                If (u*v <= M*HS)And(A[u*v] = 0) Then
					   Begin
						  A[u*v] := LT;
                    Inc(Top);
                    Q[Top] := u*v;
                  End;
                If (u Mod v = 0)And(u Div v > 0)And(A[u Div v] = 0)Then
					   Begin
						  A[u Div v] := LT;
                    Inc(Top);
                    Q[Top] := u Div v;
                  End;
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
{        WriteLn(M);{}
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Time := MemL[0:1132];
  Thuc_Hien;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.