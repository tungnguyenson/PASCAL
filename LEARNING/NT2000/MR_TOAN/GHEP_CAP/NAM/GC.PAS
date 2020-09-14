{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses crt;
Const
  MaxN=100;
  Input='gc.in1';
  Output='';
Var
  F:Text;
  N,tds:Integer;
  M,S:Array[1..MaxN]Of Integer;
  Fx,Fy:Array[1..MaxN]Of Integer;
  X,Y,T:Array[1..MaxN]Of BooLean;
  A:Array[1..MaxN,1..MaxN]Of Integer;
  Tr,Q:Array[1..2*MaxN]Of Integer;
  Chuaxet:Array[1..2*MaxN]Of Boolean;
Procedure Ddl;
  Var i,j:Integer;
  Begin
    Assign(F,Input);
    Reset(F);
    Readln(F,N);
    For i:=1 to n do
      Begin
        For j:=1 to n do Read(F,A[i,j]);
        Readln(F);
      End;
    Close(F);
  End;
Procedure KhoiTao;
  Var i,j:Integer;
  Begin
    Fillchar(X,Sizeof(X),True);
    Fillchar(Y,Sizeof(Y),True);
    Fillchar(M,Sizeof(M),0);
    Fillchar(Fx,Sizeof(Fx),0);
    Fillchar(Fy,Sizeof(Fy),0);
    For i:=1 to n do
    For j:=1 to n do
      If Fx[i]<A[i,j] Then Fx[i]:=A[i,j];
{    For i:=1 to n do
    For j:=1 to n do
      If (X[i])And(Y[j])And(Fx[i]+Fy[j]=A[i,j])Then
        Begin
          M[i]:=j;
          X[i]:=False;
          Y[j]:=False;
        End;}
  End;
Function Tim(u:Integer):Integer;
  Var i,j,d,c,v,k:Integer;
  Begin
    Tim:=0;
    tds:=1;S[1]:=u;
    Fillchar(Tr,Sizeof(Tr),0);
    Fillchar(T,Sizeof(T),True);
    Fillchar(Chuaxet,Sizeof(Chuaxet),True);
    D:=1;C:=1;Q[1]:=u;Chuaxet[u]:=False;
    While D<=C Do
      Begin
        u:=Q[D];Inc(D);
        i:=1;j:=2*N;
        If u<=n then i:=n+1 Else j:=n;
        For v:=i to j do
          If Chuaxet[v] Then
          Begin
            k:=0;
            If (u<=N)And(Fx[u]+Fy[v-n]=A[u,v-n])And(M[u]<>v-n) Then k:=1 Else
            If (u>N)And(Fx[v]+Fy[u-n]=A[v,u-n])And(M[v]=u-n) Then k:=1;
            If k=1 Then
              Begin
                Inc(c);
                Q[c]:=v;Tr[v]:=u;
                Chuaxet[v]:=False;
                If v<=n then
                  Begin Inc(tds);S[tds]:=v;
                  End Else T[v-n]:=False;
                If (v>n)And(Y[v-n]) Then
                  Begin Tim:=v;Exit;
                  End;
              End;
          End;
      End;
  End;
Procedure TangCapGhep(u:Integer);
  Var i,j,v,td:Integer;
      Luu:Array[1..MaxN,1..2]Of Integer;
  Begin
    Td:=0;Luu[1,2]:=u;
    While u<>0 Do
      Begin
        u:=Tr[u];
        Inc(td);Luu[td,1]:=u;
        u:=tr[u];Luu[td+1,2]:=u;
      End;
    For i:=td downto 1 do
      Begin
        u:=Luu[i,1];v:=Luu[i,2]-n;
        If M[u]<>v Then
          Begin
            j:=1;
            While (j<=N)And(M[j]<>v) Do Inc(j);
            If j<=N then
              Begin X[j]:=True;M[j]:=0;
              End;
            If M[u]<>0 Then Y[M[u]]:=True;
            M[u]:=v;
            X[u]:=False;
            Y[v]:=False;
          End;
      End;
  End;
Procedure Suanhan;
  Var i,j,D:Integer;
  Begin
    D:=MaxInt;
    For i:=1 to tds do
      For j:=1 to n do
        If (T[j])And(D>Fx[S[i]]+Fy[j]-A[S[i],j]) Then
                               D:=Fx[S[i]]+Fy[j]-A[S[i],j];
    For i:=1 to tds do Fx[s[i]]:=Fx[s[i]]-D;
    For j:=1 to n do
      If T[j]=False Then Fy[j]:=Fy[j]+D;
  End;
Procedure Inkq;
  Var i,j,t:Integer;
  Begin
    t:=0;
    For i:=1 to n do t:=t+A[i,m[i]];
    Assign(F,Output);
    Rewrite(F);
    Writeln(F,T);
    For i:=1 to n do Write(F,M[i],' ');
    Close(F);
  End;
Procedure Giai;
  Var u,z:Integer;
  Begin
    KhoiTao;
    Repeat
      u:=1;
      While (u<=N)And(X[u]=False) Do Inc(u);
      If u<=N Then
        Begin
          z:=Tim(u);
          If z=0 Then Suanhan
                 Else TangCapGhep(Z);
        End;
    Until u>n;
    Inkq;
  End;
Begin
  Clrscr;
  Ddl;
  Giai;
End.