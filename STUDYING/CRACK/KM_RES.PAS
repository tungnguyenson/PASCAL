{$R+,I+,S+,C+,B+}

Const
  Slot = 0; {0..9; Slot 0 = game000.sav, Slot 1 = game001.sav, ...}
  ResCount = 27;
  BufSize = 32767; {27..32767}
  OfsNotFound = -1;

Type
  TResources = Array[1..ResCount] Of Word;

Const
  OldRes : TResources = (
                0,   43,   35,   29,    0,
                0,    0,   56,   70,    0,
               50,    0,    0,   20,    0,
                0,    0,    0,    0,    0,
                0,    0,    0,    0,    0,
                0,    0
           );
{
  TreeTrunks  Stones        Timber      IronOrc       GoldOrc
  Coal        Iron          Gold        WineBarrels   Corn
  Loaves      Flour         Leather     Sousages      Pigs
  Skin        WoodenShield  LongShield  LeatherArmor  IronArmament
  HandAxe     Sword         Lance Pike  LongBow
  CrossBow    Horses
}
  NewRes : TResources = (
              200,  200,   50,  500,  100,
              500,    0,  100,  200,  100,
              200,  100,    0,  200,  100,
                0,    0,    0,    0,    0,
                0,    0,    0,    0,    0,
                0,    0
           );

Var
  SrcFile   : String;
  Buffer    : Array[0..BufSize-1] Of Byte;
  BufCount  : Integer;
  ResBuffer : Array[0..ResCount*2-1] Of Byte;
  OfsData   : LongInt;

Procedure ClrScr; Assembler;
  Asm
    mov AX, 0003H
    int 10H
  End;

Function LongintToHex(L : LongInt) : String;
  Const
    HexChar : Array[0..15] Of Char = '0123456789ABCDEF';
  Var
    I, J : Byte;
    S : String;
  Begin
    S := '';
    For I := 1 To 8 Do
      Begin
        J := L Mod 16;
        L := L Div 16;
        S := HexChar[J]+S;
      End;
    LongintToHex := S;
  End;

Function CheckSrcFile : Boolean;
  Var
    F : File;
    S : String;
  Begin
    SrcFile := '';
    If (Slot < 0)Or(Slot > 9) Then CheckSrcFile := False
     Else
      Begin
        Str(Slot, S);
        S := 'GAME00'+S+'.SAV';
        Assign(F, S);
        {$I-}Reset(F);{$I+}
        If IOResult <> 0 Then CheckSrcFile := False
         Else
          Begin
            CheckSrcFile := True;
            SrcFile := S;
            Close(F);
          End

      End;
  End;

Function SearchForOldRes : LongInt;
  Var
    F : File;
    SearchPos : LongInt;
    Found : Boolean;
    I, NumRead : Integer;
    Offset : LongInt;
  Begin
    SearchPos := 0;
{    SrcFile := 'setup.txt';{}
    Assign(F, SrcFile);
    Reset(F, 1);
    For I := 0 To ResCount-1 Do
      Begin
        ResBuffer[I*2] := Lo(OldRes[I+1]);
        ResBuffer[I*2+1] := Hi(OldRes[I+1]);
      End;
    Found := False;
    BufCount := 0;
    Offset := 0;
    Repeat
      If BufCount > ResCount*2 Then
        Begin
          For I := 1 To ResCount*2 Do
            Buffer[I-1] := Buffer[BufCount-ResCount*2+I-1];
          For I := ResCount*2+1 To BufCount Do
            Buffer[I-1] := 0;
          BufCount := ResCount*2;
          BlockRead(F, Buffer[BufCount], BufSize-BufCount, NumRead);
          BufCount := BufCount+NumRead;;
        End
       Else
        Begin
          BlockRead(F, Buffer[0], BufSize, NumRead);
          BufCount := NumRead;
        End;
      If BufCount >= ResCount*2 Then
        Begin
          SearchPos := 0;
{          WriteLn(Offset);{}
          Repeat
{            If Offset = 785112 Then
              If SearchPos = 2707 Then
                I := 0;{}
            I := 0;
            {$R-}
            While (Buffer[SearchPos+I] = ResBuffer[I])And
                  (I <= ResCount*2) Do Inc(I);
            {$R+}
            If I > ResCount*2 Then
              Begin
                Found := True;
                Offset := Offset+SearchPos;
              End;
            Inc(SearchPos);
          Until (SearchPos >= BufCount-ResCount*2) Or (Found);
          If Not Found Then
            Offset := Offset+SearchPos;
        End;
    Until EOF(F);
    Close(F);
    If Found Then
      SearchForOldRes := Offset
     Else
      SearchForOldRes := OfsNotFound;
  End;

Procedure UpdateNewRes;
  Var
    F : File;
    I, NumRead : Integer;
  Begin
    Assign(F, SrcFile);
    Reset(F, 1);
    For I := 0 To ResCount-1 Do
      Begin
        ResBuffer[I*2] := Lo(NewRes[I+1]);
        ResBuffer[I*2+1] := Hi(NewRes[I+1]);
      End;
    Seek(F, OfsData);
    BlockWrite(F, ResBuffer, ResCount*2);
    Close(F);
  End;

BEGIN
  ClrScr;
  WriteLn;
  WriteLn('       =============       ');
  Writeln('KNIGHT & MERCHANTS RESOURCE');
  WriteLn('       =============       ');
  Writeln;
  If CheckSrcFile = False Then
    Writeln('Game saved slot is not exist!')
   Else
    Begin
      Writeln('File saved: ', SrcFile);
      Write('Searching for old resouces...');
      OfsData := SearchForOldRes;
      If OfsData = OfsNotFound Then
        Writeln('not found!')
       Else
        Begin
          Writeln('found at: ', OfsData, ' ($', LongintToHex(OfsData), ')');
          Write('Updating resources...........');
          UpdateNewRes;
          Writeln('completed!');
        End;
    End;
  Writeln;
  Write('Press Enter to exit...');
  Readln;
END.