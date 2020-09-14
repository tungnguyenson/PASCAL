Program baitap;
Uses crt;
Const max=128;
      fi='bl1.in5';
      fo='bl1.out';
Var A,B:array[1..max,1..max]of byte;
    D,C:array[1..max,1..2]of byte;
    n,dd,dc:integer;
    f:text;
Procedure Khoitao;
   Var i,j:integer;
   Begin
       Fillchar(A,sizeof(a),0);
       Fillchar(B,sizeof(b),0);
       Assign(f,fi);
       Reset(f);
           Readln(f,n);
           For i:=1 to n do
             Begin
                 For j:=1 to n do Read(f,A[i,j]);
                 Readln(f);
             End;
           For i:=1 to n do
             Begin
                 For j:=1 to n do Read(f,B[i,j]);
                 Readln(f);
             End;
       Close(f);
   End;
Procedure Bien_doi_dong(i,j:byte);
   Var tg,t:integer;
   Begin
       For t:=1 to n do
         Begin
             tg:=A[i,t]; A[i,t]:=A[j,t]; A[j,t]:=tg;
         End;
   End;
Procedure Bien_doi_cot(i,j:byte);
   Var tg,t:integer;
   Begin
       For t:=1 to n do
         Begin
             tg:=A[t,i]; A[t,i]:=A[t,j]; A[t,j]:=tg;
         End;
   End;
Function Ktra:boolean;
   Var i,j:integer;
   Begin
       Ktra:=false;
       For i:=1 to n do
         For j:=1 to n do
           If A[i,j]<B[i,j] then Exit;
       Ktra:=true;
   End;
Procedure Lam_viec;
   Var i,j,t:integer;
   Begin
       dd:=0; dc:=0;
       For i:=1 to n do
         If A[i,1]<>B[i,1] then
           Begin
               t:=1;
               While A[t,1]<>B[i,1] do inc(t);
               Inc(dd);
               D[dd,1]:=i; D[dd,2]:=t;
               Bien_doi_dong(i,t);
           End;
       For j:=1 to n do
         If A[1,j]<>B[1,j] then
           Begin
               t:=1;
               While A[1,t]<>B[1,j] do inc(t);
               Inc(dc);
               C[dc,1]:=j; C[dc,2]:=t;
               Bien_doi_cot(j,t);
           End;
       Assign(f,fo);
       Rewrite(f);
            If Ktra then
              Begin
                  Writeln(f,dd+dc);
                  For i:=1 to dd do
                    Writeln(f,1,' ',D[i,1],' ',D[i,2]);
                  For i:=1 to dc do
                    Writeln(f,2,' ',C[i,1],' ',C[i,2]);
              End else write(f,-1);
       Close(f);
   End;
Begin
    Clrscr;
    Khoitao;
    lam_viec;
End.