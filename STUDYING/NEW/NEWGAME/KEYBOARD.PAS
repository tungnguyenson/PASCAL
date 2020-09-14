UNIT Keyboard;

INTERFACE

  Const
    kbBackspace = $08;
    kbTab = $09;
    kbCtrlEnter = $0A;
    kbEnter = $0D;
    kbEsc = $1B;
    kbSpaceBar = $20;

    kbCtrlA = $01;  kbCtrlB = $02;  kbCtrlC = $03;  kbCtrlD = $04;
    kbCtrlE = $05;  kbCtrlF = $06;  kbCtrlG = $07;  kbCtrlH = $08;
    kbCtrlI = $09;  kbCtrlJ = $0A;  kbCtrlK = $0B;  kbCtrlL = $0C;
    kbCtrlM = $0D;  kbCtrlN = $0E;  kbCtrlO = $0F;  kbCtrlP = $10;
    kbCtrlQ = $11;  kbCtrlR = $12;  kbCtrlS = $13;  kbCtrlT = $14;
    kbCtrlU = $15;  kbCtrlV = $16;  kbCtrlW = $17;  kbCtrlX = $18;
    kbCtrlY = $19;  kbCtrlZ = $1A;

    kb0 = $30;  kb1 = $31;  kb2 = $32;  kb3 = $33;  kb4 = $34;
    kb5 = $35;  kb6 = $36;  kb7 = $37;  kb8 = $38;  kb9 = $39;

    kbHome = $147;
    kbUpArrow = $148;
    kbPageUp = $149;
    kbLeftArrow = $14B;
    kbRightArrow = $14D;
    kbEnd = $14F;
    kbDownArrow = $150;
    kbPageDown = $151;
    kbInsert = $152;
    kbDelete = $153;

    kbF1 = $13B;  kbF2 = $13C;  kbF3 = $13D;  kbF4 = $13E;  kbF5 = $13F;
    kbF6 = $140;  kbF7 = $141;  kbF8 = $142;  kbF9 = $143;  kbF10 = $144;

    kbCtrlF1 = $15E;  kbCtrlF2 = $15F;  kbCtrlF3 = $160;  kbCtrlF4 = $161;
    kbCtrlF5 = $162;  kbCtrlF6 = $163;  kbCtrlF7 = $164;  kbCtrlF8 = $165;
    kbCtrlF9 = $166;  kbCtrlF10 = $167;

    kbAltF1 = $168;  kbAltF2 = $169;  kbAltF3 = $16A;  kbAltF4 = $16B;
    kbAltF5 = $16C;  kbAltF6 = $16D;  kbAltF7 = $16E;  kbAltF8 = $16F;
    kbAltF9 = $170;  kbAltF10 = $171;

    { Keyboard shift mask states }
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

  Function GetKeyCode : Word;
  Function IsKeyPressed : Boolean;
  Function GetShiftMask : Byte;
  Procedure SetKeyboardSpeed(Delay, Rate : Byte);
  Procedure SendKey(KeyCode : Word);

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
    End;

  Procedure SendKey; Assembler;
    Asm
    End;


END.