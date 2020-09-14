Uses CRT;

Const
  Max = 9;
  TenTepDL = 'TICKET.INP';
  TenTepKQ = 'TICKET.OUT';

Type
  Ticket = Array[1..Max, 1..Max] Of Byte;

Var
  A, B : Ticket;
  P, Q, M, N : Byte;
  i : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To M Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    For i := 1 To M Do
      For j := 1 To N Do
        Read(F, B[i, j]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j, k, l : Byte;
    x1, y1, x2, y2 : Byte;
    C : Ticket;
  Begin
    P := M;
    Q := N;
    i := 0;
    y1 := P;
    x1 := Q;
    y2 := 0;
    x2 := 0;
    For i := 1 To P Do
      For j := 1 To Q Do
        If A[i, j] = 1 Then
          Begin
            If y1 >= i Then y1 := i;
            If x1 >= j Then x1 := j;
            If y2 <= i Then y2 := i;
            If x2 <= j Then x2 := j;
          End;
    For i := y1 To y2 Do
      For j := x1 To x2 Do
        C[i-y1+1, j-x1+1] := A[i, j];
    A := C;
    P := y2-y1+1;
    Q := x2-x1+1;
  End;

Procedure Quay_90_Do;
  Var
    i, j, k : Byte;
    C : Ticket;
  Begin
    k := P;
    For i := 1 To P Do
      For j := 1 To Q Do
        C[j, P-i+1] := A[i, j];
    P := Q;
    Q := k;
    A := C;
  End;

Procedure Lat;
  Var
    C : Ticket;
    i, j : Byte;
  Begin
    For i := 1 To P Do
	   For j := 1 To Q Do
        C[i, Q-j+1] := A[i, j];
    A := C;
  End;

Procedure Xoay(Var T : Ticket; Direct : Byte);
  Begin
    Case Direct Of
      2..4, 6..8 : Quay_90_Do;
      5 : Lat;
    End;
  End;

Procedure Mark1(y, x : Byte);
  Var
    i, j : Byte;
  Begin
    For i := 1 To P Do
      For j := 1 To Q Do
        If (B[i+y-1, j+x-1] <> 2)And(A[i, j] = 1) Then
	   	 If (A[i, j] = 1)And(B[i+y-1, j+x-1] > 0) Then
            B[i+y-1, j+x-1] := 2
           Else Exit;
  End;

Procedure Markup;
  Var
    i, j : Byte;
  Begin
    If (P <= M)And(Q <= N) Then
      For i := 1 To M-P+1 Do
        For j := 1 To N-Q+1 Do
          Mark1(i, j);
  End;

Function Kiem_Tra : Boolean;
  Var
    i, j : Byte;
    KT : Boolean;
  Begin
    KT := True;
    For i := 1 To M Do
      For j := 1 To N Do
        If B[i, j] = 1 Then KT := False;
    Kiem_Tra := KT;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If Kiem_Tra = True Then Write(F, 'YES')
                       Else Write(F, 'NO');
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  For i := 1 To 8 Do
    Begin
      Xoay(A, i);
      Markup;
      If Kiem_Tra = True Then Break;
    End;
  Ghi_Ket_Qua;
END.