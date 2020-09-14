  Const
    ScbTableSize = 15;
    ScbDoubleLetter = 1;
    ScbTripleLetter = 2;
    ScbDoubleWord   = 3;
    ScbTripleWord   = 4;
    ScbHideLetter   = 5;
    ScbNoLetter     = #0;
    ScbBlankLetter  = #32;

  Type
    TScbTableColor = Record
      ForeColor      : Byte;
      BackColor      : Byte;
      LetterColor    : Byte;
      NewLetterColor : Byte;
      LetterCount    : Byte;
      LetterScore    : Byte;
    End;

    TScbColor = Record
      ForeColor   : Byte;
      BackColor   : Byte;
      TitleBarFG  : Byte;
      TitleBarBG  : Byte;
      StatusBarFG : Byte;
      StatusBarBG : Byte
    End;

    TScbPlayerStatusColor = Record
      PlayerActiveFG  : Byte;
      PlayerActiveBG  : Byte;
      PlayerPassiveFG : Byte;
      PlayerPassiveBG : Byte
    End;

    TScbCharSet = Record
      ChrLetter : Array['A'..'Z'] Of Char;
      ChrBorder : Array[1..4] Of Char;
      ChrQuestion : Char;
    End;

    TScbCellArray = Array[1..ScbTableSize, 1..ScbTableSize] Of Char;
    TScbLetterCount = Array['A'..'Z'] Of Byte;

  Const
    ScbTableDefaultColor : TScbTableColor = (
      ForeColor      : 15;
      BackColor      :  6;
      LetterColor    :  9;
      NewLetterColor : 12;
      LetterCount    :  1;
      LetterScore    :  2
    );

    ScbDefaultColor : TScbColor = (
      ForeColor :  7;
      BackColor :  0;
      TitleBarFG  : 15;
      TitleBarBG  :  1;
      StatusBarFG : 15;
      StatusBarBG :  1
    );
    ScbPlayerStatusDefaultColor : TScbPlayerStatusColor = (
      PlayerActiveFG  : 15;
      PlayerActiveBG  :  1;
      PlayerPassiveFG :  7;
      PlayerPassiveBG :  0
    );

    ScbCharSet : TScbCharSet = (
      ChrLetter : (#192,#193,#194,#195,#196,#197,#198,#199,#200,#201,#202,#203,#204,
                   #205,#206,#207,#208,#209,#210,#211,#212,#213,#214,#215,#216,#217);
      ChrBorder : (#218,#219,#220,#221);
      ChrQuestion : #222
    );

    ScbMultiplier : Array[1..ScbTableSize, 1..ScbTableSize] Of Byte =
      ((4, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 4),
       (0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0),
       (0, 0, 3, 0, 0, 0, 1, 0, 1, 0, 0, 0, 3, 0, 0),
       (1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 3, 0, 0, 1),
       (0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0),
       (0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0),
       (0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0),
       (4, 0, 0, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 4),
       (0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0),
       (0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0),
       (0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0),
       (1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 3, 0, 0, 1),
       (0, 0, 3, 0, 0, 0, 1, 0, 1, 0, 0, 0, 3, 0, 0),
       (0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0),
       (4, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 4)
    );

    ScbLetterCountDefault : TScbLetterCount  = (9, 2, 2, 4,12, 2, 3, 2, 9, 1, 1, 4, 2,
                                                6, 8, 2, 1, 6, 4, 6, 4, 2, 2, 1, 2, 1);
    ScbLetterScore : Array['A'..'Z'] Of Byte = (1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3,
                                                1, 1, 3,10, 1, 1, 1, 1, 4, 4, 8, 4,10);
    ScbBlankCountDefault : Byte = 2;

