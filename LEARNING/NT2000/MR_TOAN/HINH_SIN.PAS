Uses CRT;

Const
  TenTepDL = 'BAI1.INP';
  TenTepKQ = '';
  Max = 1000;

Var
  Day, DayNew : Array[1..Max] Of Integer;
  M, N : Word;
  ThoaMan : Boolean;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To N Do
      Read(F, Day[i]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu(M, N : Word);
  Var
    F : Text;
    i, j, k, l : Word;
  Begin
    Randomize;
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, M, ' ', N);
    For i := 1 To N Do Day[i] := i;
    For i := 1 To 100 Do
      Begin
        j := Random(N)+1;
        k := Random(N)+1;
        l := Day[j];
        Day[j] := Day[k];
        Day[k] := l;
      End;
    For i := 1 To N Do WriteLn(F, Day[i]);
    Close(F);
  End;

Procedure QSort(Left, Right : Word; HS : ShortInt);
  Var
    L, R : Word;
    X, Tmp : Integer;
  Begin
    L := Left;
    R := Right;
    X := Day[(L+R) Div 2];
    Repeat
      While X*HS > Day[L]*HS Do Inc(L);
      While X*HS < Day[R]*HS Do Dec(R);
      If L <= R Then
        Begin
          Tmp := Day[L];
          Day[L] := Day[R];
          Day[R] := Tmp;
          Inc(L);
          Dec(R);
        End;
    Until L > R;
    If Left < R Then QSort(Left, R, HS);
    If L < Right Then QSort(L, Right, HS);
  End;

Function Kiem_Tra : Boolean;
  Var
    i, j : Word;
    k : ShortInt;
  Begin
    If Day[1] < Day[2] Then k := 1
                       Else k := -1;
    j := 0;
    For i := 2 To N Do
      If Day[i-1]*k < Day[i]*k Then
        Begin
          Inc(j);
          k := -k;
        End;
    Kiem_Tra := j=M+1;
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, L, R : Word;
    Chieu : ShortInt;
  Begin
    QSort(1, N, 1);
    k := N Div (M+1)+1;
    i := 0;
    j := 1;
    Chieu := 1;
    While i < M Do
      Begin
        L := j;
        R := j+k-1;
        j := j+k-1;
        QSort(L, R, Chieu);
        Chieu := -Chieu;
        Inc(i);
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
    Chieu : ShortInt;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If ThoaMan Then Writeln(1)
               Else Writeln(0);
    If Day[1] <= Day[2] Then Chieu := 1
                        Else Chieu := -1;
    i := 1;
    While i <= N Do
      Begin
        Write(F, Day[i], ' ');
        Inc(i);
        If (Day[i-1]*Chieu > Day[i]*Chieu)And(i < N) Then
          Begin
            Dec(i);
            Chieu := -Chieu;
            WriteLn(F);
          End;
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu(2, 20);{}
  Doc_Du_Lieu;
  ThoaMan := Kiem_Tra;
  If Not ThoaMan Then Thuc_Hien;
  Ghi_Ket_Qua;
  ReadLn;
END.