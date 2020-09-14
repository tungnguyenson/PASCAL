Uses CRT, DOS;

Procedure LoadFont(Mode : Byte);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        AH := $11;
        AL := Mode;
        Intr($10, Regs);
      End;
  End;

BEGIN
  LoadFont($12);{}
{  Asm
    Mov AH, $00
    Mov AL, $03
    Int 10H
  End;{}
  ReadLn;
END.