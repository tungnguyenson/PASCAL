{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,655360}
Program baitap;
Uses crt;
Const max=1000;
      fi='bl2.in7';
      fo='bl2.out';
Var A,X,Best:array[0..max]of integer;
    Lg:array[1..max]of boolean;
    DD,Dem:array[1..50]of integer;
    n,k,s,min:integer;
    f:text;
Procedure Khoitao;
   Var i:integer;
   Begin
       Assign(f,fi);
       Reset(f);
           Readln(f,n,k);
           For i:=1 to n do Read(f,A[i]);
       Close(f);
   End;
Procedure Start(i,t:integer);
   Var j:integer;
   Begin
       For j:=1 to t do
         If  lg[j] and (DD[j]<Dem[j]) then
           Begin
               X[i]:=j;
               Inc(DD[j]);
               If (t-j=0) then
                 Begin
                     min:=i; best:=X;
                 End else
               If i+1<min then Start(i+1,t-j);
               Dec(DD[j]);
           End;
   End;
Procedure Lam_viec;
   Var i,j,d,t:integer;
   Begin
       For i:=1 to n do A[i]:=A[i] mod k;
       s:=0;
       For i:=1 to n do s:=s+A[i];
       Assign(f,fo);
       Rewrite(f);
            If s mod k=0 then
              Begin
                  Writeln(f,n);
                  For i:=1 to n do writeln(f,i);
              End else
              Begin
                  d:=s mod k;
                  s:=s div k;
                  Fillchar(Dem,sizeof(dem),0);
                  For i:=1 to n do
                    Begin
                        Inc(Dem[A[i]]); Lg[i]:=true;
                    End;
                  For i:=0 to s do
                    Begin
                        Fillchar(DD,sizeof(DD),0);
                        t:=i*k+d;
                        min:=max+1; X[0]:=1;
                        Start(1,t);
                        If min<>max+1 then
                          Begin
                              Writeln(f,n-min);
                              For i:=1 to min do
                                For j:=1 to n do
                                  If (Best[i]=A[j]) and Lg[j] then
                                    Begin
                                        Lg[j]:=false; break;
                                    End;
                              For i:=1 to n do
                                If Lg[i] then writeln(f,i);
                              Close(f); Halt;
                          End;
                    End;
              End;
           Writeln(f,0);
       Close(f);
   End;
Begin
    Clrscr;
    Khoitao;
    Lam_viec;
End.