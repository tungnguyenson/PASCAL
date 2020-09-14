{$S-,R-}
Uses crt;
Const
  MaxN=100;
  Input='cty.inp';
  ThoiGianCho=30;
Type Nhan=Record tr:Byte;S:set of Byte;D:Integer;
          End;
Var
  F:Text;
  N,kiluc,td,Solt:Integer;
  Chuaxet:Array[1..MaxN]Of Boolean;
  A:Array[1..MaxN,1..MaxN]Of Byte;
  Nh,Luu:Array[1..MaxN]Of Nhan;
  X,luu1,luu2:Array[1..MaxN]Of Byte;
  Q,lt,sl:Array[1..MaxN]Of Byte;
  Time:Longint;
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
Procedure Tim(S:Byte);
  Var
    i,j,Min:Integer;
    oK:Boolean;
    th:Set Of Byte;
  Begin
    Fillchar(Chuaxet,Sizeof(Chuaxet),True);
    For i:=1 to n do
      Begin
        Nh[i].tr:=0;
        Nh[i].D:=0;
        Nh[i].s:=[];
      End;
    Th:=[];Nh[S].S:=[S];
    For i:=1 to n do
    If A[S,i]=1 Then
      Begin
        Th:=Th+[i];
        Nh[i].tr:=S;
        Nh[i].D:=A[S,i];
        Nh[i].s:=[S]+[i];
      End;
    oK:=true;
    While Ok Do
      Begin
        oK:=False;Min:=0;
        For i:=1 to n do
          If (I In th)And(Nh[i].D>Min) Then
            Begin
              oK:=True;
              Min:=Nh[i].D;
              J:=I;
            End;
        If Ok Then
          Begin
            Th:=Th-[j];
            For i:=1 to n do
              If (A[j,i]=1)And(Nh[i].D<Nh[j].D+1)And(Not (i in Nh[j].S)) Then
              Begin
                Th:=Th+[i];
                Nh[i].Tr:=j;
                Nh[i].D:=Nh[j].D+1;
                Nh[i].S:=Nh[j].S+[i];
              End;
          End;
      End;
  End;
Procedure Thamlam;
  Var i,j,K,u,v:Integer;
  Begin
    Kiluc:=0;u:=0;V:=0;
    For i:=1 to N do
      Begin
        Tim(I);
        For k:=1 to n do
          If Nh[k].D>Kiluc Then
            Begin
              Kiluc:=Nh[k].D;
              Luu:=Nh;
              u:=i;v:=k;
            End;
      End;
    Kiluc:=0;
    While v<>0 Do
      Begin
        Inc(kiluc);Luu1[kiluc]:=v;
        V:=luu[v].Tr;
      End;
    For i:=1 to kiluc div 2 do
      Begin
        u:=Luu1[i];
        luu1[i]:=Luu1[kiluc-i+1];
        Luu1[kiluc-i+1]:=u;
      End;
  End;
Procedure duyet(i:Byte);
  Var k:Byte;
  Begin
    If (kiluc=solt)Or((meml[0:$46C]-Time)/18.2>thoigiancho)Then Exit;
    Inc(td);
    For k:=1 to n do
      If (Chuaxet[k])And(A[i,k]=1)Then
      Begin
        X[td]:=k;Chuaxet[k]:=False;
        If td>kiluc Then
          Begin
            kiluc:=td;
            Luu1:=X;
          End;
        Duyet(k);Chuaxet[k]:=True;
      End;
    Dec(td);
  End;
Procedure Inkq;
  Var i:Byte;
  Begin
    Writeln(Kiluc);
    For i:=1 to kiluc do Write(Luu1[i],' ');Writeln;
  End;
Procedure Tim1(u:Byte);
  Var d,c,v:Integer;
  Begin
    Inc(solt);lt[u]:=solt;Inc(sl[Solt]);
    D:=1;C:=1;Q[1]:=u;
    While D<=C Do
      Begin
        u:=Q[d];Inc(d);
        For v:=1 to n do
          If (lt[v]=0)And((A[u,v]=1)Or(A[v,u]=1))Then
          Begin
            Inc(C);lt[v]:=solt;Inc(Sl[solt]);
            Inc(C);Q[C]:=V;
          End;
      End;
  End;
Procedure Giai1;
  Var i:Integer;
  Begin
    Fillchar(lt,sizeof(lt),0);
    Fillchar(Sl,sizeof(Sl),0);
    Solt:=0;
    For i:=1 to n do
      If lt[i]=0 Then Tim1(i);
    td:=1;
    Fillchar(Chuaxet,Sizeof(Chuaxet),true);
    Time:=Meml[0:$46C];
    For i:=1 to n do
      Begin
        Solt:=N;
        X[1]:=i;
        Chuaxet[i]:=False;
        Duyet(i);
        Chuaxet[i]:=True;
      End;
  End;
Begin
  Clrscr;
  Ddl;
  Thamlam;
  Giai1;
  Inkq;
  Readln;
End.
