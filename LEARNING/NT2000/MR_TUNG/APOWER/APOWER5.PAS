{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Arithmetic_Power;

Uses CRT;

Const
  TenTepDL = 'APOWER.IN1';
  TenTepKQ = 'APOWER.OUT';
  MaxM = 1000;
  HS = 10;
  MaxN = 9;

Var
  KQ : Array[1..9, 1..MaxM] Of ShortInt;
  A : Array[1..HS*MaxM] Of ShortInt;
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
    Power : Byte;
    i, j, k, u, v, Top, PT, SoPT : LongInt;
    NewPT, OldPT : Array[1..MaxM] Of LongInt;
  Begin
    FillChar(A, SizeOf(A), 0);
    Power := 1;
    Q[1] := N;
    A[N] := 1;
    Top := 1;
    SoPT := 1;
    While Q[Top]*10+N < M*HS Do
      Begin
        Inc(Top);
        Q[Top] := Q[Top-1]*10+N;
        A[Q[Top]] := Top;
        If Q[Top] <= M Then Inc(SoPT);
      End;
    NewPT[1] := 1;
    PT := 1;
    While SoPT < M Do
      Begin
        Inc(Power);
        k := PT;
        PT := 0;
        For i := 1 To k Do
          For j := 1 To Top Do
            If A[NewPT[i]]+A[Q[j]] = Power Then
              Begin
                u := NewPT[i];
                v := Q[j];
                If (u+v <= M*HS)And(A[u+v] = 0) Then
					   Begin
						  A[u+v] := Power;
                    Inc(PT);
                    NewPT[Top] := u+v;
                    If NewPT[PT] <= M Then Inc(SoPT);
                  End;
                If (u-v > 0)And(A[u-v] = 0) Then
					   Begin
						  A[u-v] := Power;
                    Inc(PT);
                    NewPT[PT] := u-v;
                    If NewPT[PT] <= M Then Inc(SoPT);
                  End;
                If (u*v <= M*HS)And(A[u*v] = 0) Then
					   Begin
						  A[u*v] := Power;
                    Inc(PT);
                    NewPT[PT] := u*v;
                    If NewPT[PT] <= M Then Inc(SoPT);
                  End;
                If (u Mod v = 0)And(u Div v > 0)And(A[u Div v] = 0)Then
					   Begin
						  A[u Div v] := Power;
                    Inc(PT);
                    NewPT[PT] := u Div v;
                    If NewPT[PT] <= M Then Inc(SoPT);
                  End;
              End;
        If PT > 0 Then
          Begin
            Top := Top+PT;
            For i := 1 To PT Do Q[Top+i] := NewPT[i];
            OldPT
          End;
      End;
    For i := 1 To M Do KQ[N, i] := A[i];
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
  Begin
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
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, M, N);
        WriteLn(FO, KQ[N, M]);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  ClrScr;
  Time := MemL[0:1132];
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.