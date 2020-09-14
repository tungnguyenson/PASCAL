{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Arithmetic_Power;

Uses CRT;

Const
  TenTepDL = 'APOWER.IN2';
  TenTepKQ = 'APOWER.OUT';
  MaxM = 1000;
  HS = 3;
  MaxN = 9;

Var
  A : Array[1..9, 1..HS*MaxM*2] Of ShortInt;
  Xet : Array[1..9] Of LongInt;
  M : LongInt;
  N : Byte;
  Time : LongInt;

Procedure Tim(M : LongInt; N : Byte);
  Var
    LT : Byte;
    i, j, Max : LongInt;
  Begin
    For i := 1 To HS*MaxM Do A[N, i] := 127;
    LT := 1;
    A[N, N] := 1;
    Max := N;
    While A[N, M] = 127 Do
      Begin
        Inc(LT);
        i := N;
        j := 1;
        While (i <= M*2)And(j < LT) Do
          Begin
            i := i*10+N;
            Inc(j);
          End;
        If i <= M*2 Then
          If LT < A[N, i] Then
	  	      Begin
			     A[N, i] := LT;
              Max := i;
            End;
        For i := 1 To Max Do
          For j := 1 To Max Do
            If (A[N, i] <> 0)And(A[N, j] <> 0)And(A[N, i]+A[N, j] = LT)
				   And(i+j <= M*HS) Then
              Begin
                If LT < A[N, i+j] Then
					   Begin
						  A[N, i+j] := LT;
                    If i+j > Max Then Max := i+j;
                  End;
                If (i-j > 0)And(LT < A[N, i-j]) Then A[N, i-j] := LT;
                If (i*j <= MaxM)And(LT < A[N, i*j]) Then
					   Begin
						  A[N, i*j] := LT;
                    If i*j > Max Then Max := i*j;
                  End;
                If (i >= j)And(i Mod j = 0)And(i Div j > 0)
					    And(LT < A[N, i Div j])Then A[N, i Div j] := LT;
                i := i;
              End;
      End;
  End;

Procedure Khoi_Tao;
  Var
    i, j : LongInt;
  Begin
    For i := 1 To 9 Do Xet[i] := 0;
    For i := 1 To 9 Do
      For j := 1 To MaxM*HS Do
        A[i, j] := 0;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    While Not EOF(F) Do
      Begin
        ReadLn(F, M, N);
        If Xet[N] < M Then Xet[N] := M;
        Xet[N] := M;
      End;
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j : LongInt;
  Begin
    For i := 1 To 9 Do
      If Xet[i] <> 0 Then
		  Begin
		    Tim(Xet[i]*HS, i);
          WriteLn(i, ': ', (MemL[0:1132]-Time)/18.2:0:5);
        End;
  End;

Procedure Ghi_Ket_Qua;
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
        WriteLn(FO, A[N, M]);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  ClrScr;
  Time := MemL[0:1132];
  Khoi_Tao;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
  
END.