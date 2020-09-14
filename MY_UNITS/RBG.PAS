UNIT RBG;

INTERFACE

  Type
    TColorReg = Record
      Red, Blue, Green : Byte;
    End;
    TColor256 = Array[0..255] Of TColorReg;

  Procedure SetColorReg(Order : Byte; Red, Blue, Green : Byte);
  { Cap nhap noi dung cua 1 thanh ghi bang mau }

  Procedure SetGroupColorRegs(FirstReg : Byte; Num, Segment, Ofset : Word);
  { Cap nhap noi dung cua 1 nhom thanh ghi bang mau }

  Procedure SetAllColorRegs(ColRegs : TColor256);
  { Cap nhap noi dung cua 256 thanh ghi bang mau }

  Procedure GetAllColorRegs(Var ColRegs : TColor256);
  { Lay noi dung cua 256 thanh ghi bang mau }

IMPLEMENTATION

  Uses DOS;

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
  Procedure SetAllColorRegs(ColRegs : TColor256);
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

  { Lay noi dung cua 256 thanh ghi bang mau }
  Procedure GetAllColorRegs(Var ColRegs : TColor256);
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

END.