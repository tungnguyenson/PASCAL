{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Program baitap;
Uses crt;
Const max=100;
      fi='plan3.';
      fo='';
Var A,B,Vt,Kq,Best:array[1..max]of longint;
    S,S1,smax,ln:longint;
    n:integer;
    f:text;
Procedure Khoi_tao;
   Var i:integer;
   Begin
       Assign(f,fi);
       Reset(f);
           Readln(f,n,s);
           For i:=1 to n do Read(f,A[i]);
           Readln(f);
           For i:=1 to n do Read(f,B[i]);
       Close(f);
       For i:=1 to n do Vt[i]:=i;
   End;
Procedure Sap_xep;
   Var i,j,tg:longint;
   Begin
       For i:=1 to n-1 do
         For j:=i+1 to n do
           If (B[i])/A[i]<(B[j])/A[j] then
             Begin
                 tg:=A[i]; A[i]:=A[j]; A[j]:=tg;
                 tg:=B[i]; B[i]:=B[j]; B[j]:=tg;
                 tg:=Vt[i]; Vt[i]:=Vt[j]; Vt[j]:=tg;
             End;
   End;
Procedure Start(i:integer; S:longint);
   Var j,k,t:longint;
   Begin
       t:=S div A[i];
       For j:=t downto 0 do
         Begin
             Kq[i]:=j;
             Dec(S,A[i]*j);
             ln:=ln+B[i]*Kq[i];
             If (i=n) and (ln>smax) then
               Begin
                   smax:=ln; Best:=kq;
               End else
             If (i<n) and (ln+S*(B[i+1]/A[i+1])>smax) then Start(i+1,S);
             Inc(S,A[i]*j);
             ln:=ln-B[i]*Kq[i];
         End;
   End;
Procedure Lam_viec;
   Var i,j:integer;
   Begin
       Smax:=0;
       Fillchar(kq,sizeof(kq),0);
       Start(1,S);
       Assign(f,fo);
       Rewrite(f);
            Writeln(smax);
            For i:=1 to n do
              Begin
                  j:=1;
                  While Vt[j]<>i do inc(j);
                  Write(f,Best[j],' ');
              End;
       Close(f);
   End;
Begin
    Clrscr;
    Khoi_tao;
    Sap_xep;
    Lam_viec;
End.