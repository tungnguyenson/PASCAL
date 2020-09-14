{$s-,r-}
Uses crt;
Const
  Input='pt.inp';
  Output='pt.out';
Var
  F1,F2:text;
  N:Integer;
  a,b,c,x1,x2:Real;
  Vn,N2,vsn:Boolean;
Procedure Pt(a,b,c:Real);
  Var
    i,j:Integer;
    Del:Real;
  Begin
    vsn:=False;
    vn:=False;N2:=False;
    Del:=b*b-4*a*c;
    If a=0 Then
      Begin
        If (B=0)And(C=0) Then vsn:=True Else
        If (b=0)And(c<>0) Then
          Begin vn:=True;Exit;
          End Else
        If (b<>0) Then X1:=-c/b;
      End Else
    If Del<0 Then vn:=True Else
    If Del=0 then X1:=-b/2*a Else
    If Del>0 Then
      Begin
        N2:=True;
        X1:=(-b-Sqrt(Del))/(2*a);
        X2:=(-b+Sqrt(Del))/(2*a);
      End;
  End;
Procedure Giai;
  Var i:Integer;
  Begin
    Assign(F1,Input);
    Reset(F1);
    Assign(F2,Output);
    ReWrite(F2);
    Readln(F1,N);
    For i:=1 to n do
      Begin
        Readln(f1,a,b,c);C:=-C;
        Pt(a,b,c);
        If Vsn Then Writeln(F2,'') Else
        If Vn Then Writeln(F2,'VO NGHIEM') Else
          Begin
            If N2=false Then Writeln(F2,X1:0:2) Else
              If X1<X2 Then Writeln(F2,X1:0:2,' ',X2:0:2)
                       Else Writeln(F2,X2:0:2,' ',X1:0:2);
          End;
      End;
    Close(f1);
    Close(f2);
  End;
Begin
  Clrscr;
  Giai;
End.
