Uses CRT;

Const
  MaxPoint = 1000;

Type
  IntPoint = Record
    x, y : Integer;
  End;

Var
  P : Array[1..MaxPoint+1] Of IntPoint;
  W, Xet : Array[1..MaxPoint+1] Of Word;
  N, SoDinh : Word;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i : Word;
  Begin
    TenTepDL := 'bl.in2';
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, P[i].x, P[i].y);
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

Procedure Wrap;
  Var
    i, j : Word;
    GocMin, G, G0 : Real;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(W, SizeOf(W), 0);
    i := 1;
    For j := 2 To N Do
      If P[j].y > P[i].y Then i := j;
    SoDinh := 1;
    W[SoDinh] := i;
    G0 := 0;
    Repeat
      GocMin := 360;
      If SoDinh > 1 Then
        If P[W[SoDinh-1]].y >= P[W[SoDinh]].y Then G0 := Theta(P[W[SoDinh-1]], P[W[SoDinh]])
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
        End;
    Until i = W[1];
    Dec(SoDinh);
  End;

Procedure Xuat_Ket_Qua;
  Var
    i : Word;
  Begin
    WriteLn(SoDinh);
    For i := 1 To SoDinh Do Write(W[i], ' ');
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Wrap;
  Xuat_Ket_Qua;
  WriteLn;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.