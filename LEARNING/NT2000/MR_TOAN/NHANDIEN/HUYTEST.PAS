{$A+,B-,D+,E-,F-,G-,I+,L+,N+,O-,P-,Q-,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses Crt;

Const Max=100;
      MaxLoang=4;
      Output='ND.O';{File ket qua cua hoc sinh}
      Dx:Array[1..MaxLoang] Of -1..1=(-1,0,1,0);
      Dy:Array[1..MaxLoang] Of -1..1=(0,-1,0,1);
      Mark:Array[0..10] Of Byte=(1,1,1,1,1,1,2,2,5,5,10);

Type Arr=Array[0..Max+1,0..Max+1] Of Byte;
     Arr1=Array[1..Max*Max] Of Byte;
     Tap_Hop=Set Of Byte;

Var N,Count,Count1,FileTest:Integer;
    A,Queue:Arr;
    Dong,Cot:Arr1;
    Fig:Arr;
    T:Tap_Hop;
    F:Text;

Procedure Doc;
Var I,J:Integer;
    Input,S:String;
Begin
  Write('+> Input=ND');Readln(FileTest);{Du lieu vao}
  Str(FileTest,S);
  Input:='ND.IN'+S;
  Assign(F,Input);Reset(F);
  Readln(F,N);
  For I:=1 to N do
    For J:=1 to N do Read(F,A[I,J]);
  Close(F);
End;

Procedure Khoi_Tao;
Var I:Integer;
Begin
  Fillchar(Queue,SizeOf(Queue),0);
  For I:=0 to N+1 do
    Begin
      Queue[0,I]:=1;Queue[I,0]:=1;Queue[N+1,I]:=1;Queue[I,N+1]:=1;
    End;
End;

Procedure Loang(X,Y:Integer);
Var Dau,Cuoi,U,V,U1,V1,i:Integer;

  Procedure Ket_Nap(I,J:Integer);
  Begin
    Inc(Cuoi);
    Queue[I,J]:=1;
    Dong[Cuoi]:=I;
    Cot[Cuoi]:=J;
  End;

  Function Hinh(M:Integer;T:Tap_Hop):Byte;
  Begin
    If (M=4)and
       ((A[Dong[1],Cot[1]]=3)and(A[Dong[1],Cot[1]+1]=1)and
        (A[Dong[1]+1,Cot[1]+1]=2)and(A[Dong[1]+1,Cot[1]]=0))then Hinh:=2
    Else
      If (M=1) or ((M=2) and
         ((T =[0,3])or(T =[1,3])or(T =[1,2])or(T =[2,0]) )) then Hinh:=1
    Else
      If (T=[0,1]) or (T=[2,3]) then
        If Odd(M) then Hinh:=3 Else Hinh:=4
      Else Hinh:=5;
  End;

Begin
  Dau:=0;Cuoi:=1;
  Dong[Cuoi]:=X;Cot[Cuoi]:=Y;
  Queue[X,Y]:=1;
  While Dau<Cuoi Do
    Begin
      Inc(Dau);
      U:=Dong[Dau];V:=Cot[Dau];
      For I:=1 to MaxLoang do
        Begin
          U1:=U+Dx[I];
          V1:=V+Dy[I];
          If Queue[U1,V1]=0 then
            Case I Of
              1: If (A[U,V]in[0,2]) and (A[U1,V1] in [1,3])then
                   Ket_Nap(U1,V1);
              2: If (A[U,V]in[1,2]) and (A[U1,V1] in [0,3])then
                   Ket_Nap(U1,V1);
              3: If (A[U,V]in[1,3]) and (A[U1,V1]in [0,2])then
                   Ket_Nap(U1,V1);
              4: If (A[U,V]in[0,3]) and (A[U1,V1] in [1,2])then
                   Ket_Nap(U1,V1);
            End;
        End;
    End;
  Inc(Count);
  T:=[];
  For I:=1 to Cuoi do T:=T+[A[Dong[I],Cot[I]]];
  Fig[x,y]:=Hinh(Cuoi,T);
End;

Procedure Xu_Ly;
Var I,J:Integer;
Begin
  Khoi_Tao;
  Count:=0;
  For I:=1 to N do
    For J:=1 to N do
      If Queue[I,J]=0 then Loang(I,J);
End;

Procedure Test;
Var i,j,x,y,z,t:Integer;
Begin
  Assign(F,Output);Reset(F);
  Count1:=0;
  While Not EOF(f) do
    Begin
      Readln(F,i);
      Readln(F,x,y);
      For j:=1 to i-1 do Readln(F,z,t);
      Readln(F,j);
      Readln(F);
      If Fig[x,y]<>j then
        Writeln('+> Figule number ',x,' ',y,' error .')
      Else Inc(Count1);
    End;
  Close(F);
End;

Begin
  Clrscr;
  Writeln('+> SIR HUY TEST gom 11 test ');
  Writeln('+> Dieu kien test : Loang chuan ');
  Writeln('+> Mark Sum =30 :=1+1+1+1+1+1+2+2+5+5+10 .');
  Doc;
  Xu_Ly;
  Test;
  If Count1<Count then
    Begin
      Writeln('+> Mark : ',Mark[FileTest]*(Count1/Count):0:4,'/',
              Mark[FileTest]);
      Writeln('+> Work Again !.');
      Readln;
      Halt;
    End;
  Writeln('+> Ok ! ');
  Writeln('+> Mark : ',Mark[FileTest],'/',Mark[FileTest]);
  Readln;
End.