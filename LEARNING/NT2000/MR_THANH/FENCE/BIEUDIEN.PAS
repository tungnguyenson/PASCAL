{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 4096,0,655360}

Uses CRT, Graph;

Const
  MaxPoint = 1000;
  TenTepDL = 'CAY1.';
  HeSoNhan = 60;

Type
  IntPoint = Record
    x, y : Integer;
  End;

Var
  P : Array[1..MaxPoint+1] Of IntPoint;
  Goc : Array[1..MaxPoint] Of Real;
  W, Xet : Array[1..MaxPoint+1] Of Word;
  N, SoDinh, StartPoint : Word;
  P0 : IntPoint;
  GD, GM : Integer;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        Read(F, P[i].x, P[i].y);
        P[i].x := 200+P[i].x*HeSoNhan;
        P[i].y := 200+P[i].y*HeSoNhan;
      End;
    P[N+1] := P[1];
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
    Theta := 360-T*90.0;
  End;

Procedure WriteNum(x, y : Integer; i : Word);
  Var
    S : String;
  Begin
    Str(i, S);
    OutTextXY(x, y, S);
  End;

Procedure Wrap;
  Var
    i, j : Word;
    GocMin, G, G0 : Real;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(W, SizeOf(W), 0);
    i := StartPoint;
    SoDinh := 1;
    W[SoDinh] := i;
    G0 := 0;
    MoveTo(P[StartPoint].x, P[StartPoint].y);
    Repeat
      GocMin := 360;
      If SoDinh > 1 Then
        If P[W[SoDinh-1]].y >= P[W[SoDinh]].y Then
          G0 := Theta(P[W[SoDinh-1]], P[W[SoDinh]])
         Else G0 := Theta(P[W[SoDinh]], P[W[SoDinh-1]]);
      For j := 1 To N Do
        If (Xet[j] = 0)And(j <> W[SoDinh]) Then
          Begin
            G := Theta(P[W[SoDinh]], P[j])-G0;
            If G < 0 Then G := 360+G;
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
          SetColor(11);
          LineTo(P[i].x, P[i].y);
          WriteNum(P[i].x+1, P[i].y+1, i);
        End;
    Until i = W[1];
    Dec(SoDinh);
  End;

Procedure Khep_Kin;
  Var
    i, j, k : Word;
    r : Real;
  Begin
    SetColor(10);
    Circle(P[StartPoint].x, P[StartPoint].y, 8);
    For i:=1 To N Do
      Goc[i] := Theta(P[StartPoint], P[i]);
    Goc[StartPoint] := 0;
    For i := 1 To N Do Xet[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Goc[i] > Goc[j] Then
          Begin
            r := Goc[i];
            Goc[i] := Goc[j];
            Goc[j] := r;
            k := Xet[i];
            Xet[i] := Xet[j];
            Xet[j] := k;
          End;
    Xet[N+1] := Xet[1];
    SetColor(8);
    MoveTo(P[Xet[1]].x, P[Xet[1]].y);
    For i := 2 to N+1 do
      LineTo(P[Xet[i]].x, P[Xet[i]].y);
  End;

Procedure Sinh_DL(N : Word);
  Var
   i : Word;
  Begin
    For i := 1 To N Do
      With P[i] Do
        Begin
          x := Random(GetMaxX-10)+10;
          y := Random(GetMaxY-10)+10;
        End;
  End;

Procedure Khoi_Tao;
  Var
    i : Word;
  Begin
    StartPoint := 1;
    For i := 2 To N Do
      If P[i].y > P[StartPoint].y Then
        StartPoint := i;
    SetFillStyle(1, 7);
    For i := 1 To N Do
      Begin
        SetColor(7);
        FillEllipse(P[i].x, P[i].y, 2, 2);
{        SetColor(14);
        OutTextXY(P[i].x+3, P[i].y+3, Chr(i+64));{}
      End;
  End;

Procedure Demostration;
  Var
    Ch : Char;
  Begin
    Randomize;{}
    N := 1000;
    Repeat
      Sinh_DL(N);
      Khoi_Tao;
      Khep_Kin;
      Wrap;{}
      Ch := ReadKey;
      If Ch=#0 Then ReadKey;{}
      ClearDevice;
    Until Ch = #27;
  End;

Begin
  GD := InstallUserDriver('EGAVGA',Nil);
  GM := VGAHi;
  InitGraph(GD, GM, '\tp\bgi');
  Doc_Du_Lieu;
  Khoi_Tao;
  Wrap;
  ReadKey;{}
{  Demostration;{}
  CloseGraph;
End.