Program Color_Demostration;

Uses CRT, DOS, Graph, spGraph;

Type
  TColorReg = Record
    Red, Blue, Green : Byte;
  End;
  TColorArray = Array[0..255] Of TColorReg;

{ Cap nhap noi dung cua 1 thanh ghi bang mau }
Procedure SetColorReg(Order : Byte; Red, Blue, Green : Byte);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        AH := $10;
        AL := $10;    { Ham con cap nhap 1 thanh ghi mau }
        BX := Order;  { So hieu ghi mau cap cap nhap }
        DH := Red;
        CH := Blue;
        CL := Green;
        Intr($10, Regs);
      End;
  End;

{ Cap nhap noi dung cua 1 nhom thanh ghi bang mau }
Procedure SetGroupColorRegs(FirstReg : Byte; Num, Segment, Ofset : Word);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        AH := $10;
        AL := $12;  { Ham con cap nhap khoi thanh ghi mau}
        BX := FirstReg;
        CX := Num;
        ES := Segment;
        DX := Ofset;
        Intr($10, Regs);
      End;
  End;

{ Cap nhap noi dung cua 256 thanh ghi bang mau }
Procedure SetAllColorRegs(ColRegs : TColorArray);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        AH := $10;
        AL := $12;  { Ham con cap nhap khoi thanh ghi mau}
        BX := $00;  { So hieu thanh ghi mau dau tien }
        CX := $100;  { So luong thanh ghi mau can cap nhap }
        ES := Seg(ColRegs);  { Cap ES:DX tro den vung dem gom 256 thanh ghi }
        DX := Ofs(ColRegs);
        Intr($10, Regs);
      End;
  End;

{ Cap nhap noi dung cua 256 thanh ghi bang mau }
Procedure Get_Color_Registers(Var ColRegs : TColorArray);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        AH := $10;
        AL := $17;  { Ham con cap nhap khoi thanh ghi mau}
        BX := $00;  { So hieu thanh ghi mau dau tien }
        CX := $100;  { So luong thanh ghi can cap nhap }
        ES := Seg(ColRegs);  { Cap ES:DX tro den vung dem gom 256 thanh ghi }
        DX := Ofs(ColRegs);
        Intr($10, Regs);
      End;
  End;

Var
  ColorRegs, NewColRegs : TColorArray;
  i : Integer;
  kp : Char;

Procedure xBar(x, y : Integer; Color : Byte; Direct : ShortInt);
  Var
    i : Byte;
  Begin
    For i := 0 To 31 Do
      Begin
        If Direct = 1 Then SetColor(Color+i)
                      Else SetColor(Color+31-i);
        Rectangle(x+i*2, y+i*2, x+32-i*2, y+32-i*2);
        Rectangle(x+i*2+1, y+i*2+1, x+32-i*2-1, y+32-i*2-1);
      End;
  End;

Procedure MyCircle(PosX, PosY, Radius : Integer; Color : Byte);
  Var
    x, y, LastX, LastY : Integer;
    Angle, AngleInc : Real;
  Begin
    Angle := 0;
    AngleInc := 0.30;
    LastX := 0;
    LastY := 0;
    Repeat
      x := Round(Radius*Cos(Angle*Pi/180));
      y := Round(Radius*Sin(Angle*Pi/180));
      If (LastX <> x)Or(LastY <> y) Then
        Begin
          LastX := x;
          LastY := y;
          PutPixel(PosX+x, PosY-y, Color);
        End;
      Angle := Angle+AngleInc;
    Until Angle >= 360;
  End;

Procedure xCircle(x, y : Integer; Color : Byte; Direct : ShortInt);
  Var
    i, C : Byte;
  Begin
    If Direct = 1 Then C := Color+31
                  Else C := Color;
    PutPixel(x, y, C);
    For i := 0 To 31 Do
      Begin
        If Direct = 1 Then C := Color+31-i
                      Else C := Color+i;
        MyCircle(x, y, i*2, C);
        MyCircle(x, y, i*2+1, C);{}
      End;
  End;

Procedure xCircle2(x, y : Integer; Color : Byte; Direct : ShortInt);
  Var
    i, C : Byte;
  Begin
    If Direct = 1 Then C := Color+31
                  Else C := Color;
    PutPixel(x, y, C);
    For i := 0 To 31 Do
      Begin
        If Direct = 1 Then C := Color+31-i
                      Else C := Color+i;
        MyCircle(x, y, i*3, C);
        MyCircle(x, y, i*3+1, C);{}
        MyCircle(x, y, i*3+2, C);{}
      End;
  End;

Procedure InitColorRegs;
  Begin
    NewColRegs := ColorRegs;
    For i := 0 To 31 Do
      With NewColRegs[32+i] Do
        Begin
          Red := 0;
          Blue := 0;
          Green := i*2+1;
        End;
    For i := 0 To 31 Do
      With NewColRegs[64+i] Do
        Begin
          Red := 0;
          Blue := i*2+1;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[96+i] Do
        Begin
          Red := 0;
          Blue := i*2+1;
          Green := i*2+1;
        End;
    For i := 0 To 31 Do
      With NewColRegs[128+i] Do
        Begin
          Red := i*2+1;
          Blue := 0;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[160+i] Do
        Begin
          Red := i*2+1;
          Blue := 0;
          Green := i*2+1;
        End;
    For i := 0 To 31 Do
      With NewColRegs[192+i] Do
        Begin
          Red := i*2+1;
          Blue := i*2+1;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[224+i] Do
        Begin
          Red := i*2+1;
          Blue := i*2+1;
          Green := i*2+1;
        End;
    SetAllColorRegs(NewColRegs);
  End;

Procedure InitColorRegs2;
  Begin
    NewColRegs := ColorRegs;
    For i := 0 To 31 Do
      With NewColRegs[32+i] Do
        Begin
          Red := 0;
          Blue := 0;
          Green := 63;
        End;
    For i := 0 To 31 Do
      With NewColRegs[64+i] Do
        Begin
          Red := 0;
          Blue := 0;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[96+i] Do
        Begin
          Red := 0;
          Blue :=  0;
          Green :=  0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[128+i] Do
        Begin
          Red := 0;
          Blue := 0;
          Green :=  0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[160+i] Do
        Begin
          Red := 0;
          Blue := 0;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[192+i] Do
        Begin
          Red :=   0;
          Blue :=  0;
          Green := 0;
        End;
    For i := 0 To 31 Do
      With NewColRegs[224+i] Do
        Begin
          Red :=    0;
          Blue :=   0;
          Green :=  0;
        End;
    SetAllColorRegs(NewColRegs);
  End;

Procedure PaletteDemo;
  Var
    y, x : Integer;
  Begin
    ClearDevice;
    SetColor(Random(256));
    Rectangle(100, 100, 100+16*35, 100+16*25);
    For y := 0 To 15 Do
      For x := 0 To 15 Do
        Begin
          SetFillStyle(1, y*16+x);
          Bar(100+x*35+1, 100+y*25+1, 100+(x+1)*35-1, 100+(y+1)*25-1);
        End;{}
  End;

Procedure BarDemo;
  Begin
    ClearDevice;
    For i := 0 To 6 Do
      xBar(100+i*100, 150, 32+i*32, -1);
    For i := 0 To 6 Do
      xBar(100+i*100, 250, 32+i*32, 1);
  End;

Procedure CircleDemo;
  Begin
    ClearDevice;
    For i := 0 To 2 Do
      xCircle(280+i*130, 70, 32+i*32, 1);{}
    For i := 3 To 6 Do
      xCircle(210+(i-3)*130, 200, 32+i*32, 1);{}
    For i := 0 To 3 Do
      xCircle(210+i*130, 330, 32+i*32, -1);{}
    For i := 4 To 6 Do
      xCircle(280+(i-4)*130, 460, 32+i*32, -1);{}
  End;

Procedure CircleDemo2;
  Begin
    ClearDevice;
    xCircle2(310+0*200, 120, 32+0*32, 1);{}
    xCircle2(310+1*200, 120, 32+1*32, 1);{}
    xCircle2(210+(4-2)*200, 300, 32+2*32, 1);{}
    xCircle2(310+(6-5)*200, 480, 32+3*32, 1);{}
    xCircle2(310+(5-5)*200, 480, 32+4*32, 1);{}
    xCircle2(210+(2-2)*200, 300, 32+5*32, 1);{}
    xCircle2(210+(3-2)*200, 300, 32+6*32, 1);{}
  End;

Procedure SlideDemo(Dl : Integer);
  Var
    Radius, Num, First, i, j, k : Integer;
    ColRegs, ColRegsSave : Array[0..255] Of TColorReg;
  Begin
    First := 1;
    Num := 32;
    k := 7;
    For i := First*Num To (First+k)*Num-1 Do
      ColRegs[i-First*Num] := NewColRegs[i];
    ColRegsSave := ColRegs;
    Repeat
      Delay(50);
      For Radius := 0 To Num-1 Do
        Begin
          For j := 1 To k Do
            For i := Num-1 DownTo 1 Do
              ColRegs[(j-1)*Num+i] := ColRegs[(j-1)*Num+i-1];
          SetGroupColorRegs(First*Num, Num*k, Seg(ColRegs), Ofs(ColRegs));
          Delay(Dl);
        End;
      For Radius := Num-1 DownTo 0 Do
        Begin
          For j := 1 To k Do
            For i := Num-1 DownTo Radius Do
              ColRegs[(j-1)*Num+i] := ColRegsSave[(j-1)*Num+i-Radius];
          SetGroupColorRegs(First*Num, Num*k, Seg(ColRegs), Ofs(ColRegs));
          Delay(Dl);
        End;
    Until KeyPressed;
  End;

Procedure SlideDemo2;
  Var
    Radius, Num, First, i, j, k : Integer;
    ColRegs, ColRegsSave : Array[0..255] Of TColorReg;
  Begin
    First := 1;
    Num := 32;
    k := 7;
    For i := First*Num To (First+k)*Num-1 Do
      ColRegs[i-First*Num] := NewColRegs[i];
    ColRegsSave := ColRegs;
    Repeat
      Delay(10);
      For i := 0 To Num-1 Do
        ColRegsSave[i] := ColRegs[i];
      For i := 0 To k-2 Do
        For j := 0 To 31 Do
          ColRegs[Num*i+j] := ColRegs[Num*(i+1)+j];
      For j := 0 To 31 Do
        ColRegs[Num*(k-1)+j] := ColRegsSave[j];
      SetGroupColorRegs(First*Num, Num*k, Seg(ColRegs), Ofs(ColRegs));
    Until KeyPressed;
  End;

BEGIN
  InitGraphMode('SVGA256', 3);
  Get_Color_Registers(ColorRegs);

  InitColorRegs;{}
  Randomize;
{	PaletteDemo;{}
{  If kp <> #27 Then BarDemo;{}
{  If kp <> #27 Then CircleDemo;{}
	If kp <> #27 Then CircleDemo2;{}
  SlideDemo(5);{}
{  SlideDemo2;{}
  ReadLn;
  SetAllColorRegs(ColorRegs);{}
  CloseGraph;
END.