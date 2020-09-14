Program Test_GraphMode_Colors_Registers;

Uses CRT, DOS, Graph, SpGraph;

Type
  TColorReg = Record
    Red, Blue, Green : Byte;
  End;
  TColorArray = Array[0..255] Of TColorReg;

{ Cap nhap noi dung cua 256 thanh ghi bang mau }
Procedure Set_Color_Registers(ColRegs : TColorArray);
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
  Screen : Array[1..25, 1..80] Of Word Absolute $B800:$0000;
  F : Text;
  i : Byte;
  x, y : Integer;

BEGIN
  InitGraphMode('SVGA256', 2);
  Get_Color_Registers(ColorRegs);

  Assign(F, 'colregs2.sav');
  Rewrite(F);
  For i := 0 To 255 Do
    With ColorRegs[i] Do
      WriteLn(F, Red:4, Blue:4, Green:4);
  Close(F);

  Randomize;
  NewColRegs := ColorRegs;
  For i := 0 To 63 Do
    With NewColRegs[64+i] Do
      Begin
        Red := i;
        Blue := 0;
        Green := 0;
      End;
  For i := 0 To 63 Do
    With NewColRegs[128+i] Do
      Begin
        Red := 0;
        Blue := i;
        Green := 0;
      End;
  For i := 0 To 63 Do
    With NewColRegs[192+i] Do
      Begin
        Red := 0;
        Blue := 0;
        Green := i;
      End;
  For y := 0 To 15 Do
    For x := 0 To 15 Do
      Begin
        SetFillStyle(1, y*16+x);
        SetColor(y*16+x);
        Bar(x*35+1, y*25+1, (x+1)*35-1, (y+1)*25-1);
      End;
  SetColor(15);
  OutTextXY(0, GetMaxY-20, 'Press Enter to continue ...');
  ReadLn;
  Set_Color_Registers(NewColRegs);
  ReadLn;
  Set_Color_Registers(ColorRegs);
  ReadLn;
  CloseGraph;
END.