Unit Graph32;

Interface

  Type

    NullString = Array[0..255] Of Char;
    ModeList = Array[1..3277] Of Word;

    SVGAInformation = Record
      Signature : Array[1..4] Of Char;
      Version : Word;
      OEMStringPtr : ^NullString;
      Capabilities : LongInt;
      VideoModePtr : ^ModeList;
      TotalMemory : Integer;
      OEMSoftwareRev : Integer;
      OEMVendorNamePtr : Pointer;
      OEMProductNamePtr : Pointer;
      Reseved : Array[1..222] Of Byte;
      OEMData : Array[1..256] Of Byte;
    End;

    SVGAMode = Record
      ModeAttributes : Word;
      WinAAttributes : Byte;
      WinBAttributes : Byte;
      WinGranularity : Integer;
      Winsize : Word;
      WinASegment : Word;
      WinBSegment : Word;
      WinFunctionPtr : Procedure;
      BytesPerScanLine : Integer;
      XResolution : Integer;
      YResolution : Integer;
      XCharSize : Byte;
      YCharSize : Byte;
      NumberOfPlnes : Byte;
      MemoryModel : Byte;
      BankSize : Byte;
      NumberOfImagePages : Byte;
      Reseved : Byte;
      RedMaskSize : Byte;
      RedFieldPosition : Byte;
      GreenMaskSize : Byte;
      GreenFieldPosition : Byte;
      BlueMaskSize : Byte;
      BlueFieldPosition : Byte;
      RsvdmaskSize : Byte;
      RsvdFieldPosition : Byte;
      DirectColorModeInfor : Byte;
      PhysicalBasePtr : Pointer;
      OffScreenMemOffset : Pointer;
      OffScreenMemSize : Integer;
    End;

  Var

    VESAInfor : SVGAInformation;
    VESAModelInfor : SVGAMode;
    Max, MaxY : Word;
    BitPerPixel : Byte;
    Seg_, Ofs_ : Word;
    BytePerPixel : Byte;
    x_ : Word;
    P, PO : Word;
    DP : Byte;

  Function GetVESAInfor : Boolean;

  Function GetModelInfor(Mode : Word) : Boolean;

  Function FindMode(X, Y : Word; B : Byte) : Word;

  Function InitGraph(X, Y : Word; B : Byte) : Boolean;

  Procedure PutPixel(X, Y : Word; R, G, B : Byte);

  Function CloseGraph : Boolean;

Implementation

  Function GetVESAInfor;
    Var
      ReturnCode : Word;
    Begin
      Asm
        Mov AX, Seg VESAInfor
        Mov ES, AX
        Mov DI, Offset VESAInfor
        Mov AX, $4F00
        Int $10
        Mov ReturnCode, AX
      End;
      If ReturnCode = $4F Then GetVESAInfor := True
                          Else GetVESAInfor := False;
    End;

  Function GetModelInfor;
    Begin
    End;

  Function FindMode;
    Begin
    End;

  Function InitGraph;
    Begin
    End;

  Procedure PutPixel;
    Begin
    End;

  Function CloseGraph;
    Begin
    End;

End.