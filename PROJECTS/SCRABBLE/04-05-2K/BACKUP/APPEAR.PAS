Unit Appear;

Interface

  Procedure WriteStr(x, y : Byte; St : String; FG, BG : Byte);
  Procedure SetBrightMode;

Implementation

  Uses CRT;

  Procedure WriteStr;
    Begin
      GoToXY(x, y);
      TextAttr := (Bg Mod 16)*16+(Fg Mod 16);
      Write(St);
    End;

  Procedure SetBrightMode; Assembler;
    Asm
      Mov AX, 1003h
      Mov BL, 00h
      Int 10h
    End;

End.