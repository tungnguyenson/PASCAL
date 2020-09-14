Uses TextFont, Support;

{$I FontSave}

BEGIN
  LoadFont(0, 255, Seg(UserFont), Ofs(UserFont));
  ShowASCIITable;
  ReadLn;
{  LoadVGAFont;{}
END.