{
Nhap N va dien day mang 2 chieu kich thuoc N*N bang cac so 1, 2, 3,...
theo hinh xoan oc.
}

Program Xoan_Oc;

Uses CRT;

Const
  Max = 100;

Var
  A : Array[1..Max, 1..Max] Of Word;
  N, i, j, k, So : Word;

Begin
  ClrScr;
  Repeat
    Write('Nhap so N<=',Max,': ');
    ReadLn(N);
  Until (N <= Max)And(N > 0);
  k := 1;
  So := 1;
  {Bat dau dien mang}
  For i := 1 To (N Div 2) Do
  Begin
    For j := k To N-K Do
    Begin
      A[k, j] := j-k+So+(N-(K-1)*2-1)*0;
      A[j, N-k+1] := j-k+So+(N-(K-1)*2-1)*1;
      A[N-k+1, (N-K+1-j)+k] := j-k+So+(N-(K-1)*2-1)*2;
      A[N-k+1-j+k, k] := j-k+So+(N-(K-1)*2-1)*3;
    End;{For}
    Inc(So, (N-(K-1)*2-1)*4);
    Inc(k);
  End;{For}
  {Dien phan tu cuoi cung}
  If N Mod 2 = 1 Then A[N Div 2+1, N Div 2+1] := So;
  {Xuat mang}
  For i := 1 To N Do
    For j := 1 To N Do
      If j < N Then Write(A[i, j]:4)
               Else WriteLn(A[i, j]:4);
  ReadLn;
End.