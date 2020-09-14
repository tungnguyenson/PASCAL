Program baitap;
Uses crt;
Const fi='bl3.inp';
      fo='bl3.out';
      max=101;
Var X,Y,R:array[1..max]of real;
    L,L1:array[1..max]of set of 1..max;
    Lop:array[1..max,1..max]of 1..max;
    D,Dd,D1:array[1..max]of byte;
    Lg:array[1..max]of boolean;
    n:integer;
    f:text;
Procedure khoitao;
   Var f:text;
       i:integer;
   Begin
       Assign(f,fi);
       Reset(f);
          Readln(f,n);
          For i:=1 to n do readln(f,X[i],Y[i],R[i]);
       Close(f);
   End;
Function chua(i,j:byte):boolean;
   Begin
       If (X[j]+R[j]<=X[i]+R[i])and
          (X[j]-R[j]>=X[i]-R[i])and
          (Y[j]+R[j]<=Y[i]+R[i])and
          (Y[j]-R[j]>=Y[i]-R[i]) then chua:=true else chua:=false;
   End;
Procedure Lamviec;
   Var i,j,dem,ii,max,t:byte;
   Begin
       For i:=1 to n do
         Begin
             Lg[i]:=true;
             L[i]:=[]; D[i]:=0;
             L1[i]:=[]; D1[i]:=0;
         End;
       For i:=1 to n do
         For j:=1 to n do
           If (i<>j) and chua(i,j) then
             Begin
                 Inc(d[i]); L[i]:=L[i]+[j];
                 Inc(d1[j]); L1[j]:=L1[j]+[i];
             End;
        dem:=0;
        t:=0;
        Repeat
            Inc(dem); Dd[dem]:=0;
            For i:=1 to n do
              If lg[i] and (d[i]=0)and(d1[i]=0) then
                Begin
                    Lg[i]:=false;
                    inc(dd[dem]);
                    lop[dem,dd[dem]]:=i;
                    inc(t);
                End;
            Repeat
                max:=0;
                For i:=1 to n do
                  If lg[i] then
                    Begin
                        j:=1;
                        While(j<=dd[dem])and not(lop[dem,j] in l[i])
                             and not(lop[dem,j] in l1[i]) do inc(j);
                        If j>dd[dem] then
                          If d[i]>max then
                            Begin
                                max:=d[i];
                                ii:=i;
                            End;
                    End;
                If max<>0 then
                  Begin
                      inc(dd[dem]);lop[dem,dd[dem]]:=ii;
                      lg[ii]:=false;
                      inc(t);
                  End;
            Until(max=0);
            For i:=1 to n do
              If lg[i]  Then
                For j:=1 to dd[dem] do
                  Begin
                      If lop[dem,j] in l[i] then
                        Begin
                            l[i]:=l[i]-[lop[dem][j]];
                            dec(d[i]);
                        End;
                      If lop[dem,j] in l1[i] then
                        Begin
                            l1[i]:=l1[i]-[lop[dem,j]];
                            dec(d1[i]);
                        End;
                  End;
        Until t>=n;
        Assign(f,fo);
        Rewrite(f);
                Writeln(f,dem);
                for i:=1 to dem do
                 Begin
                     write(f,dd[i],' ');
                     For j:=1 to dd[i] do write(f,lop[i,j],' ');
                     writeln(f);
                 End;
        Close(f);
   End;
Begin
    Clrscr;
    Khoitao;
    Lamviec;
End.