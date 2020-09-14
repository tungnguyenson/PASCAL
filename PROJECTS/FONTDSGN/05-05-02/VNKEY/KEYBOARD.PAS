UNIT Keyboard;

INTERFACE

  Const

    kbNoKey = $00;

    { Define normal keys }
    kbBackspace = $08;
    kbTab       = $09;
    kbCtrlEnter = $0A;
    kbEnter     = $0D;
    kbEsc       = $1B;
    kbSpaceBar  = $20;

    kbCtrlA = $01;  kbCtrlB = $02;  kbCtrlC = $03;  kbCtrlD = $04;
    kbCtrlE = $05;  kbCtrlF = $06;  kbCtrlG = $07;  kbCtrlH = $08;
    kbCtrlI = $09;  kbCtrlJ = $0A;  kbCtrlK = $0B;  kbCtrlL = $0C;
    kbCtrlM = $0D;  kbCtrlN = $0E;  kbCtrlO = $0F;  kbCtrlP = $10;
    kbCtrlQ = $11;  kbCtrlR = $12;  kbCtrlS = $13;  kbCtrlT = $14;
    kbCtrlU = $15;  kbCtrlV = $16;  kbCtrlW = $17;  kbCtrlX = $18;
    kbCtrlY = $19;  kbCtrlZ = $1A;

    kb0 = $30;  kb1 = $31;  kb2 = $32;  kb3 = $33;  kb4 = $34;
    kb5 = $35;  kb6 = $36;  kb7 = $37;  kb8 = $38;  kb9 = $39;

    { Define function keys }
    kbShiftTab     = $10F;
    kbHome         = $147;
    kbUpArrow      = $148;
    kbPageUp       = $149;
    kbLeftArrow    = $14B;
    kbRightArrow   = $14D;
    kbEnd          = $14F;
    kbDownArrow    = $150;
    kbPageDown     = $151;
    kbInsert       = $152;
    kbDelete       = $153;
    kbCtrlEnd      = $175;
    kbCtrlPageDown = $176;
    kbCtrlHome     = $177;
    kbCtrlPageUp   = $184;

    kbAltQ = $110;  kbAltW = $111;  kbAltE = $112;  kbAltR = $113;
    kbAltT = $114;  kbAltY = $115;  kbAltU = $116;  kbAltI = $117;
    kbAltO = $118;  kbAltP = $119;  kbAltA = $11E;  kbAltS = $11F;
    kbAltD = $120;  kbAltF = $121;  kbAltG = $122;  kbAltH = $123;
    kbAltJ = $124;  kbAltK = $125;  kbAltL = $126;  kbAltZ = $12C;
    kbAltX = $12D;  kbAltC = $12E;  kbAltV = $12F;  kbAltB = $130;
    kbAltN = $131;  kbAltM = $132;

    kbF1 = $13B;  kbF2 = $13C;  kbF3 = $13D;  kbF4 = $13E;  kbF5 = $13F;
    kbF6 = $140;  kbF7 = $141;  kbF8 = $142;  kbF9 = $143;  kbF10 = $144;

    kbShiftF1 = $154;  kbShiftF2 = $155;  kbShiftF3 = $156;  kbShiftF4 = $157;  kbShiftF5 = $158;  kbShiftF6 = $159;
    kbShiftF7 = $15A;  kbShiftF8 = $15B;  kbShiftF9 = $15C;  kbShiftF10 = $15D;

    kbCtrlF1 = $15E;  kbCtrlF2 = $15F;  kbCtrlF3 = $160;  kbCtrlF4 = $161;
    kbCtrlF5 = $162;  kbCtrlF6 = $163;  kbCtrlF7 = $164;  kbCtrlF8 = $165;
    kbCtrlF9 = $166;  kbCtrlF10 = $167;

    kbAltF1 = $168;  kbAltF2 = $169;  kbAltF3 = $16A;  kbAltF4 = $16B;
    kbAltF5 = $16C;  kbAltF6 = $16D;  kbAltF7 = $16E;  kbAltF8 = $16F;
    kbAltF9 = $170;  kbAltF10 = $171;

    { Keyboard shift mask states }
    {
    { 7 6 5 4 3 2 1 0
    {     x x x x x x
    {     1 0 0 0 0 0
    {       0 0 0 0 0
    }

    kbShiftRight = $01;
    kbShiftLetf  = $02;
    kbCtrl       = $04;
    kbAlt        = $08;
    kbScrollLock = $10;
    kbNumLock    = $20;
    kbCapsLock   = $40;
    kbInsertMode = $80;

  Var
    kbShiftMask : Byte Absolute $0000:$0417;

  {  Lay ma phim duoc nhan. Khi dung ham nay, chuong trinh se dung lai
     cho den khi co mot phim bat ki duoc nhan }
  Function GetKeyCode : Word;

  {  Kiem tra xem co phim nao duoc nhan khong }
  Function IsKeyPressed : Boolean;

  {  Lay trang thai byte ShiftMask }
  Function GetShiftMask : Byte;

  {  Dat toc do ban phim }
  Procedure SetKeyboardSpeed(Delay, Rate : Byte);

  {  Gia lap 1 phim nhan }
  Procedure SendKey(KeyCode : Word);

  {  Lay ten phim duoc nhan }
  Function GetKeyName(KeyCode : Word) : String;

IMPLEMENTATION

  Uses DOS;

  Function GetKeyCode;
    Var
      Regs : Registers;
    Begin
      Regs.AH := $00;
      Intr($16, Regs);
      If Regs.AL <> 0 Then GetKeyCode := Regs.AL
                      Else GetKeyCode := Regs.AH+$100;
    End;

  Function IsKeyPressed;
    Var
      Regs : Registers;
    Begin
      Regs.AH := $01;
      Intr($16, Regs);
      If Regs.Flags And FZero <> 0 Then IsKeyPressed := False
                                   Else IsKeyPressed := True;
    End;

  Function GetShiftMask;
    Var
      Regs : Registers;
    Begin
      { GetShiftMask := Mem[$0000:$0417]; }
      Regs.AH := $02;
      Intr($16, Regs);
      GetShiftMask := Regs.AL;
    End;

  Procedure SetKeyboardSpeed; Assembler;
    Asm
      Mov AH, $03
      Mov AL, $05
      Mov BH, Delay
      Mov BL, Rate
      Int 16H
    End;

  Procedure SendKey;
    Var
      Regs : Registers;
    Begin
      Regs.AH := $05;
      Regs.CH := 0;
      Regs.CL := KeyCode;
      Intr($16, Regs);
    End;

  Function GetKeyName;
    Const
      AltChar1 : Array[kbAltQ..kbAltP] Of Char =
                 ('Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P');
      AltChar2 : Array[kbAltA..kbAltL] Of Char =
                 ('A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L');
      AltChar3 : Array[kbAltZ..kbAltM] Of Char =
                 ('Z', 'X', 'C', 'V', 'B', 'N', 'M');
    Var
      Ch : Char;
      S, KeyName : String;
    Begin
      KeyName := '';
      Case KeyCode Of
        $0021..$00FF : KeyName := Chr(KeyCode);

        kbBackSpace : KeyName := 'Backspace';
        kbEnter     : KeyName := 'Enter';
        kbEsc       : KeyName := 'Escape';
        kbTab       : KeyName := 'Tab';
        kbSpaceBar  : KeyName := 'Space Bar';

        kbCtrlA..kbCtrlZ : KeyName := 'Ctrl+'+Chr(KeyCode+64);

        kbShiftTab     : KeyName := 'Shift+Tab';
        kbHome         : KeyName := 'Home';
        kbUpArrow      : KeyName := 'Up Arrow';
        kbPageUp       : KeyName := 'Page Up';
        kbLeftArrow    : KeyName := 'Left Arrow';
        kbRightArrow   : KeyName := 'Right Arrow';
        kbEnd          : KeyName := 'End';
        kbDownArrow    : KeyName := 'Down Arrow';
        kbPageDown     : KeyName := 'Page Down';
        kbInsert       : KeyName := 'Insert';
        kbDelete       : KeyName := 'Delete';
        kbCtrlEnd      : KeyName := 'Ctrl+End';
        kbCtrlPageDown : KeyName := 'Ctrl+Page Down';
        kbCtrlHome     : KeyName := 'Ctrl+Home';
        kbCtrlPageUp   : KeyName := 'Ctrl+Page Up';

        kbF1..kbF10 :
          Begin
            Str(KeyCode-$13B+1, S);
            KeyName := 'F'+S;
          End;

        kbShiftF1..kbShiftF10 :
          Begin
            Str(KeyCode-$154+1, S);
            KeyName := 'Shift+F'+S;
          End;

        kbCtrlF1..kbCtrlF10 :
          Begin
            Str(KeyCode-$15E+1, S);
            KeyName := 'Ctrl+F'+S;
          End;

        kbAltF1..kbAltF10 :
          Begin
            Str(KeyCode-$168+1, S);
            KeyName := 'Alt+F'+S;
          End;

        kbAltQ..kbAltP : KeyName := 'Alt+'+AltChar1[KeyCode];
        kbAltA..kbAltL : KeyName := 'Alt+'+AltChar2[KeyCode];
        kbAltZ..kbAltM : KeyName := 'Alt+'+AltChar3[KeyCode];

      End;
      GetKeyName := KeyName;
    End;
END.