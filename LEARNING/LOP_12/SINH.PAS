Uses crt;
Const
  MaxN=100;
  Input='cty.inp';
Var
  F:Text;
  N,M,i,j,k:Integer;
  A:Array[1..MaxN,1..MaxN]Of Byte;
Begin
  Clrscr;
  Randomize;
  Write('N=');Readln(N);
  Write('M=');Readln(M);
  Fillchar(A,sizeof(A),0);
  For k:=1 to M do
    Begin
      Repeat i:=Random(n)+1;j:=Random(n)+1;
      Until (A[i,j]=0)And(A[j,i]=0)And(i<>j);
      A[i,j]:=1;
    End;
  Assign(F,input);
  Rewrite(F);
  Writeln(F,N);
  For i:=1 to n do
    Begin
      For j:=1 to n do Write(F,A[i,j],' ');
      Writeln(F);
    End;
  Close(F);
End.