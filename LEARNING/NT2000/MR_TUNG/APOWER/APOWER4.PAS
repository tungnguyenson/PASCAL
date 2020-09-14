{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Arithmetic_Power;

Uses CRT;

Const
  TenTepDL = 'APOWER.IN4';
  TenTepKQ = 'APOWER.OUT';
  MaxM = 1000;
  HS = 10;
  MaxN = 9;

Type
  Mang = Array[1..HS*MaxM] Of ShortInt;

Var
  A : Array[1..9] Of ^Mang;
  Q : Array[1..HS*MaxM] Of LongInt;
  Xet : Array[1..9] Of Word;
  M : LongInt;
  N : Byte;
  Time : LongInt;

Procedure Khoi_Tao;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    While Not EOF(F) Do
      Begin
        ReadLn(F, M, N);
        If Xet[N] < M Then Xet[N] := M;
      End;
    Close(F);
  End;

Procedure Tim(M : LongInt; N : Byte);
  Var
    LT : Byte;
    i, j, u, v, Top, SoPT : LongInt;
  Begin
    FillChar(A[N]^, SizeOf(A[N]^), 0);
    LT := 1;
    Q[1] := N;
    A[N]^[N] := 1;
    Top := 1;
    SoPT := 1;
    While Q[Top]*10+N < M*HS Do
      Begin
        Inc(Top);
        Q[Top] := Q[Top-1]*10+N;
        A[N]^[Q[Top]] := Top;
        If Q[Top] <= M Then Inc(SoPT);
      End;
    While SoPT < M Do
      Begin
        Inc(LT);
        For i := 1 To Top Do
          If A[N]^[Q[i]] < LT Then
          For j := 1 To Top Do
            If A[N]^[Q[i]]+A[N]^[Q[j]] = LT Then
              Begin
                u := Q[i];
                v := Q[j];
                If (u+v <= M*HS)And(A[N]^[u+v] = 0) Then
					   Begin
						  A[N]^[u+v] := LT;
                    Inc(Top);
                    Q[Top] := u+v;
                    If Q[Top] <= M Then Inc(SoPT);
                  End;
                If (u-v > 0)And(A[N]^[u-v] = 0) Then
					   Begin
						  A[N]^[u-v] := LT;
                    Inc(Top);
                    Q[Top] := u-v;
                    If Q[Top] <= M Then Inc(SoPT);
                  End;
                If (u*v <= M*HS)And(A[N]^[u*v] = 0) Then
					   Begin
						  A[N]^[u*v] := LT;
                    Inc(Top);
                    Q[Top] := u*v;
                    If Q[Top] <= M Then Inc(SoPT);
                  End;
                If (u Mod v = 0)And(u Div v > 0)And(A[N]^[u Div v] = 0)Then
					   Begin
						  A[N]^[u Div v] := LT;
                    Inc(Top);
                    Q[Top] := u Div v;
                    If Q[Top] <= M Then Inc(SoPT);
                  End;
              End;
      End;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
  Begin
    For i := 1 To 9 Do New(A[i]);
    For i := 1 To 9 Do
      If Xet[i] <> 0 Then
		  Begin
		    Tim(Xet[i], i);
          WriteLn('M = ', Xet[i], ', N = ', i,' : ',
			         (MemL[0:1132]-Time)/18.2:0:5, ' giay');
        End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    FI, FO : Text;
    i : Byte;
    Dem : LongInt;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    Dem := 0;
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, M, N);
        Write(FO, A[N]^[M]:2, ',');
        Inc(Dem);
        If Dem Mod 25 = 0 Then
		    Begin
			   WriteLn(FO);
          End;
      End;
    Close(FO);
    Close(FI);
    For i := 1 To 9 Do Dispose(A[i]);
  End;

BEGIN
  ClrScr;
  Time := MemL[0:1132];
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.