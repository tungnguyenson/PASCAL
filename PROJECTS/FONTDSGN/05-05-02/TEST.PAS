Uses TextFont;

{$I FontSave}

Var
  i : Byte;
BEGIN
  Asm
    Mov AX, 0003H
    Int 10H
  End;

  For i := 16 To 255 Do Write(i:3, Chr(i), ' ');

  LoadFont(0, 255, Seg(UserFont), Ofs(UserFont));
  ReadLn;
  LoadVGAFont;{}
END.