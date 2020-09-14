Program VNKey;

Uses DOS;

Const
  MaxRow = 500;

Type
  TScrString = String[80];

  TDesktop = Object
    Left, Top, Width, Height : Byte;
    ForeColor, BackColor : Byte;
    FillChar : Char;
    Procedure Init;
    Procedure Show;
  End;

  TTitleBar = Object
    ForeColor, BackColor : Byte;
    Caption : TScrString;
    Procedure Init(S : TScrString);
    Procedure Show;
    Procedure Change(S : String);
  End;

  TStatusBar = Object
    ForeColor, BackColor : Byte;
    Caption : TScrString;
    Procedure Init(S : TScrString);
    Procedure Show;
    Procedure Change(S : String);
  End;

  PDocument = ^TDocument;
  TDocument = Object
    Left, Top, Width, Height : Byte;
    ForeColor, BackColor : Byte;
    FileName : TScrString;
    Active : Boolean;

    RowCount : Word;
    Row, Col : Word;
    PageRows : Word;
    PageTopRow, PageBottomRow : Word;

    Txt : Array[1..MaxRow] Of TScrString;

    Procedure Init;
    Procedure Show;
    Procedure LoadFromFile(FName : String);
    Procedure SaveToFile(FName : String);
    Procedure ApplyCursorPosition;
  End;

  TApplication = Object

    Desktop   : TDesktop;
    TitleBar  : TTitleBar;
    StatusBar : TStatusBar;
    Document  : PDocument;

    AppExit : Boolean;
    Procedure Init;
    Procedure Run;
    Procedure Done;
    Procedure Show;
  End;

{*---------------------------- REFERENCES  ---------------------------*}

{*--- DISPLAY ---*}

  Procedure OutChar(X, Y : LongInt; Ch : Char; FG, BG : Integer);
            { Gui mot ki tu + thuoc tinh ra man hinh }
    Begin
      If (X >= 1)And(X <= 80) And (Y >= 1)And(Y <= 25) Then
        MemW[$B800:((Y-1)*80+X-1)*2] := ((BG Mod 16)*16+(FG Mod 16))*256+Ord(Ch);
    End;

  Procedure OutStr(X, Y : LongInt; St : String; FG, BG : Integer);
            { Gui mot chuoi + thuoc tinh ra man hinh }
    Var
      I : Byte;
    Begin
      For I := 1 To Length(St) Do
        OutChar(X+I-1, Y, St[I], FG, BG);
    End;

  Procedure ClearWindow(X1, Y1, X2, Y2, ForeColor, BackColor : Integer);
    Var
      X, Y : Word;
    Begin
      For Y := Y1 To Y2 Do
        For X := X1 To X2 Do
          MemW[$B800:((Y-1)*80+X-1)*2] := (BackColor*$10+ForeColor)*$100;
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

{*--- GENERAL ---*}

  Const
    AlignLeft   = 0;
    AlignCenter = 1;
    AlignRight  = 2;

  Function TextAlign(AlignType : Byte;
                     Left, Right : Byte;
                     St : TScrString ) : Byte;
    Begin
      Case AlignType Of
        AlignCenter : TextAlign := (Right+Left-Length(St)) Div 2+1;
        AlignRight  : TextAlign := Right-Length(St)+1;
        Else TextAlign := Left;
      End;
    End;


{*--- KEYBOARD ---*}

  Const

    kbNoKey = $00;
    kbEnter     = $0D;
    kbEsc       = $1B;
    kbSpaceBar  = $20;
    kbBackspace = $08;
    kbHome         = $147;
    kbUpArrow      = $148;
    kbPageUp       = $149;
    kbLeftArrow    = $14B;
    kbRightArrow   = $14D;
    kbEnd          = $14F;
    kbDownArrow    = $150;
    kbPageDown     = $151;
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

  Function GetKeyCode : Word;
    Var
      Regs : Registers;
    Begin
      Regs.AH := $00;
      Intr($16, Regs);
      If Regs.AL <> 0 Then GetKeyCode := Regs.AL
                      Else GetKeyCode := Regs.AH+$100;
    End;

  Function IsKeyPressed : Boolean;
    Var
      Regs : Registers;
    Begin
      Regs.AH := $01;
      Intr($16, Regs);
      If Regs.Flags And FZero <> 0 Then IsKeyPressed := False
                                   Else IsKeyPressed := True;
    End;

{*----------------------------- INSTANTS -----------------------------*}

  Procedure TDesktop.Init;
    Begin
      Left   := 1;
      Top    := 1;
      Width  := 80;
      Height := 25;
      ForeColor := 7;
      BackColor := 9;
    End;

  Procedure TDesktop.Show;
    Begin
      ClearWindow(Left, Top, Left+Width-1, Top+Height-1, ForeColor, BackColor);
    End;

  Procedure TTitleBar.Init;
    Begin
      ForeColor := 15;
      BackColor := 1;
      Caption := S;
    End;

  Procedure TTitleBar.Show;
    Var
      X : Byte;
    Begin
      ClearWindow(1, 1, 80, 1, ForeColor, BackColor);
      X := TextAlign(AlignCenter, 1, 80, Caption);
      OutStr(X, 1, Caption, ForeColor, BackColor);
    End;

  Procedure TTitleBar.Change;
    Begin
      Caption := S;
      Show;
    End;

  Procedure TStatusBar.Init;
    Begin
      ForeColor := 15;
      BackColor :=  1;
      Caption := S;
    End;

  Procedure TStatusBar.Show;
    Begin
      ClearWindow(1, 25, 80, 25, ForeColor, BackColor);
      OutStr(1, 25, Caption, ForeColor, BackColor);
    End;

  Procedure TStatusBar.Change;
    Begin
      Caption := S;
      Show;
    End;

  Procedure TDocument.Init;
    Begin
      Left   := 1;
      Top    := 2;
      Width  := 80;
      Height := 23;

      ForeColor := 15;
      BackColor := 0;
      Active := True;

      RowCount := 0;
      Row := 0;
      Col := 0;
      PageRows := Height;
      PageTopRow := 0;
      PageBottomRow := 0;
{* The following code is included for debug only *}
      FileName := 'readme';
      LoadFromFile(FileName);
    End;

  Procedure TDocument.Show;
    Begin
      If Active Then ShowSmallCursor
                Else HideCursor;
    End;

  Procedure TDocument.LoadFromFile;
    Var
      F : Text;
    Begin
      RowCount := 0;
      Assign(F, FName);
      {$I-}
      Reset(F);
      {$I+}
      If IOResult = 0 Then
        Begin
          While Not EOF(F) Do
            Begin
              Inc(RowCount);
              ReadLn(F, Txt[RowCount]);
            End;
        End;
    End;

  Procedure TDocument.SaveToFile;
    Begin
    End;

  Procedure TDocument.ApplyCursorPosition;
    Begin
      PageTop
    End;


  Procedure TApplication.Init;
    Begin
      New(Document);
      Desktop.Init;
      TitleBar.Init('VNKey Version 1.0');
      StatusBar.Init('Alt+X : Exit');
      AppExit := False;
    End;

  Procedure TApplication.Run;
    Var
      KeyCode : Word;
    Begin
      Show;
      Repeat
        KeyCode := kbNoKey;
        If IsKeypressed Then KeyCode := GetKeyCode;
        If KeyCode <> kbNoKey Then
          Case KeyCode Of
            kbEsc : AppExit := True;
          End;
      Until AppExit;
    End;

  Procedure TApplication.Done;
    Begin
      Dispose(Document);
      Desktop.Show;
    End;

  Procedure TApplication.Show;
    Begin
      HideCursor;
      Desktop.Show;
      TitleBar.Show;
      StatusBar.Show;
      Document^.Show;
    End;

{*-------------------------- MAIN PROGRAM ----------------------------*}

Var
  App : TApplication;

BEGIN
  App.Init;
  App.Run;
  App.Done;
END.