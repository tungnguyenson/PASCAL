Program Long_File_Name;

Uses CRT, DOS;

Const
  Sides = 128;
  Sectors = 63;
  RootDirStartSector = 12404+63;

Var
  DOS_Sector : LongInt;
  Side : Word;
  Track : Word;
  Sector : Word;
  Finish : Boolean;
  Offset : Word;
  Buffer : Array[0..4095] Of Byte;

Procedure ReadPhysicalSector(Disk : Char;
                             Side : Byte;
                             Track : Byte;
                             Sector : Byte;
                             NumRead : Byte;
                             Seg : Word; Ofs : Word);
  Var
    Regs : Registers;
  Begin
    With Regs Do
      Begin
        Regs.AH := $02;
        Case Disk Of
          'A' : Regs.DL := $00;
          'C' : Regs.DL := $80;
        End;
        DH := Side;
        CH := Track;
        CL := Sector;
        AL := NumRead;
        BX := Ofs;
        ES := Seg;
        Intr($13, Regs);
      End;
  End;

Procedure GetBufferStr(Ofs, Len : Word; Var S : String);
  Var
    I : Word;
  Begin
    S := '';
    For I := Ofs To Ofs+Len-1 Do
      If (Buffer[I] <> 0)And(Buffer[I] <> $FF)Then
        S := S+Chr(Buffer[I]);
  End;

Procedure LR_Trim(Var S : String);
  Begin
    While (S <> '')And(S[1] = ' ')Do Delete(S, 1, 1);
    While (S <> '')And(S[Length(S)] = ' ')Do Delete(S, Length(S), 1);{}
  End;

Procedure CheckEndOfSector(Var Offset : Word);
  Begin
    If Offset > 511 Then
      Begin
        Side := (DOS_Sector Div Sectors) Mod Sides;
        Track := DOS_Sector Div (Sectors*Sides);
        Sector := 1 + DOS_Sector Mod Sectors;
        DOS_Sector := (Sector-1)+Side*Sectors+Track*Sectors*Sides;
        ReadPhysicalSector('C', Side, Track, Sector, 1, Seg(Buffer), Ofs(Buffer));{}
        Inc(DOS_Sector);
        Offset := 0;
      End;
  End;

Function ReadDirInfo(Var Ofs : Word) : Boolean;
  Var
    FileName : String;
    FileExt : String;
    LFileName : String;
    S : String;
    Cluster : Word;
    FileAttr : Byte;
    I, J : Word;
    Y : Byte;
  Begin
    ReadDirInfo := False;
    If (Buffer[Ofs] <> 0) Then
      Begin
        If (Buffer[Ofs] <> $00) And (Buffer[Ofs] <> $2E) Then
          Begin
            ReadDirInfo := True;
            Move(Buffer[Ofs+11], FileAttr, 2);
            If (Buffer[Ofs] <> $E5)And(FileAttr <> VolumeID) Then
              Begin
                GetBufferStr(Ofs, 8, FileName);
                GetBufferStr(Ofs+8, 3, FileExt);
                LR_Trim(FileName);
                LR_Trim(FileExt);
                Move(Buffer[Ofs+26], Cluster, 2);
                LFileName := '';
                If (Cluster = 0) And
                   (FileName+'.'+FileExt <> 'IO.SYS') And
                   (FileName+'.'+FileExt <> 'MSDOS.SYS') Then
                  Begin
                    Repeat
                      FileName := '';
                      GetBufferStr(Ofs+1, 10, S);
                      FileName := FileName+S;
                      GetBufferStr(Ofs+14, 12, S);
                      FileName := FileName+S;
                      GetBufferStr(Ofs+28, 4, S);
                      FileName := FileName+S;
                      LFileName := FileName+LFileName;
                      Move(Buffer[Ofs+32+26], Cluster, 2);
                      Inc(Ofs, 32);
                      CheckEndOfSector(Ofs);
                    Until Cluster <> 0;
                    LR_Trim(LFileName);
                    GetBufferStr(Ofs, 8, FileName);
                    GetBufferStr(Ofs+8, 3, FileExt);
                    LR_Trim(FileName);
                    LR_Trim(FileExt);
                    Move(Buffer[Ofs+26], Cluster, 2);
                    Move(Buffer[Ofs+11], FileAttr, 2);
                  End;
                If FileAttr And Directory <> 0 Then
                  Begin
                    FileName := '['+FileName+']';
                    If LFileName <> '' Then LFileName := '['+LFileName+']';
                  End
                 Else If LFileName = '' Then
                  Begin
                    If FileExt <> '' Then FileName := FileName+'.'+FileExt;
                    For J := 1 To Length(FileName) Do
                      If FileName[J] In ['A'..'Z'] Then
                        FileName[J] := Chr(Ord(FileName[J])+32);
                  End;
                GoToXY(1, WhereY);
                Write(FileName);
                GoToXY(15, WhereY);
                WriteLn(LFileName);
              End;
            Inc(Ofs, 32);
          End;
      End;
  End;

BEGIN
  ClrScr;
  DOS_Sector := RootDirStartSector;
  Finish := False;
  Offset := 512;
  WriteLn('DOS Name      Long file name');
  WriteLn('----------------------------');
  Repeat
    CheckEndOfSector(Offset);
    Finish := ReadDirInfo(Offset) = False;
  Until Finish;
  ReadLn;
END.