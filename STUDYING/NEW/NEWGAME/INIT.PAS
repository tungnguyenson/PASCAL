Unit Init;

Interface

  Procedure InitFont;

Implementation

  Uses Font;

  Procedure InitFont;
    Begin
      LoadFont(0, 256, Seg(DefFont), Ofs(DefFont));
    End;

END.