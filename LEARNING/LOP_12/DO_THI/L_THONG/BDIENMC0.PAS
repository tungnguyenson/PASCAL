{$M 32768, 0, 655360}
{$R-}

Program Mien_Con;

Uses CRT, Graph;

Type
  ViTri = Record
            y, x : ShortInt;
          End;

Const
  NMax = 100;
  MMax = 100;
  LanCan : Array[1..4] Of ViTri = ((y:-1; x:0), (y:0; x:-1),
                                   (y:0; x:1), (y:1; x:0));

Var
  Xet, A : Array[1..NMax, 1..MMax] Of Byte;
  Size, N, M : Byte;
  TepVao : String;
  SoMienCon, S, SMax : Word;
  i, j, xs, ys : Byte;
  GraphDriver, GraphMode : Integer;

Procedure Ve_O(i, j, Color : Byte);
  Var
    y, x : LongInt;
  Begin
    SetColor(8);
    SetFillStyle(1, Color);
    y := (i-1)*Size+10;
    x := (j-1)*Size+10;
    Bar(x+1, y+1, x+Size-1, y+Size-1);
    Rectangle(x, y, x+Size, y+Size);
  End;

Procedure Ve_Do_Thi;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do
      For j := 1 To M Do
        If A[i, j] = 0 Then Ve_O(i, j, 1)
                       Else Ve_O(i, j, 0);
  End;

Procedure Xuat_KQ;
  Var
    SMC, SDT : String[5];
  Begin
    Str(SoMienCon, SMC);
    Str(SMax, SDT);
    SetColor(White);
    OutTextXY(10, 10+Size*N+10, 'So mien con toan 0 la: '+SMC);
    OutTextXY(10, 10+Size*N+20, 'Mien con co dien tich lon nhat la: '+SDT);
  End;

Procedure SinhDL(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    WriteLn('Nhap kich thuoc cua mang:');
    Write('  N = ');  ReadLn(N);
    Write('  M = ');  ReadLn(M);
    Assign(F, TenTep);
    ReWrite(F);
    Randomize;
    WriteLn(F, N, ' ', M);
    For i := 1 To N Do
      Begin
        For j := 1 To M Do Write(F, Random(2), ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure DocDL(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N, M);
    For i := 1 To N Do
      For j := 1 To M Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Tim(y, x : Byte; SoMC : Word; Var S : Word);
  Var
    Queue : Array[1..NMax*MMax]  Of ViTri;
    i, j, k : Word;
    Left, Right : Word;
    VT : ViTri;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    Left := 1;
    Right := 1;
    Queue[1].y := y;
    Queue[1].x := x;
    Xet[y, x] := 1;
    Repeat
{     Ve_O(Queue[Left].y, Queue[Left].x, 14);}
      For i := 1 To 4 Do
        If (Xet[y+LanCan[i].y, x+LanCan[i].x] = 0)And
           (A[y+LanCan[i].y, x+LanCan[i].x] = 0) Then
          If (y+LanCan[i].y in [1..N])And(x+LanCan[i].x in [1..M]) Then
            Begin
              Xet[y+LanCan[i].y, x+LanCan[i].x] := 1;
              Inc(Right);
              Queue[Right].y := y+LanCan[i].y;
              Queue[Right].x := x+LanCan[i].x;
            End;
      Ve_O(Queue[Left].y, Queue[Left].x, SoMC Mod 254+2);
      Inc(Left);
      y := Queue[Left].y;
      x := Queue[Left].x;
    Until Left > Right;
    S := Right;
  End;

Begin
  ClrScr;
  Write('Nhap ten tep du lieu: ');  ReadLn(TepVao);
{  SinhDL(TepVao);{}
  DocDL(TepVao);
  GraphDriver := InstallUserDriver('SVGA256', Nil);
  GraphMode := 3;
  InitGraph(GraphDriver, GraphMode, 'C:\TP\BGI');
  Size := (GetMaxY-50)Div N;
  Delay(1000);
  Ve_Do_Thi;
  SoMienCon := 0;
  SMax := 0;
  FillChar(Xet, SizeOf(Xet), 0);
  For i := 1 To N Do
    For j := 1 To M Do
      If (Xet[i, j] = 0)And(A[i, j] = 0) Then
        Begin
          Inc(SoMienCon);
          Tim(i, j, SoMienCon, S);
          If SMax < S Then
            Begin
              SMax := S;
              ys := i;
              xs := j;
            End;
        End;
  Xuat_KQ;
  i := 0;
  Repeat
    FillChar(Xet, SizeOf(Xet), 0);
    i := (i+1) Mod 127;
    Tim(ys, xs, i+126, S);
    Delay(100);
  Until KeyPressed;
  CloseGraph;
End.