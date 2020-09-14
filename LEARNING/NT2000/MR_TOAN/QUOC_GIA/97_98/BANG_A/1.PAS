{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
   uses crt;
   Const max =201;
         maxsize =1000;
         TimeOver =182*2;
         Input ='bl1.inp';
         Output ='';

   type mang =array[0..max] of Integer;
        Ta   =Array[0..max] of ^mang;
        Tb   =Array[0..max] of Integer;

   Var  a    : Ta;
        Th, Tc : Tb;
        Cx  : Array[1..maxsize] of Byte;
        M,N,Sd,Csh, Csc , maxmau, Liumaxmau , Time : Longint;

Procedure Read_Input;
  var f : text;
      i,j,x,y : Longint;
  begin
       assign(f, Input); Reset(f);
       Readln(F, M,N, sd);
       For i:=0 to N Do New(A[i]);

       For i:=0 to N Do
           For j:=0 to m Do A[i]^[j]:=0;

       for i:=1 to Sd do
       begin
            readln(f, x,y);
            a[y]^[x]:=1;
       end;
       close(f);
  end;

Procedure Hienm;
  Var i,j : Longint;
  Begin
       For i:=n downto 0 Do
       Begin
            For j:=0 to M Do Write(A[i]^[j]:3);
            Writeln;
       End;
       Writeln;
  End;

procedure Greedy0;
  Var i,j, St  : Longint;
  Begin
       If M>N Then maxmau:=M+1
       Else maxmau:=N+1;

       St:=0;
       For i:=0 to N Do
           Begin
                Inc(St);
                For j:=0 to M Do
                Begin
                     If A[i]^[j]>0 Then
                        If St+j>maxmau Then A[i]^[j]:=St+j-maxmau+1
                        Else A[i]^[j]:=St+j+1;
                End;
           End;
       maxmau:=maxmau+1;
  End;

Procedure Taomangthc;
  Var i,j : Longint;
  begin
       for i:=1 to m do th[i]:=0;
       for i:=1 to n do tc[i]:=0;

       For i:=0 to N Do
           For j:=0 to M Do
           Begin
                Th[i]:=th[i]+A[i]^[j];
                Tc[j]:=tc[j]+A[i]^[j];
           End;
  end;

procedure timhangmax;
  var i : Longint;
  begin
       csh:=0;
       For i:=1 to n Do
           if th[i]>th[csh] then csh:=i;
  end;

procedure timcotmax;
  var i : Longint;
  begin
       csc:=0;
       For i:=1 to m Do
           if tc[i]>tc[csc] then csc:=i;
  end;

procedure lesson1;
  Var i,min : Longint;
  Begin
       min:=0;
       For i:=0 to m do
           if (a[csh]^[i]=1) And (tc[i]>min) Then
           begin
                Csc:=i; min:=tc[i];
           end;
  End;

Procedure Lesson2;
  Var i,min : Longint;
  begin
       Min:=0;
       For i:=0 to n do
           if (a[i]^[csc]=1) and (th[i]>Min) then
           Begin
                Min:=Th[i]; Csh:=i;
           End;
  end;

Procedure Tomaudiem;
  Var i : Longint;
  begin
       Fillchar(Cx, Sizeof(cx),0);
       For i:=0 to N Do
           If A[i]^[csc]>1 Then Cx[ A[i]^[Csc] ]:=1;
       For i:=0 to M Do
           IF A[Csh]^[ i]>1 then Cx[ A[Csh]^[i] ]:=1;
       i:=1;
       Repeat
             i:=i+1;
       Until Cx[i]=0;
       If i>maxmau Then maxmau:=i;
       A[Csh]^[Csc]:=i;
       Th[Csh]:=Th[Csh]-1;
       tc[Csc]:=Tc[Csc]-1;
  End;


procedure Greedy1;
  Var i,j : Longint;
  Begin
       taomangthc;
       For i:=1 to Sd Do
       Begin
             timhangmax;
             Timcotmax;
             If (A[Csh]^[ Csc]<>1) Then
                Begin
                     If th[csh]>tc[csc] then lesson1
                     Else lesson2;
                End;
             ToMaudiem;
             If Meml[0:$46c]-time>TimeOver Then Exit;
       End;
  End;

Procedure Hienkq;
  Var f, fr : text;
      i,x,y : Longint;
  Begin
       If maxmau<Liumaxmau Then
       Begin
            Liumaxmau:=maxmau;
            Assign(Fr, Output); ReWRite(Fr);
            WRiteln(fr, maxmau-1);
            Assign(F, Input); Reset(F);
            Readln(f, M,N, Sd);
            For i:=1 to Sd Do
            Begin
                 Readln(F, x,y);
                 Writeln(fr, a[ y]^[ x ]-1);
            End;
            Close(F);
            Close(Fr);
       End;
  End;

procedure GiaiPhong;
  Var i : byte;
  Begin
       For i:=0 to N Do Dispose(A[i]);
  End;

begin
     Clrscr;
     Time:=Meml[0:$46c];
     liumaxmau:=maxint;

     Read_Input;
     Greedy0;
     Hienkq;
     ClrScr;
     GiaiPhong;

     Maxmau:=1;
     Read_Input;
     Greedy1;
     If meml[0:$46c]-Time<TimeOver Then Hienkq;
     GiaiPhong;
end.