UNIT Global;

INTERFACE

  Uses DOS;

  Const
        SortByDir       = 1;
        SortByName      = 2;
        SortByExt       = 3;
        SortBySize      = 4;
        SortByTime	= 5;
        UnSorted        = 6;
        AlignLeft       = 0;
        AlignCenter     = 1;
        AlignRight      = 2;
        Brief           = 1;
        Full            = 2;

    {Dir Name Ext Size Time Unsort}
  Type
    TSortByArray = Array[1..6] Of Byte;

  Const
    SortByArray : Array[2..6] Of TSortByArray =
                  ({Dir Name Ext Size Time Unsort}
                  {Sorby Name: Dir Name Ext Unsort Unsort Unsort}
                  (5, 4, 3, 0, 0 ,0),
                  {Sorby Ext : Dir Ext Name Unsort Unsort Unsort}
                  (5, 3, 4, 0, 0 ,0),
                  {Sorby Size: Dir Size Name Ext Unsort Unsort}
                  (5, 3, 2, 4, 0 ,0),
                  {Sorby Time: Dir Time Name Ext Unsort Unsort}
                  (5, 3, 2, 0, 4 ,0),
                  {Unsorted: Unosrt Unsort Unsort Unsort Unsort Unsort}
                  (0, 0, 0, 0, 0 ,0));

  Function TextAlign(AlignType : Byte; X1, X2 : Byte; S : String): Byte;

  Function LeadingZero(I : Integer): String;

  Function From24to12(H : Byte) : Byte;

  Function AMorPM(Dt : DateTime) : Char;

  Function LowerStr(S : String) : String;

  Function UpPath(Path : String) : String;

  Function DownPath(Path : String; Dir : String) : String;

  Function GetDirectory(Path : String) : String;

  Function RecognizeRunAbleFile(FileNameExt : String) : Boolean;

IMPLEMENTATION

    Function TextAlign;
    Begin
      Case AlignType Of
        AlignLeft   : TextAlign := X1;
        AlignCenter : TextAlign := (X1+X2-Length(S)) Div 2+1;
        AlignRight  : TextAlign := X2-Length(S);
      End;
    End;

    Function LeadingZero;
    Var S : String;
    Begin
      Str(I, S);
      If Length(S) = 1 then S := '0'+S;
      If Length(S) > 2 then S := Copy(S, Length(S)-1, 2);
      LeadingZero := S;
    End;

    Function From24to12;
    Begin
      If H = 12 then From24to12 := 0
                Else From24to12 := H mod 12;
    End;

    Function AMorPM;
    Begin
      With dt do
        Begin
          If Hour>12 then AMorPM := 'p'
                  Else
                   If Hour<12 then AMorPM := 'a'
                            Else
                              If Min=0 then AMorPM := 'a'
                                       Else AMorPM := 'p';
        End;
    End;

    Function LowerStr;
    Var i : Byte;
    Begin
      For i := 1 to Length(S) do
        If S[i] in ['A' .. 'Z'] then
          S[i] := Chr(Ord(S[i])+32);
      LowerStr := S;
    End;

    Function UpPath;
    Var I, J : Byte;
    Begin
      For i := 1 to Length(Path)-1 do
        If Path[i] = '\' then J := I;
      UpPath := Copy(Path, 1, J);
    End;

  Function DownPath;
  Begin
    DownPath := Path+Dir+'\';
  End;

  Function GetDirectory;
  Var i, j : Byte;
  Begin
    For i := Length(Path)-1 downto 1 do
      If Path[i] = '\' then
        Begin
          j := i;
          i := 1;
        End;
    GetDirectory := Copy(Path, j+1, Length(Path)-j-1);
  End;

  Function RecognizeRunAbleFile;
  Begin
    If (FileNameExt = 'BAT') or
       (FileNameExt = 'COM') or
       (FileNameExt = 'EXE') then
      RecognizeRunAbleFile := True
    Else
      RecognizeRunAbleFile := False
  End;

BEGIN
END.