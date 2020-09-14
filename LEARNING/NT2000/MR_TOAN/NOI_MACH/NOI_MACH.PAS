Program Noi_Mach;

Uses CRT;

Const
  MaxN = 150;
  MaxValue = 100;

Var
  Noi : Array[1..MaxN, 1..MaxN] Of Integer;
  Busy : Array[1..MaxN] Of Byte;
  M, S, Fx, Fy : Array[1..MaxN] Of Integer;
  X, Y, T : Array[1..MaxN] Of Boolean;
  Truoc, Queue, Xet : Array[1..MaxN*2] Of Byte;
  N, SoDauVao : Byte;
  Dem : Word;

Procedure Show_Array;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(Noi[i, j]:5);
      End;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    S, TenTepDL : String;
    i, j, M : Byte;
    k : Integer;
    Ch : Char;
  Begin
    TenTepDL := 'noi.inp';
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    M := 0;
    For i := 1 To MaxN Do
      For j := 1 To MaxN Do
        Noi[i, j] := MaxValue;
    For i := 1 To N Do
      Begin
        S := '';
        Repeat
          Read(F, Ch);
          If Ch In ['0'..'9'] Then S := S+Ch;
          If (EOLn(F)) Or ((Ch = ' ')And(S <> '')) Then
            Begin
              Val(S, j, k);
              Noi[i, j] := 1;
              If j > M then M := j;
              S := '';
            End;
        Until EOLn(F);
        ReadLn(F);
      End;
    ReadLn(F, i);
    FillChar(Busy, SizeOf(Busy), 0);
    For j := 1 To i Do
      Begin
        Read(F, k);
        Busy[k] := 1;
      End;
    Close(F);
    SoDauVao := N;
    If M > N Then N := M;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    For j := 1 To N Do
      If Busy[j] = 1 Then
        For i := 1 To N Do
          If Noi[i, j] = 1 Then Noi[i, j] := MaxValue Div 2;
    FillChar(X, SizeOf(X), True);
    FillChar(Y, SizeOf(Y), True);
    FillChar(M, SizeOf(M), 0);
    FillChar(Fx, SizeOf(Fx), 0);
    For j := 1 To N Do
      Begin
        Fy[j] := MaxValue;
        For i := 1 To N Do
          If Fy[j] > Noi[i, j] Then Fy[j] := Noi[i, j];
      End;
    For i := 1 To N Do
      For j := 1 To N Do
        If (Fx[i]+Fy[j] = Noi[i, j])And(X[i])And(Y[j]) Then
          Begin
            M[i] := j;
            X[i] := False;
            Y[j] := False;
          End;{}
  End;

Function Tim_Duong_Tang_Cap_Ghep(u : Byte) : Byte;
  Var
    Left, Right : Word;
    v, i, j, k : Word;
  Begin
    Tim_Duong_Tang_Cap_Ghep := 0;
    FillChar(Truoc, SizeOf(Truoc), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(T, SizeOf(T), True);
    Dem := 1;
    S[Dem] := u;
    Queue[1] := u;
    Left := 1;
    Right := 1;
    Xet[u] := 1;
    Repeat
      i := 1;
      j := 2*N;
      If u <= n Then i := N+1
                Else j := N;
      For v := i To j Do
        If Xet[v] = 0 Then
          Begin
            k := 0;
            If (u <= N) Then
              Begin
                If (Fx[u]+Fy[v-N] = Noi[u, v-N])And(M[u] <> v-N) Then k := 1;
              End
             Else
            If (u > N) Then
              If (Fx[v]+Fy[u-N] = Noi[v, u-N])And(M[v] = u-N) Then k := 1;
            If k = 1 Then
              Begin
                Inc(Right);
                Queue[Right] := v;
                Truoc[v] := u;
                Xet[v] := 1;
                If v <= N Then
                  Begin
                    Inc(Dem);
                    S[Dem] := v;
                  End
                 Else T[v-N] := False;
               If (v > N) Then
                 If Y[v-N] = True Then
                   Begin
                     Tim_Duong_Tang_Cap_Ghep := v;
                     Exit;
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
        Inc(td);
        Luu[td, 1] := u;
        u := Truoc[u];
        Luu[td+1, 2] := u;
      End;
    For i := td DownTo 1 Do
      Begin
        u := Luu[td, 1];
        v := Luu[td, 2]-N;
        If M[u] <> v Then
          Begin
            j := 1;
            While (j <= N)And(M[j] <> v) Do Inc(j);
            If j <= N Then
              Begin
                M[j] := 0;
                X[j] := True;
              End;
            If M[u] <> 0 Then X[M[u]] := True;
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
        If T[j] And (D > Noi[S[i], j]-Fx[S[i]]-Fy[j]) Then
          D := Noi[S[i], j]-Fx[S[i]]-Fy[j];
    For i := 1 To Dem Do Inc(Fx[S[i]], D);
    For j := 1 To N Do
      If T[j] = False Then Dec(Fy[j], D);
  End;

Procedure Thuc_Hien;
  Var
    u, z : Word;
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
    TenTepKQ : String;
    i, SL : Byte;
  Begin
    TenTepKQ := 'noi.out';
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);{}
    SL := 0;
    For i := 1 To SoDauVao Do
      If Busy[M[i]] = 1 Then Inc(SL);
{    For i := 1 To SoDauVao Do Write(M[i], ' ');
    WriteLn;{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SL);
    For i := 1 To SoDauVao Do
      If Busy[M[i]] = 1 Then Write(F, M[i], ' ');
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.