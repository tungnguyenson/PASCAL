{*------------------------------------*}
{*              TEXTFONT              *}
{*------------------------------------*}
{*  This unit is developed by NSTung  *}
{*       19/08/2000-30/04/2002        *}
{*------------------------------------*}

Unit TextFont;

Interface

  Type
    TCharDef = Array[0..15] Of Byte;

  Procedure LoadChar(CharID, Segment, Ofset : Word);
  Procedure LoadFont(FirstCharID, EndCharID, Segment, Ofset : Word);
  Procedure LoadVGAFont;

Implementation

  Procedure LoadChar; Assembler;
    Asm
      Mov AH, 11H
      Mov AL, 00H
      Mov BH, 10H
      Mov BL, 00H
      Mov CX, 01H
      Mov DX, CharID
      Mov ES, Segment
      Mov BP, Ofset
      Int $10
    End;

  Procedure LoadFont; Assembler;
    Asm
      Mov AH, 11H
      Mov AL, 00H
      Mov BH, 10H
      Mov BL, 00H
      Mov DX, FirstCharID
      Mov CX, EndCharID
      Sub CX, FirstCharID
      Inc CX
      Mov ES, Segment
      Mov BP, Ofset
      Int 10H
    End;

  Procedure LoadVGAFont; Assembler;
    Asm
      Mov AX, 0003H
      Int 10H
    End;

End.