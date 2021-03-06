    PString = ^String;

    TEvent = Record
      EvType : Word;
      Processed : Boolean;
      Case Word Of
        evNothing : ();
        evCommand : (Command : Word);
        evKeyDown : (KeyCode : Word; KeyChar : Char; ShiftMask : Byte);
        evMessage : (Message : Word);
    End;

    PSaveScreen = ^TSaveScreen;
    TSaveScreen = Object
      Buffer : Array[0..80*25*2-1] Of Word;
      Procedure Load;
      Procedure Save;
    End;

    TTable = Object
      X1, Y1, X2, Y2 : Byte;
      Shadow : Boolean;
      ForeColor, BackColor : Byte;
      Procedure Init(L, T, R, B : Byte; FG, BG : Integer);
      Procedure DrawTable;
      Procedure DrawColumn(X : Byte; T, B : Integer);
      Procedure DrawRow(Y : Byte; L, R : Integer);
    End;

    TCommonControlObject = Object

      Left, Top, Width, Height : Byte;
      Right, Bottom : Byte;

      Caption        : PString;
      LenCaption     : Byte;
      ForeColor      : Byte;
      BackColor      : Byte;
      Background     : Byte;
      HighlightColor : Byte;

      AutoSize : Boolean;
      Enabled  : Boolean;
      Visible  : Boolean;
      Active   : Boolean;

      HotKey  : Char;
      Alignment : Byte;

      TabIndex : Byte;
      TabStop  : Boolean;
      Priority : Byte;

      Constructor Init(L, T, W, H : Integer;
                       S : String;
                       FG, BG, HLColor : Integer);

      Procedure Move(L, T, W, H : Integer); Virtual;

      Procedure Show; Virtual;

      Procedure ChangeCaption(S : String); Virtual;

      Procedure ShowCaption(X, Y, FG, BG : Integer);

      Procedure Hide; Virtual;

      Destructor Done;

    End;

    PLabel = ^TLabel;
    TLabel = Object(TCommonControlObject)

      Constructor Init(L, T, W, H : Integer;
                       S : String;
                       FG, BG, HLColor : Integer);

      Procedure InitLabel(L, T, W : Integer;
                          S : String;
                          FG, BG, HLColor : Integer;
                          Align : Byte);

      Procedure MoveLabel(L, T, W : Integer);

      Procedure Show; Virtual;

      Destructor Done;

    End;

    PCommandButton = ^TCommandButton;
    TCommandButton = Object(TCommonControlObject)

      SelForeColor : Byte;
      SelBackColor : Byte;
      Command : Word;

      Constructor Init(L, T, W, H : Integer;
                       S : String;
                       FG, BG, HLColor : Integer);

      Procedure InitButton(L, T : Integer;
                           S : String;
                           FG, BG, SelFG, SelBG, HLColor : Integer;
                           Cmd : LongInt;
                           TabIdx : Integer);

      Procedure Show; Virtual;

      Procedure Hide; Virtual;

      Procedure ShowShrink;

      Procedure LostFocus;
      Procedure SetFocus;

      Destructor Done;

    End;

    PSingleLineTextBox = ^TSingleLineTextBox;
    TSingleLineTextBox = Object(TCommonControlObject)

      SelForeColor : Byte;
      SelBackColor : Byte;

      Txt : PString;
      MaxLength : Byte;
      SelStart  : Byte;
      SelLength : Byte;

      CursorPos : Byte;
      LeftChar  : Byte;
      RightChar : Byte;

      Constructor Init(L, T, W, H : Integer;
                       S : String;
                       FG, BG, HLColor : Integer);

      Procedure InitTextBox(L, T, W : Integer;
                            S : String;
                            FG, BG, SelFG, SelBG : Integer;
                            TabIdx : Integer;
                            MaxLen : Integer);

      Procedure Show; Virtual;

      Procedure Hide; Virtual;

      Procedure MoveCursor(I : Byte);

      Procedure ChangeText(S : String);

      Procedure Highlight;

      Procedure SetFocus;

      Destructor Done;

    End;

    PCheckBox = ^TCheckBox;
    TCheckBox = Object(TCommonControlObject)

      Value : Byte;

      Constructor Init(L, T, W, H : Integer;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             