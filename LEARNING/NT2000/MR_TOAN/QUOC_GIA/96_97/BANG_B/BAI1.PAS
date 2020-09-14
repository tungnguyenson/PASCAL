{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

Program day_hinh_sin;
Uses crt;
Const max=1010;
      fi='bai1.in5';
      fo='bai1.out';
Var A:array[1..max]of integer;
    m,n,nghiem:integer;
    i,j,d:integer;
    f:text;
Procedure Khoitao;
   Var i:integer;
   Begin
       Fillchar(A,sizeof(a),0);
       Assign(f,fi);
       Reset(f);
           Readln(f,m,n);
           For i:=1 to n do Read(f,A[i]);
       Close(f);
   End;
Function Ktra:boolean;
   Begin
       d:=0; i:=1;
       While i<n do
          Begin
              If A[i+1]>=A[i] then
                Begin
                    While (A[i]<=A[i+1]) and (i<n) do inc(i);
                    inc(d);
                End else
                Begin
                    While (A[i]>=A[i+1]) and (i<n) do inc(i);
                    Inc(d);
                End;
          End;
       If d=m+1 then ktra:=true else Ktra:=false;
   End;
Procedure Xuat;
   Begin
       Writeln(f,nghiem);
       i:=1;
       While i<=n do
          Begin
              If A[i+1]<A[i] then
                Begin
                    While (A[i]>A[i+1]) and (i<=n) do
                       Begin
                           Write(f,A[i],' '); inc(i);
                       End;
                    If i<=n then Writeln(f,A[i]) else Writeln(f);
                End else
                Begin
                    While (A[i]<A[i+1]) and (i<=n) do
                       Begin
                           Write(f,A[i],' '); inc(i);
                       End;
                    If i<=n then Writeln(f,A[i]) else Writeln(f);
                End;
          End;
   End;
Procedure Sap_xep;
   Var tg,i1,j1,t1:integer;
       ok:boolean;
   Begin
       For i:=1 to n-1 do
         For j:=i+1 to n do
           If a[i]>a[j] then
             Begin
                 tg:=A[i]; A[i]:=A[j]; A[j]:=tg;
             End;
       i1:=1; j1:=n; ok:=true;
       For t1:=1 to m do
         Begin
             If ok then Writeln(f,A[i1],' ',A[j1]) else
                        Writeln(f,A[j1],' ',A[i1]);
             If ok then inc(i1) else dec(j1);
             ok:=not ok;
         End;
       If ok then
         For t1:=i1 to j1 do write(f,A[t1],' ') else
         For t1:=j1 downto i1 do write(f,A[t1],' ');
   End;
Procedure Lam_viec;
   Begin
       Assign(f,fo);
       Rewrite(f);
       If ktra then
         Begin
             nghiem:=1; Xuat;
         End else
         Begin
             Writeln(f,0);  Sap_xep;
         End;
       Close(f);
   End;
Begin
    Clrscr;
    Khoitao;
    Lam_viec;
End.