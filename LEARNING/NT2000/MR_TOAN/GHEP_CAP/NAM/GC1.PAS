Uses CRT;

Const
  TenTepDL = 'gc.in1';
  TenTepKQ = '';
  MaxN = 100;

Var
  C : Array[1..MaxN, 1..MaxN] Of Integer;
  FX, FY : Array[1..MaxN] Of Integer;
  X, Y, T : Array[1..MaxN] Of Boolean;
  Queue, Truoc : Array[1..MaxN*2] Of Byte;
  M, S : Array[1..MaxN] Of Byte;
  Xet : Array[1..MaxN*2] Of Byte;
  N : Byte;
  Dem : Word;

Procedure Show_Array;
  Var
    i, j : Byte;
  Begin
    ClrScr;
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(C[i, j]:3);
        WriteLn;
      End;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    FillChar(X, SizeOf(X), True);
    FillChar(Y, SizeOf(X), True);
    FillChar(M, SizeOf(M), 0);
    FillChar(Fx, SizeOf(Fx), 0);
    FillChar(Fy, SizeOf(Fy), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        If Fx[i] < C[i, j] Then Fx[i] := C[i, j];
  End;

Function Tim_Duong_Tang_Cap_Ghep(u : Byte) : Byte;
  Var
    Left, Right, i, j, v : Byte;
    Found : Boolean;
  Begin
    Tim_Duong_Tang_Cap_Ghep := 0;
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(Truoc, SizeOf(Truoc), 0);
    FillChar(T, SizeOf(T), True);
    Dem := 1;
    S[Dem] := u;
    Xet[u] := 1;
    Left := 1;
    Right := 1;
    Queue[Left] := u;
    Repeat
      i := 1;
      j := 2*N;
      If u <= N Then i := N+1
                Else j := N;
      For v := i To j Do
        If Xet[v] = 0 Then
          Begin
            Found := False;
            If u <= N Then
              Begin
                If (Fx[u]+Fy[v-N] = C[u, v-N])And(M[u] <> v-N) Then Found := True
              End
             Else If (Fx[v]+Fy[u-N] = C[v, u-N])And(M[v] = u-N) Then Found := True;
            If Found Then
              Begin
                Inc(Right);
                Queue[Right] := v;
                Xet[v] := 1;
                Truoc[v] := u;
                If v <= N Then
                  Begin
                    Inc(Dem);
                    S[Dem] := v;
                  End
                 Else
                  Begin
                    T[v-N] := False;
                    If Y[v-N] Then
                      Begin
                        Tim_Duong_Tang_Cap_Ghep := v;
                        Exit;
                      End;
                  End;
              End;
          End;
      Inc(Left);
      u := Queue[Left];
    Until Left > Right;
  End;

Procedure Tang_Cap_Ghep(u : Byte);
  Var
    v, td, i, j : Word;
    Luu : Array[1..MaxN, 1..2] Of Byte;
  Begin
    td := 0;
    Luu[td+1, 2] := u;
    While u <> 0 Do
      Begin
        u := Truoc[u];
        Luu[td+1, 1] := u;
        u := Truoc[u];
        Luu[td+2, 2] := u;
        Inc(td);
      End;
    For i := td DownTo 1 Do
      Begin
        u := Luu[i, 1];
        v := Luu[i, 2]-N;
        If M[u] <> v Then
          Begin
            j := 1;
            While (j <= N)And(M[j] <> v) Do Inc(j);
            If j <= N Then
              Begin
                M[j] := 0;
                X[j] := True;
              End;
            If M[u] <> 0 Then Y[M[u]] := True;
            M[u] := v;
            X[u] := False;
            Y[v] := False;
          End;
      End;
  End;

Procedure Sua_Nhan;
  Var
    i, j, D : Integer;
  Begin
    D := MaxInt;
    For i := 1 To Dem Do
      For j := 1 To N Do
        If T[j] And (D > Fx[S[i]]+Fy[j]-C[S[i], j]) Then
          D := Fx[S[i]]+Fy[j]-C[S[i], j];
    For i := 1 To Dem Do Dec(Fx[S[i]], D);
    For j := 1 To N Do
      If T[j] = False Then Inc(Fy[j], D);
  End;

Procedure Thuc_Hien;
  Var
    u, z : Byte;
  Begin
    Khoi_Tao;
    Repeat
      u := 1;
      While (u <= N)And(X[u] = False) Do Inc(u);
      If u <= N Then
        Begin
          z := Tim_Duong_Tang_Cap_Ghep(u);
          If z = 0 Then Sua_Nhan
                   Else Tang_Cap_Ghep(z);
        End;
    Until u > N;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
    Tong : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    Tong := 0;
    For i := 1 To N Do
      Tong := Tong+C[i, M[i]];
    For i := 1 To N Do
      Write(F, M[i], ' ');
    WriteLn(F);
    Write(F, Tong);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Show_Array;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.