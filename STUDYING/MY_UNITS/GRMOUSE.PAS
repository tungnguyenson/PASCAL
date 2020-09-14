Unit GrMouse;

Interface

  Const
    msNoButton = $00;
    msLeftButton = $01;
    msRightButton = $02;

  Function InitMouse : Boolean;
  Procedure ShowMouse;
  Procedure HideMouse;
  Procedure GetMouseStatus(Var PosX, PosY : Integer; Var Button : Byte);
  Procedure SetMouseLimit(Left, Top, Right, Bottom : Integer);

Implementation

  Uses DOS;

  Function InitMouse;
    Var
      Regs : Registers;
    Begin
      Regs.AX := $0000;
      Intr($33, Regs);
      InitMouse := Regs.AX = $FFFF;
    End;

  Procedure ShowMouse; Assembler;
    Asm
      Mov AX, $0001;
      Int 33H
    End;

  Procedure HideMouse; Assembler;
    Asm
      Mov AX, $0002;
      Int 33H
    End;

  Procedure GetMouseStatus;
    Var
      Regs : Registers;
    Begin
      Regs.AX := $0003;
      Intr($33, Regs);
      PosX := Regs.CX;
      PosY := Regs.DX;
      Button := Regs.BX;
    End;

  Procedure SetMouseLimit;
    Var
      Regs : Registers;
    Begin
      Regs.AX := $07;
      Regs.CX := Left;
      Regs.DX := Right;
      Intr($33, Regs);
      Regs.AX := $08;
      Regs.CX := Top;
      Regs.DX := Bottom;
      Intr($33, Regs);
    End;
END.