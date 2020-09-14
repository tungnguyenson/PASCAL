Unit Disk;

Interface

  Type
    TSector = Array[0..512*9-1] Of Byte;
    PSector = ^TSector;

  Var
    ErrorResult : Byte;

  Function ErrorMsg(Error : Byte) : String;
  Function CheckDisk : Byte;
  Function ReadPhysicalSector(Side, Track, Sector : Byte; Quantity : Byte;
                              Var Dest : PSector) : Byte;

Implementation

Uses DOS;

Var
  Buf : Array[0..511] Of Byte;
  Regs : Registers;
  F : File;

Function ErrorMsg(Error : Byte) : String;
  Var
    Msg : String;
  Begin
    Case Error Of
      $00 : Msg := 'The operation was successful';
      $01 : Msg := 'Error $01 : Lenh khong hop le!';
      $02 : Msg := 'Error $02 : Khong tim thay dau dia chi tren dia!';
      $03 : Msg := 'Error $03 : Dia co bao ve chong ghi!';
      $04 : Msg := 'Error $04 : Khong tim thay sector!';
      $05 : Msg := 'Error $05 : Tai lap khong duoc!';
      $06 : Msg := 'Error $06 : Dia mem da bi lay ra khoi o!';
      $07 : Msg := 'Error $07 : Bang tham so da bi hong!';
      $08 : Msg := 'Error $08 : DMA chay lo!';
      $09 : Msg := 'Error $09 : DMA chay o ngoai pham vi 64K!';
      $0A : Msg := 'Error $0A : Sector flag error!';
      $10 : Msg := 'Error $10 : CRC hay ECC loi!';
      $11 : Msg := 'Error $11 : ECC da dieu chinh du lieu sai!';
      $20 : Msg := 'Error $20 : Loi do bo dieu khien dia!';
      $40 : Msg := 'Error $40 : Loi khong tim duoc track!';
      $80 : Msg := 'Error $80 : Loi het thoi gian!';
      $AA : Msg := 'Error $AA : O dia khong san sang!';
      $BB : Msg := 'Error $BB : Loi khong xac dinh!';
      $CC : Msg := 'Error $CC : Loi luc ghi!';
      $E0 : Msg := 'Error $E0 : Loi thanh ghi trang thai!';
      $FF : Msg := 'Error $FF : Thao tac do that bai!';
      Else Msg := 'Unknown error!';
    End;
    ErrorMsg := Msg;
  End;

Function CheckDisk : Byte;
  Var
    Regs : Registers;
  Begin
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $00;  { Phuc vu 0 }
        DL := $00;  { DL = 0 : Floppy Disk }
        Intr($13, Regs);
        CheckDisk := AH;
      End;
  End;

Procedure Phuc_Vu_1;
  Var
    Regs : Registers;
  Begin
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $01;
        DL := $80;
        Intr($13, Regs);
      End;
  End;

Function ReadPhysicalSector(Side, Track, Sector : Byte; Quantity : Byte;
                            Var Dest : PSector) : Byte;
  Var
    i : Word;
  Begin
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $02;  { Read }
        DH := $00;  { Side }
        DL := $00;  { Drive $00 = A, $01 = B, $80 = C, $81 = D}
        CH := $00;  { Track }
        CL := $01;  { Sector }
        AL := Quantity;  { Quantity of sector }
        ES := Seg(Dest^);
        BX := Ofs(Dest^);
        Intr($13, Regs);
        ReadPhysicalSector := AH;
      End;
  End;
{
Procedure Phuc_Vu_3;
  Begin
    FillChar(Regs, SizeOf(Regs), 0);
    FillChar(Buf, SizeOf(Buf), 0);
    With Regs Do
      Begin
        AH := $03;
        AL := $01;
        DH := $00;
        DL := $00;
        CH := $00;
        CL := $01;
        ES := Seg(Buf);
        BX := Ofs(Buf);
        Intr($13, Regs);
        WriteErrorMsg(AH);
      End;
  End;

Procedure Phuc_Vu_8;
  Var
    Drive, Side, Cylinder, Sector : Byte;
  Begin
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $08;
        Drive := $80;
        DL := Drive;
        Intr($13, Regs);
        WriteErrorMsg(AH);
        If AH = $00 Then
          Begin
            Side := DH;
            Cylinder := (CL Shr 6) Shl 8+CH;
            Sector := CL-(CL Shr 6) Shl 6;
            WriteLn('Side : 0..', Side);
            WriteLn('Cylinder : 0..', Cylinder);
            WriteLn('Sector : 1..', Sector);
          End;
      End;
  End;

Procedure FillDisk;
  Var
    Buf : Array[0..511] Of Byte;
    Drive, Side, Cylinder, Sector, i, j, k : LongInt;
    Time, Count, NumberSector : LongInt;
  Begin
    Time := MemL[$0000:$046C];
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $08;
        Drive := $00;
        DL := Drive;
        Intr($13, Regs);
        WriteErrorMsg(AH);
        If AH = $00 Then
          Begin
            Side := DH;
            Cylinder := (CL Shr 6) Shl 8+CH;
            Sector := CL-(CL Shr 6) Shl 6;
            WriteLn('Side : 0..', Side);
            WriteLn('Cylinder : 0..', Cylinder);
            WriteLn('Sector : 1..', Sector);
          End;
        NumberSector := (Side+1)*(Cylinder+1)*Sector;
        Count := 0;
        FillChar(Buf, SizeOf(Buf), 0);
        For i := 0 To Side Do
          For j := 0 To Cylinder Do
            For k := 1 To Sector Do
              Begin
                Inc(Count);
                Write('Side ', i:3, '/', Side, ' Cylinder ', j:3, '/', Cylinder,
                        ' Sector ', k:2, '/', Sector);
                WriteLn('. ', Count:5, ' sectors/', NumberSector, ' sectors');
                AH := $03;
                AL := $01;
                DL := Drive;
                DH := i;
                CL := (j Shr 8) Shl 6+k;
                CH := j-(j Shr 8);
                ES := Seg(Buf);
                BX := Ofs(Buf);
                Intr($13, Regs);
              End;
      End;
    WriteLn((MemL[$0000:$046C]-Time)/18.2:0:0);
  End;

Procedure SaveDisk;
  Var
    Buf : Array[0..511] Of Byte;
    F : File;
    Drive, Side, Cylinder, Sector, i, j, k : LongInt;
    Time, NumberSector, Count : LongInt;
  Begin
    Time := MemL[$0000:$046C];
    FillChar(Regs, SizeOf(Regs), 0);
    With Regs Do
      Begin
        AH := $08;
        Drive := $80;
        DL := Drive;
        Intr($13, Regs);
        WriteErrorMsg(AH);
        If AH = $00 Then
          Begin
            Side := DH;
            Cylinder := (CL Shr 6) Shl 8+CH;
            Sector := CL-(CL Shr 6) Shl 6;
            WriteLn('Side : 0..', Side);
            WriteLn('Cylinder : 0..', Cylinder);
            WriteLn('Sector : 1..', Sector);
          End;
        FillChar(Buf, SizeOf(Buf), 0);
        Assign(F, 'c:\floppy.sav');
        Rewrite(F, 1);
        NumberSector := (Side+1)*(Cylinder+1)*Sector;
        Count := 0;
        For i := 0 To Side Do
          For j := 0 To Cylinder Do
            For k := 1 To Sector Do
              Begin
                Inc(Count);
                Write('Side ', i:3, '/', Side, ' Cylinder ', j:3, '/', Cylinder,
                        ' Sector ', k:2, '/', Sector);
                WriteLn('. ', Count:5, ' sectors/', NumberSector, ' sectors');
                AH := $02;
                AL := 1;
                DL := Drive;
                DH := i;
                CL := (j Shr 8) Shl 6+k;
                CH := j-(j Shr 8);
                ES := Seg(Buf);
                BX := Ofs(Buf);
                Intr($13, Regs);
{                BlockWrite(F, Buf, SizeOf(Buf));}
{              End;
        Close(F);
      End;
    WriteLn((MemL[$0000:$046C]-Time)/18.2:0:0);
  End;
}

END.