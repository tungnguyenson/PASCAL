{$N+}
{$M 16384,0,655360}
Uses CRT, Graph;

Const
  TenTepDL = 'HCN.IN2';
  HeSoNhan : Real = 1;

Type
  DoanThang = Record
    x1, y1, x2, y2 : Integer;
    A, B, C : Real;
  End;

Var
  DT : Array[1..100] Of DoanThang;
  CanhHCN : Array[1..4] Of DoanThang;
  W, H, K : Word;
  GD, GM, MaxX, MaxY : Integer;

Procedure LapPTDT(Var DT : DoanThang);
  Begin
    With DT Do
      Begin
        A := y2-y1;
        B := x1-x2;
        C := LongInt(x2)*LongInt(y1)-LongInt(x1)*LongInt(y2);
      End;
  End;

Function Cat(D1, D2 : DoanThang; Width, Height : Integer;
             Var X, Y : Single) : Boolean;
  Var
    D, DX, DY : Single;
  Begin
    D := D1.A*D2.B-D1.B*D2.A;
    DX := D1.B*D2.C-D1.C*D2.B;
    DY := D1.C*D2.A-D1.A*D2.C;
    Cat := True;
    If D <> 0 Then
      Begin
        X := DX/D;
        Y := DY/D;
        If (X <= 0)Or(Y <= 0)Or(X >= Width)Or(Y >= Height) Then
          Cat := False;
      End
     Else Cat := False;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Word;
    DT0 : DoanThang;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, W, H);
    ReadLn(F, K);
    For i := 1 To K Do
      With DT[i] Do
        Begin
          ReadLn(F, x1, y1, x2, y2);
          LapPTDT(DT[i]);
        End;
    Close(F);
  End;

Procedure WriteNumber(x, y : Integer; N : Word);
  Var
    S : String;
  Begin
    Str(N, S);
    OutTextXY(x, y, S);
  End;

Procedure Line_B(x1, y1, x2, y2, Color : Integer);
  Var
    d, dx, dy, ai, bi, xi, yi, x, y : Integer;

  Procedure SwapInt(Var i1, i2 : Integer);
    Var
      Tmp : Integer;
    Begin
      Tmp := i1;
      i1 := i2;
      i2 := Tmp;
    End;

  Begin
    If Abs(x2-x1) < Abs(y2-y1) Then
      Begin
        If y1 > y2 Then
          Begin
            SwapInt(x1, x2);
            SwapInt(y1, y2);
          End;
        If x2 > x1 Then xi :=  1
                   Else xi := -1;
        dy := y2-y1;
        dx := Abs(x2-x1);
        d  := 2*dx-dy;
        ai := 2*(dx-dy);
        bi := 2*dx;
        x  := x1;
        y  := y1;
        PutPixel(x, y, Color);
        y := 0;
        While (y <= GetMaxY)And(x >= 0)And(x <= GetMaxX) Do
          Begin
            If d >= 0 Then
              Begin
                Inc(x, xi);
                Inc(d, ai);
              End
             Else Inc(d, bi);
            PutPixel(x, y, Color);
            Inc(y);
          End;
      End
     Else
      Begin
        If x1 > x2 Then
          Begin
            SwapInt(x1, x2);
            SwapInt(y1, y2);
          End;
        If y2 > y1 Then yi :=  1
                   Else yi := -1;
        dx := x2-x1;
        dy := Abs(y2-y1);
        d  := 2*dy-dx;
        ai := 2*(dy-dx);
        bi := 2*dy;
        x  := x1;
        y  := y1;
        PutPixel(x, y, Color);
        x := 0;
        While (x <= GetMaxX)And(y >= 0)And(y <= GetMaxY) Do
          Begin
            If d >= 0 Then
              Begin
                Inc(y, yi);
                Inc(d, ai);
              End
            Else Inc(d, bi);
            PutPixel(x, y, Color);
            Inc(x);
          End;
      End;
  End;

Procedure BD;
  Var
    i, j : Word;
    S : String;
  Begin
    SetColor(15);
    Rectangle(10+0, MaxY, 10+Round(W*HeSoNhan), MaxY-Round(H*HeSoNhan));
    WriteNumber(0, MaxY+3, 0);
{    For i := 1 To Round(W/HeSoNhan) Do
      WriteNumber(10+Round(i*HeSoNhan), MaxY+3, i);
    For i := 1 To Round(H/HeSoNhan) Do
      WriteNumber(0, MaxY-Round(i*HeSoNhan), i);
    SetColor(8);
    SetLineStyle(1, 0, 1);
    For i := 1 To Round(H/HeSoNhan)-1 Do
      Line(10+0, MaxY-Round(i*HeSoNhan), 10+W, MaxY-Round(i*HeSoNhan));
    For i := 1 To Round(W/HeSoNhan)-1 Do
      Line(10+Round(i*HeSoNhan), MaxY, 10+Round(i*HeSoNhan), MaxY-H);{}
    SetLineStyle(0, 0, 1);
    SetColor(15);
    For i := 1 To K Do
      With DT[i] Do
        Begin
          SetColor((i-1) Mod 15+1);
          Line(10+Round(x1*HeSoNhan), MaxY-Round(y1*HeSoNhan),
                 10+Round(x2*HeSoNhan), MaxY-Round(y2*HeSoNhan));{}
{          Line_B(10+Round(x1*HeSoNhan), MaxY-Round(y1*HeSoNhan),
                 10+Round(x2*HeSoNhan), MaxY-Round(y2*HeSoNhan), (i-1) Mod 15+1);{}
        End;
  End;

Procedure ToMau;
  Var
    i, j, c, SoMien : Word;
  Begin
    SoMien := 0;
    For i := MaxY-H+1 To MaxY-1 Do
      For j := 11 To 10+W-1 Do
        If GetPixel(j, i) = 0 Then
          Begin
            Inc(SoMien);
            SetFillStyle(1, SoMien Mod 14+2);
            FloodFill(j, i, 15);
          End;
  End;

BEGIN
  Doc_Du_Lieu;
  GD := Detect;
  InitGraph(GD, GM, '\TP\BGI');
  MaxY := GetMaxY-10;
  BD;
{  ToMau;{}
  ReadLn;
  CloseGraph;
END.