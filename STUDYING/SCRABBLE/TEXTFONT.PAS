Unit TextFont;

Interface

  Type
    TCharDef = Array[0..15] Of Byte;

  Procedure LoadChar(Order : Byte; Segment, Ofset : Word);
  Procedure LoadFont(KiTuBatDau : Byte; SoKiTu, Segment, Ofset : Word);
  Procedure VGAFont;

Implementation

  Uses CRT, DOS;

  Procedure LoadChar;
    Var
      Regs : Registers;
    Begin
      With Regs do
        Begin
          AH := $11;
          AL := 0;
          BH := 16;
          BL := 0;
          CX := 1;
          DX := Order;
          ES := Segment;
          BP := Ofset;
          Intr($10, Regs);
       End;
    End;

  Procedure LoadFont;
    Var
      Regs : Registers;
    Begin
      With Regs do
        Begin
          AH := $11;
          AL := 0;
          BH := 16;
          BL := 0;
          CX := SoKiTu;
          DX := KiTuBatDau;
          ES := Segment;
          BP := Ofset;
          Intr($10, Regs);
       End;
    End;

  Procedure VGAFont;
    Var
      Regs : Registers;
    Begin
      Regs.AX := $0003;
      Intr($10,Regs);
    End;

End.