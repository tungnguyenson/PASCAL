UNIT Support;  { Support for unit CRT }

INTERFACE

  VAR
    Screen : Array[0..24, 0..79] Of Word Absolute $B800:$0000;
    CharAttr : Byte;  { Thuoc tinh ki tu }
    IsFunctionKey : Boolean;

  Procedure SetCharAttr(FG, BG : Byte);
            { Dat thuoc tinh ki tu }

  Procedure OutChar(x, y : Byte; Ch : Char);
            { Gui mot ki tu ra man hinh }

  Procedure OutCharAttr(x, y : Byte; Ch : Char; FG, BG : Byte);
            { Gui mot ki tu + thuoc tinh ra man hinh }

  Procedure OutStr(x, y : Byte; St : String);
            { Gui mot chuoi ra man hinh }

  Procedure OutStrAttr(x, y : Byte; St : String; FG, BG : Byte);
            { Gui mot chuoi + thuoc tinh ra man hinh }

  Procedure OutByte(x, y : Byte; B : Byte);
            { Gui mot so kieu byte ra man hinh }

  Procedure OutWord(x, y : Byte; W : Word);
            { Gui mot so kieu word ra man hinh }

  Procedure OutShortInt(x, y : Byte; I : ShortInt);
            { Gui mot so kieu short_integer ra man hinh }

  Procedure OutInteger(x, y : Byte; I : Integer);
            { Gui mot so kieu integer ra man hinh }

  Procedure OutLongInt(x, y : Byte; I : LongInt);
            { Gui mot so kieu long_integer ra man hinh }

  Procedure OutReal(x, y : Byte; R : Real);
            { Gui mot so kieu real ra man hinh }

  Procedure HideCursor;

  Procedure ShowSmallCursor;

  Procedure ShowLargeCursor;

  Procedure SetBrightMode;

  Procedure SetBlinkMode;

{  Function GetKeyCode : Word;{}

  Procedure ClearWindow(x1, y1, x2, y2, FillColor : Byte);

  Procedure ShowASCIITable;

  Function Hexa(D : Word) : String;

  Function Binary(D : Word) : String;

  Function StrConv(i : Integer) : String;

IMPLEMENTATION

  Uses CRT, DOS;

  Procedure SetCharAttr;
    Begin
      CharAttr := (BG Mod 16)*16+(FG Mod 16);
    End;

  Procedure OutChar;
    Begin
      If (y <= 24)And(x <= 79) Then
        Screen[y, x] := CharAttr*256+Ord(Ch);
    End;

  Procedure OutCharAttr;
    Begin
      If (y <= 24)And(x <= 79) Then
        Screen[y, x] := ((BG Mod 16)*16+(FG Mod 16))*256+Ord(Ch);
    End;

  Procedure OutStr;
    Var
      i : Byte;
    Begin
      If (y <= 24)And(x <= 79) Then
        For i := 1 To Length(St) Do
          If y+(x+i-1) Div 80 <= 24 Then
            Screen[y+(x+i-1) Div 80, (x+i-1) Mod 80] := CharAttr*256+Ord(St[i]);
    End;

  Procedure OutStrAttr;
    Var
      i : Byte;
    Begin
      If (y <= 24)And(x <= 79) Then
        For i := 1 To Length(St) Do
          If y+(x+i-1) Div 80 <= 24 Then
            Screen[y+(x+i-1) Div 80, (x+i-1) Mod 80] :=
	      ((BG Mod 16)*16+(FG Mod 16))*256+Ord(St[i]);
    End;

  Procedure OutByte;
    Var
      St : String;
    Begin
      Str(B, St);
      OutStr(y, x, St);
    End;

  Procedure OutWord;
    Var
      St : String;
    Begin
      Str(W, St);
      OutStr(y, x, St);
    End;

  Procedure OutShortInt;
    Var
      St : String;
    Begin
      Str(I, St);
      OutStr(y, x, St);
    End;

  Procedure OutInteger;
    Var
      St : String;
    Begin
      Str(I, St);
      OutStr(y, x, St);
    End;

  Procedure OutLongInt;
    Var
      St : String;
    Begin
      Str(I, St);
      OutStr(y, x, St);
    End;

  Procedure OutReal;
    Var
      St : String;
    Begin
      Str(R:20:10, St);
      While (St <> '')And(St[1] = ' ') Do Delete(St, 1, 1);
      While (St <> '')And(St[Length(St)] = '0') Do Delete(St, Length(St), 1);
      If St[Length(St)] = '.' Then St := St+'0';
      OutStr(y, x, St);
    End;

  Procedure HideCursor; Assembler;
    Asm
      Mov AH, 01h
      Mov CX, 0200h
      Int 10h
    End;

  Procedure ShowSmallCursor; Assembler;
    Asm
      Mov AH, 01h
      Mov CH, 06h
      Mov CL, 07h
      Int 10h
    End;

  Procedure ShowLargeCursor; Assembler;
    Asm
      Mov AH, 01h
      Mov CH, 01h
      Mov CL, 08h
      Int 10h
    End;

  Procedure SetBrightMode; Assembler;
    Asm
      Mov AX, 1003h
      Mov BL, 00h
      Int 10h
    End;

  Procedure SetBlinkMode; Assembler;
    Asm
      Mov AX, 1003h
      Mov BL, 01h
      Int 10h
    End;

{  Function GetKeyCode;
    Var
      KeyCode : Word;
    Begin
      KeyCode := Ord(ReadKey);
      If KeyCode = 0 Then KeyCode := Ord(ReadKey)+$100;
      GetKeyCode := KeyCode;
    End;{}

  Procedure ClearWindow;
    Begin
      TextBackGround(FillColor);
      Window(x1, y1, x2, y2);
      ClrScr;
      Window(1, 1, 80, 25);
    End;

  Procedure ShowASCIITable;
    Var
      i : Byte;
    Begin
      TextAttr := 7;
      ClrScr;
      For i := 16 To 255 Do Write(i:3, Chr(i), ' ');
    End;

  Function Hexa;
    Var
      i : Word;
      S : String;
    Begin
      S := '';
      Repeat
        i := D Mod $10;
        D := (D-i) Div $10;
        Case i Of
          0..9 : S := Chr(i+48)+S;
          10..15 : S := Chr(i+55)+S;
        End;
      Until D <= 0;
      Hexa := S;
    End;

  Function Binary;
    Var
      i : Byte;
      S : String;
    Begin
      S := '';
      For i := 0 To 15 Do
        If D And (1 Shl i) <> 0 Then S := '1'+S
                                Else S := '0'+S;
      Binary := S;
    End;

  Function StrConv;
    Var
      S : String;
    Begin
      Str(i, S);
      StrConv := S;
    End;

BEGIN
  SetCharAttr(7, 0);
  SetBrightMode;
END.