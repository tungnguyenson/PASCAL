Uses CRT;

Const
  TenTepDL = 'BL2.IN3';
  TenTepKQ = 'BL2.OUT';
  MaxN = 1000;

Var
  A, B, C, D : Array[1..MaxN] Of Word;
  Xet : Array[1..MaxN] Of Byte;
  N, M, K, TongMax, Tong, S, u, v : Word;
  Found : Boolean;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N, K);
    For i := 1 To N Do Read(F, A[i]);
    Close(F);
  End;

Procedure Swap_Word(Var x, y : Word);
  Var
    i : Word;
  Begin
    i := x;
    x := y;
    y := i;
  End;

Procedure QSort(Left, Right : Word);
  Var
    L, R, X : Word;
  Begin
    L := Left;
    R := Right;
    X := B[(L+R) Div 2];
    Repeat
      While X > B[L] Do Inc(L);
      While X < B[R] Do Dec(R);
      If L <= R Then
        Begin
          Swap_Word(B[L], B[R]);
          Swap_Word(C[L], C[R]);
          Inc(L);
          Dec(R);
        End;
    Until L > R;
    If Left < R Then QSort(Left, R);
    If L < Right Then QSort(L, Right);
  End;

Procedure Khoi_Tao;
  Var
    i : Word;
  Begin
    FillChar(Xet, SizeOf(Xet), 1);
    For i := 1 To N Do
      A[i] := A[i] Mod k;
    M := 0;
    TongMax := 0;
    For i := 1 To N Do
      If A[i] <> 0 Then
        Begin
          TongMax := TongMax+A[i];
          Inc(M);
          B[M] := A[i];
          C[M] := i;
        End;
    Tong := TongMax Mod k;
    QSort(1, M);
  End;

Procedure Tim(i : Word);
  Var
    j, l : Word;
  Begin
    For j := 1 DownTo 0 Do
      Begin
        D[i] := j;
        If j = 1 Then
          Begin
            S := S+B[i];
            If S Mod k = Tong Then
              Begin
                Found := True;
                For l := 1 To i Do
                  If D[l] = 1 Then Xet[C[l]] := 0;
              End;
          End;
        If (Not Found)And(i < M) Then Tim(i+1)
          Else
           i := i;
        If j <> 0 Then S := S-B[i];
      End;
  End;

Procedure Thuc_Hien;
  Var
    i : Word;
  Begin
    Khoi_Tao;
    FillChar(D, SizeOf(D), 0);
    Found := False;
    Time := MemL[0:1132];
    If Tong <> 0 Then
      Begin
        i := 1;
        While (i <= M)And(B[i] <> Tong) Do Inc(i);
        If i > M Then Tim(1)
         Else
          Begin
            Found := True;
            Xet[C[i]] := 0;
          End;
      End
     Else
      Begin
        Found := True;
        For i := 1 To N Do
          If A[i] Mod k <> 0 Then Xet[i] := 0;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, Dem : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If Not Found Then WriteLn(F, 0)
     Else
      Begin
        Dem := 0;
        For i := 1 To N Do
          If Xet[i] = 1 Then Inc(Dem);
        WriteLn(F, Dem);
        For i := 1 To N Do
          If Xet[i] = 1 Then Write(F, i, ' ');
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.