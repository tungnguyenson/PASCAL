{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT, DOS;

Const
  ResultFile = 'scan.rsl';
  AllAttr = ReadOnly+Archive+Hidden+Directory+VolumeID+SysFile;
  ID = 'PK';

Var
  NumberFound : LongInt;
  F : File;
  FT : Text;
  Buf : Array[1..2] Of Char;
  S : String;
  i : Byte;
  Attr, LastAttr : Word;
  FCRT : Text;

Procedure ScanDir(Dir : String);
  Var
    SR : SearchRec;
  Begin
    WriteLn(FCRT, Dir);
    If KeyPressed Then
      Exit;
    FindFirst(Dir+'*.*', AllAttr, SR);
    While (DOSError = 0)And( Not Keypressed) Do
      Begin
        If SR.Attr And Directory <> 0 Then
          Begin
            If (SR.Name <> '.')And(SR.Name <> '..')And(Length(Dir) <= 50) Then
              ScanDir(Dir+SR.Name+'\');
          End
         Else If (SR.Attr And VolumeID = 0)And(SR.Size >= 2)And(SR.Name <> 'CHKDSK.EXE') Then
          Begin
            Assign(F, Dir+SR.Name);
            GetFAttr(F, LastAttr);
            SetFAttr(F, Archive);
            Reset(F, 1);
            BlockRead(F, Buf, SizeOf(Buf));
            Close(F);
            SetFAttr(F, LastAttr);
            S := '';
            For i := 1 To 2 Do
              S := S+Buf[i];
            If S = ID Then
              Begin
                Inc(NumberFound);
                S := Dir+SR.Name;
                WriteLn(FT, S, SR.Size:(72-Length(S)));
                WriteLn(FCRT, '':Length(Dir), SR.Name,
                        'ZIP':(79-Length(Dir+SR.Name)));
              End;
{            WriteLn;{}
          End;
        FindNext(SR);
      End;
  End;

BEGIN
  ClrScr;
  NumberFound := 0;
  Assign(FT, ResultFile);
  Rewrite(FT);
  AssignCRT(FCRT);
  Rewrite(FCRT);
  S := ParamStr(1);
  If S = '' Then S := FExpand('');
  If S[Length(S)] <> '\' Then S := S+'\';
  ScanDir(S);
  Write(FT, NumberFound, ' files found.');
  Close(FCRT);
  Close(FT);
END.