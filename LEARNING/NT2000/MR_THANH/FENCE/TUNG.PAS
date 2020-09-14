{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Rao_Cay;

Uses CRT;

Const
  TenTepDL = 'CAY5';
  TenTepKQ = 'CAY.OUT';
  MaxTree = 100;

Type
  IntPoint = Record
    x, y : Integer;
  End;

Var
  Tree : Array[1..MaxTree+1] Of IntPoint;
  W, Xet : Array[1..MaxTree+1] Of Word;
  N, SoDinh : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Read(F, Tree[i].x, Tree[i].y);
    Tree[N+1] := Tree[1];
    Close(F);
  End;

Function Theta(p1, p2 : IntPoint) : Real;
  Var
    dx, dy, ax, ay : Integer;
    T : Real;
  Begin
    dx := p2.x-p1.x;
    dy := p2.y-p1.y;
    ax := Abs(dx);
    ay := Abs(dy);
    If (dx = 0)And(dy = 0)Then T := 0
                          Else T := dy/(ax+ay);
    If dx < 0 Then T := 2-T
     Else If dy < 0 Then T := 4+T;
    Theta := T*90;
  End;

Procedure Wrap;
  Var
    i, j : Word;
    GocMin, G, G0 : Real;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(W, SizeOf(W), 0);
    i := 1;
    For j := 2 To N Do
      If Tree[j].y < Tree[i].y Then i := j
       Else If (Tree[j].y = Tree[i].y)And(Tree[j].x > Tree[i].x) Then i := j;
    SoDinh := 1;
    W[SoDinh] := i;
    G0 := 0;
    Repeat
      GocMin := 360;
      If SoDinh > 1 Then
        If Tree[W[SoDinh-1]].y <= Tree[W[SoDinh]].y Then
          G0 := Theta(Tree[W[SoDinh-1]], Tree[W[SoDinh]])
         Else G0 := Theta(Tree[W[SoDinh]], Tree[W[SoDinh-1]]);
      For j := 1 To N Do
        If (Xet[j] = 0)And(j <> W[SoDinh]) Then
          Begin
            G := Theta(Tree[W[SoDinh]], Tree[j])-G0;
            If G < 0 Then G := 360+G;{}
            If G < GocMin Then
              Begin
                GocMin := G;
                i := j;
              End;
          End;
      If GocMin < 360 Then
        Begin
          Inc(SoDinh);
          W[SoDinh] := i;
          Xet[i] := 1;
        End;
    Until i = W[1];
    Dec(SoDinh);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SoDinh);
    For i := 1 To SoDinh Do Write(F, W[i], ' ');
    Close(F);
  End;

BEGIN
  Doc_Du_Lieu;
  Wrap;
  Ghi_Ket_Qua;
  ReadLn;
END.