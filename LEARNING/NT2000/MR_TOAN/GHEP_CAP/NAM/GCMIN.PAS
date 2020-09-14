{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
{$r+}
Uses crt;
Const
  MaxN=100;
  Input='gc.in3';
  Output='';
Var
  F:Text;
  N, tds:Integer;
  T:Array[1..MaxN]Of Boolean;
  M,S:Array[1..MaxN]Of Integer;
  X,Y:Array[1..MaxN]Of Boolean;
  Fx,Fy:Array[1..MaxN]Of Integer;
  A:Array[1..MaxN,1..MaxN]Of Integer;
  Tr:Array[1..2*MaxN]Of Integer;
  Q:Array[1..2*MaxN]Of Byte;
  Chuaxet:Array[1..2*MaxN]Of Boolean;
Procedure Ddl;
  Var i,j:Integer;
  Begin
    Assign(F,Input);
    Reset(F);
    Readln(F,N);
    For i:=1 to n do
      For j:=1 to n do Read(F,A[i,j]);
    Close(F);
  End;
Procedure KhoiTao;
  Var i,j:Integer;
  Begin
    Fillchar(M,Sizeof(M),0);
    FillChar(X,Sizeof(X),True);
    FillChar(Y,Sizeof(Y),True);
    FillChar(Fx,Sizeof(Fx),0);
    For i:=1 to n do Fy[i]:=Maxint;
    For i:=1 to n do
      For j:=1 to n do
        If Fy[i]>=A[i,j] then Fy[i]:=A[i,j];
    For i:=1 to n do
      For j:=1 to n do
        If (X[i])And(Y[j])And(Fx[i]+Fy[j]=A[i,j]) Then
          Begin
            M[i]:=j;
            X[i]:=False;
            Y[j]:=False;
          End;
  End;
Function Tim(u:Byte):Byte;
  Var d,c,v,i,j,k:Integer;
  Begin
    Tim:=0;tds:=1;S[tds]:=u;
    Fillchar(Tr,Sizeof(tr),0);
    Fillchar(T,Sizeof(T),True);
    Fillchar(Chuaxet,sizeof(Chuaxet),True);
    D:=1;C:=1;Q[1]:=u;Chuaxet[u]:=False;
    While d<=c do
      Begin
        u:=Q[d];Inc(d);
        i:=1;j:=2*n;
        If u<=n then i:=n+1 Else j:=n;
        For v:=i to j do
          If Chuaxet[v] Then
          Begin
            k:=0;
            If (u<=n)And(Fx[u]+Fy[v-n]=A[u,v-n])And(M[u]<>v)Then k:=1 Else
            If (u>n)And(Fx[v]+Fy[u-n]=A[v,u-n])And(M[v]=u-n)Then k:=1;
            If k=1 then
              Begin
                Inc(C);
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
Procedure SuaNhan;
  Var i,j,d:Integer;
  Begin
    D:=Maxint;
    For i:=1 to tds do
    For j:=1 to n do
      If (T[j])And(D>A[s[i],j]-Fx[s[i]]-Fy[j]) Then
                                     D:=A[s[i],j]-Fx[s[i]]-Fy[j];
    For i:=1 to tds do Fx[S[i]]:=Fx[S[i]]+D;
    For j:=1 to n do
      If T[j]=False Then Fy[j]:=Fy[j]-D;
  End;
Procedure TangCapGhep(u:Byte);
  Var v,td,i,j:Byte;
      Luu:Array[1..MaxN,1..2]Of Byte;
  Begin
    td:=0;Luu[Td+1,2]:=u;
    While u<>0 do
      Begin
        u:=Tr[u];
        Inc(td);Luu[td,1]:=u;
        u:=Tr[u];Luu[td+1,2]:=u;
      End;
    For i:=td downto 1 do
      Begin
        u:=Luu[td,1];v:=Luu[td,2]-n;
        If Not(M[u]=v) then
          Begin
            j:=1;
            While (j<=N)And(M[j]<>v) do Inc(j);
            If j<=n then
              Begin M[j]:=0;X[j]:=True;
              End;
            If M[u]<>0 then X[M[u]]:=True;
            X[u]:=False;Y[v]:=False;
            M[u]:=v;
          End;
      End;
  End;
Procedure Inkq;
  Var i,j,T:Integer;
  Begin
    T:=0;
    For i:=1 to N do Inc(T,A[i,m[i]]);
    Writeln(T);
    Assign(F,Output);
    Rewrite(F);
    For i:=1 to N do Write(F,M[i],' ');
    Close(F);
  End;
Procedure Giai;
  Var u,z:Integer;
  Begin
    KhoiTao;
    Repeat
      u:=1;
      While (u<=N)And(X[u]=false) Do Inc(u);
      If u<=n then
        Begin
          z:=Tim(u);
          If z=0 Then SuaNhan
                 Else TangCapGhep(z);
        End;
    Until u>n;
    Inkq;
  End;
Begin
  Clrscr;
  Ddl;
  Giai;
  Writeln('Go phim ENTER de ket thuc...');
  Readln;
End.