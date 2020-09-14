UNIT Display;

INTERFACE

  Procedure SetScreenMode(Mode : Byte);

  Procedure SetCursorSize(Top, Bottom : Byte);

  Procedure SetCursor(Page, Row, Col : Byte);

  Procedure GetCursor(Page : Byte; Var Row, Col, Top, Bottom : Byte);

  Procedure SetPage(Page : Byte);

  Procedure ScrollUpWindow(Y1, X1, Y2, X2, Number, InsAttr : Byte);

  Procedure ScrollDownWindow(Y1, X1, Y2, X2, Number, InsAttr : Byte);

  Function ReadCharAttr(Page : Byte) : Word;

  Procedure WriteCharAttr(Page : Byte; Character : Char; Attr : Byte;
                          NumberWrite : Word);

  Procedure WriteChar(Page : Byte; Character : Char; Attr : Byte;
                      NumberWrite : Word);

  Procedure WritePixel(Page : Byte; y, x : Integer; Color : Byte);

  Function ReadPixel(Page : Byte; y, x : Integer) : Byte;

  Procedure GetScreenType(Var Mode, NumberCols, ActivePage : Byte);

  Procedure SetPallete;

  Procedure SetFont;

  Procedure WriteString;

IMPLEMENTATION

  Procedure SetScreenMode; Assembler;
    Asm
      Mov AH, 00H
      Mov AL, Mode
      Int 10H
    End;

  Procedure SetCursorSize; Assembler;
    Asm
      Mov AH, 01H
      Mov CH, Top
      Mov CL, Bottom
      Int 10H
    End;

  Procedure SetCursor; Assembler;
    Asm
      Mov AH, 02H
      Mov BH, Page
      Mov DH, Row
      Mov DL, Col
      Int 10H
    End;

  Procedure GetCursor; Assembler;
    Asm
      Mov AH, 03H
      Mov BH, Page
      Int 10H
      {
      Mov Row, AH
      Mov Col, DL
      Mov Top, CH
      Mov Bottom, CL
      }
    End;

  Procedure SetPage; Assembler;
    Asm
      Mov AH, 05H
      Mov AL, Page
      Int 10H
    End;

  Procedure ScrollUpWindow; Assembler;
    Asm
      Mov AH, 06H
      Mov AL, Number
      Mov CH, Y1
      Mov CL, X1
      Mov DH, Y2
      Mov DL, X2
      Mov BH, InsAttr
      Int 10H
    End;

  Procedure ScrollDownWindow; Assembler;
    Asm
      Mov AH, 07H
      Mov AL, Number
      Mov CH, Y1
      Mov CL, X1
      Mov DH, Y2
      Mov DL, X2
      Mov BH, InsAttr
      Int 10H
    End;

  Function ReadCharAttr; Assembler;
    Asm
      Mov AH, 08H
      Mov BH, Page
      Int 10H
      {
      AH : Ki tu ASCII tai vi tri con tro
      AL : Thuoc tinh ki tu (chi voi kieu van ban)
      }
    End;

  Procedure WriteCharAttr; Assembler;
    Asm
      Mov AH, 09H
      Mov AL, Character
      Mov BL, Attr
      Mov BH, Page
      Mov CX, NumberWrite
      Int 10H
    End;

  Procedure WriteChar; Assembler;
    Asm
      Mov AH, 0AH
      Mov AL, Character
      Mov BL, Attr { Chi duoc su dung trong kieu do thi }
      Mov BH, Page
      Mov CX, NumberWrite
      Int 10H
    End;

  Procedure WritePixel; Assembler;
    Asm
      Mov AH, 0CH
      Mov BH, Page
      Mov DX, Y
      Mov CX, X
      Mov AL, Color
      Int 10H
    End;

  Function ReadPixel; Assembler;
    Asm
      Mov AH, 0DH
      Mov BH, Page
      Mov DX, Y
      Mov CX, X
      Int 10H
      { Ma mau duoc tra ve trong AL }
    End;

  Procedure GetScreenType; Assembler;
    Asm
      Mov AH, 0FH
      Int 10H
      {
      AL : Kieu man hinh
      AH : So ki tu cho moi dong
      BH : Trang man hinh hoat dong
      }
    End;

  Procedure SetPallete; Assembler;
    Asm
    End;

  Procedure SetFont; Assembler;
    Asm
    End;

  Procedure WriteString; Assembler;
    Asm
    End;

END.