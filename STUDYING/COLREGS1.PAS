Program Test_TextMode_Colors_Registers;

Uses CRT, DOS;

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
  x, y : Byte;

BEGIN
  Get_Color_Registers(ColorRegs);

  Assign(F, 'colregs1.sav');
  Rewrite(F);
  For i := 0 To 255 Do
    With ColorRegs[i] Do
      WriteLn(F, Red:4, Blue:4, Green:4);
  Close(F);

  Randomize;
  NewColRegs := ColorRegs;
  For i := 1 To 15 Do
    With NewColRegs[i] Do
      Begin
        Red := 10;
        Blue := 10;
        Green := 10;
      End;{}
  TextAttr := 0;
  ClrScr;
  For y := 1 To 25 Do
    For x := 1 To 80 Do
      Screen[y, x] := ((y*16+x)Mod 16)*256+(((y*16+x)Mod 16)Mod 10+48);
  TextAttr := 7;
  GoToXY(1, 1);
  WriteLn('Press Enter to continue ...');
  ReadLn;
  Set_Color_Registers(NewColRegs);
  WriteLn('Press Enter to continue ...');
  ReadLn;
  Set_Color_Registers(ColorRegs);
  WriteLn('Press Enter to Exit ...');
  ReadLn;
  TextAttr := 7;
  ClrScr;
END.