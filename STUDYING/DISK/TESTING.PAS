Uses CRT, DOS;

Procedure ReadMasterSector(Disk : Char; Seg : Word; Ofs : Word);
  Var
    Regs : Registers;
  Begin
    Case Disk Of
       'A' : Regs.DX := $0000;
       'C' : Regs.DX := $0080;
    End;
    Regs.AX := $0201;     {ham 2, doc 1 sector}
    Regs.CX := $0001;     {cylinder 0, sector 1, do la bootsector}
    Regs.BX := Ofs;       {offset cua bo dem}
    Regs.ES := Seg;       {segment cua bo dem}
    Intr($13, Regs);      {ngat 13 cua bios doc boot}
  End;

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

Function ReadAbsSector(DiskName : Char;
                    StartSector : LongInt;
                    NumberRead : Word;
                    SegBuf : Word;
                    OfsBuf : Word
                    ) : Boolean;
  Var
    Regs : Registers;
    InfoBuf : Array[0..9] Of Byte;
    L : LongInt;
  Begin
    With Regs Do
      Begin
        AH := $25;
        Case Upcase(DiskName) Of
          'A' : AL := 0;
          'D' : AL := $81
          Else AL := $80;
        End;
        CX := $FFFF;
        Move(StartSector, InfoBuf[0], 4);
        Move(NumberRead, InfoBuf[4], 2);
        L := SegBuf*$10000+OfsBuf;
        L := OfsBuf*$10000+SegBuf;{}
        Move(L, InfoBuf[6], 4);
        DS := Seg(InfoBuf);
        BX := Ofs(InfoBuf);
        MsDOS(Regs);
        If AH <> 0 Then
          Begin
            WriteLn('Error: ', AL);
          End;
      End;
  End;

Var
  DOS_Sector : LongInt;
  Side : Word;
  Track : Word;
  Sector : Word;
  Buffer : Array[0..8192] Of Byte;

Const
  Sectors = 63;
  Sides = 128;

Procedure ReadLogicalSector(DOS_Sector : LongInt);
  Var
    I : Word;
  Begin
    Side := (DOS_Sector Div Sectors) Mod Sides;
    Track := DOS_Sector Div (Sectors*Sides);
    Sector := 1 + DOS_Sector Mod Sectors;
    DOS_Sector := (Sector-1)+Side*Sectors+Track*Sectors*Sides;
    ReadPhysicalSector('C', Side, Track, Sector, 1, Seg(Buffer), Ofs(Buffer));{}
    Inc(DOS_Sector);
    For I := 0 To 300 Do
      Begin
        If Buffer[I] >= 16 Then Write(Chr(Buffer[I]))
                           Else Write('.');
        If (I > 0)And(I Mod 16 = 15) Then WriteLn;
      End;{}
  End;

BEGIN
  ClrScr;
{  ReadMasterSector('C', Seg(Buffer), Ofs(Buffer));{}
{  ReadAbsSector('C', 1, 1, Seg(Buffer), Ofs(Buffer));{}
  ReadLogicalSector(1);
  ReadLn;
END.