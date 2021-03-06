  Procedure TScrabble.InitCharSet;
    Type
      TScbCharDefine = Record
        ChrLetter : Array['A'..'Z'] Of TCharDef;
        ChrBorder : Array[1..4] Of TCharDef;
        ChrQuestion : TCharDef;
      End;
    Const
      ScbCharDefine : TScbCharDefine = (
        ChrLetter : (
        {A} (  0,  0, 16, 56,108,198,198,254,198,198,198,198,  0,  0,  0,255),
        {B} (  0,  0,252,102,102,102,124,102,102,102,102,252,  0,  0,  0,255),
        {C} (  0,  0, 60,102,194,192,192,192,192,194,102, 60,  0,  0,  0,255),
        {D} (  0,  0,248,108,102,102,102,102,102,102,108,248,  0,  0,  0,255),
        {E} (  0,  0,254,102, 98,104,120,104, 96, 98,102,254,  0,  0,  0,255),
        {F} (  0,  0,254,102, 98,104,120,104, 96, 96, 96,240,  0,  0,  0,255),
        {G} (  0,  0, 60,102,194,192,192,222,198,198,102, 58,  0,  0,  0,255),
        {H} (  0,  0,198,198,198,198,254,198,198,198,198,198,  0,  0,  0,255),
        {I} (  0,  0, 60, 24, 24, 24, 24, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {J} (  0,  0, 30, 12, 12, 12, 12, 12,204,204,204,120,  0,  0,  0,255),
        {K} (  0,  0,230,102,102,108,120,120,108,102,102,230,  0,  0,  0,255),
        {L} (  0,  0,240, 96, 96, 96, 96, 96, 96, 98,102,254,  0,  0,  0,255),
        {M} (  0,  0,198,238,254,254,214,198,198,198,198,198,  0,  0,  0,255),
        {N} (  0,  0,198,230,246,254,222,206,198,198,198,198,  0,  0,  0,255),
        {O} (  0,  0,124,198,198,198,198,198,198,198,198,124,  0,  0,  0,255),
        {P} (  0,  0,252,102,102,102,124, 96, 96, 96, 96,240,  0,  0,  0,255),
        {Q} (  0,  0,124,198,198,198,198,198,198,214,222,124, 12, 14,  0,255),
        {R} (  0,  0,252,102,102,102,124,108,102,102,102,230,  0,  0,  0,255),
        {S} (  0,  0,124,198,198, 96, 56, 12,  6,198,198,124,  0,  0,  0,255),
        {T} (  0,  0,126,126, 90, 24, 24, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {U} (  0,  0,198,198,198,198,198,198,198,198,198,124,  0,  0,  0,255),
        {V} (  0,  0,198,198,198,198,198,198,198,108, 56, 16,  0,  0,  0,255),
        {W} (  0,  0,198,198,198,198,214,214,214,254,238,108,  0,  0,  0,255),
        {X} (  0,  0,198,198,108,124, 56, 56,124,108,198,198,  0,  0,  0,255),
        {Y} (  0,  0,102,102,102,102, 60, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {Z} (  0,  0,254,198,134, 12, 24, 48, 96,194,198,254,  0,  0,  0,255));
        ChrBorder : (
        {1} (  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,255),
        {2} (255,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),
        {3} (  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,255),
        {4} (192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255));
        ChrQuestion :
        {?} (  0,  0,124,198,198, 12, 24, 24, 24,  0, 24, 24,  0,  0,  0,255)
      );

    Var
      i : Byte;
      C : Char;
    Begin
      For C := 'A' To 'Z' Do
        LoadChar(Ord(ScbCharSet.ChrLetter[C]),
                 Seg(ScbCharDefine.ChrLetter[C]),
                 Ofs(ScbCharDefine.ChrLetter[C]));
      For i := 1 To 4 Do
        LoadChar(Ord(ScbCharSet.ChrBorder[i]),
                 Seg(ScbCharDefine.ChrBorder[i]),
                 Ofs(ScbCharDefine.ChrBorder[i]));
      LoadChar(Ord(ScbCharSet.ChrQuestion),
               Seg(ScbCharDefine.ChrQuestion),
               Ofs(ScbCharDefine.ChrQuestion));
    End;

  Procedure TScbTable.Init;
    Begin
      Left := L;
      Top  := T;
      Color := ScbTableDefaultColor;
      FillChar(Cells, SizeOf(Cells), #0);
      FillChar(svCells, SizeOf(svCells), #0);
    End;

  Procedure TScbTable.DrawCell;
    Var
      St : String;
      bg : Byte;
      Letter : Char;
    Begin
      Letter := Cells[Row, Col];
      If Letter <> ScbNoLetter Then
        Begin
          St := ScbCharSet.ChrBorder[4]; { [ }
          If Letter <> ScbBlankLetter Then St := St+Chr(Ord(Letter)+127)
                                      Else St := St+ScbCharSet.ChrBorder[1]; { _ }
          If Col <> ScbTableSize Then St := St+ScbCharSet.ChrBorder[1]  { _                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        