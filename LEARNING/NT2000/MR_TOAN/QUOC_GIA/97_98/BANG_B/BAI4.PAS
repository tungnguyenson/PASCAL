{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}
Program baitap;
Uses crt;
Const max=51;
      fi='bl4.inp';
      fo='bl4.out';
Var P,D,C,Cs,P1,C1:array[1..max]of longint;
    n:integer;
    f:text;
Procedure Khoitao;
   Var i:integer;
   Begin
       Assign(f,fi);
       Reset(f);
           Readln(f,n);
           For i:=1 to n do Readln(f,P[i],D[i],C[i]);
       Close(f);
       P1:=P; C1:=C;
   End;
Procedure Lam_viec;
   Var i,j,tg,t:integer;
       s1,s2:longint;
   Begin
       For i:=1 to n do Cs[i]:=i;
       For i:=1 to n-1 do
         For j:=i+1 to n do
           If P[i]*C[j]>P[j]*C[i] then
             Begin
                 tg:=P[i]; P[i]:=P[j]; P[j]:=tg;
                 tg:=C[i]; C[i]:=C[j]; C[j]:=tg;
                 tg:=Cs[i]; Cs[i]:=Cs[j]; Cs[j]:=tg;
             End;
       t:=0; s1:=0; s2:=0;
       For i:=1 to n do
         Begin
             t:=t+P1[Cs[i]];
             If t<=D[Cs[i]] then s1:=s1+(D[Cs[i]]-t)*C1[Cs[i]] else
                                 s2:=s2+(t-D[Cs[i]])*C1[Cs[i]];
         End;
       Assign(f,fo);
       Rewrite(f);
            Writeln(f,s1);
            Writeln(f,s2);
            For i:=1 to n do writeln(f,Cs[i]);
       Close(f);
   End;
Begin
    Clrscr;
    Khoitao;
    Lam_viec;
End.