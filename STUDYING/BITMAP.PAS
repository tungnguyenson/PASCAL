Unit Bitmap;

{

Cau truc file BMP:

1. Bitmap Header:
+--------+-----------------------------+-------------------------------------+
|  Byte  |           Y nghia           |              Chi tiet               |
+--------+-----------------------------+-------------------------------------+
|  0-1   | Nhan dang file              | Hai ki tu 'BM'                      |
|  2-5   | Kich thuoc file             | Kieu LongInt                        |
|  6-9   | Danh rieng                  | Mang gia tri 0                      |
| 10-13  | Byte bat dau vung du lieu   | Offset cua byte bat dau vung du     |
|        |                             | lieu ke tu dau file                 |
+--------+-----------------------------+-------------------------------------+

2. Bitmap Info:
+--------+-----------------------------+-------------------------------------+
|  Byte  |           Y nghia           |              Chi tiet               |
+--------+-----------------------------+-------------------------------------+
|  0-3   | So byte trong vung Info     | Hien tai la 40                      |
|  4-7   | Chieu rong bitmap           | Tinh bang pixel                     |
|  8-11  | Chieu cao bitmap            | Tinh bang pixel                     |
| 12-13  | So planes mau               | Luon bang 40(thuc te co the khac 1) |
| 14-15  | So bits cho 1 pixel         | Cac gia tri co the la: 1,4,8,24     |
| 16-19  | Kieu nen du lieu            | 0 : Khong nen                       |
|        |                             | 1 : Nen runlength 8 bits/pixel      |
|        |                             | 2 : Nen runlength 4 bits/pixel      |
| 20-23  | Kich thuoc anh              | Tinh bang byte                      |
| 24-27  | Do phan giai ngang          | Tinh bang pixel/meter               |
| 28-31  | Do phan giai doc            | Tinh bang pixel/meter               |
| 32-35  | So mau duoc su dung trong   |                                     |
|        | and                         |                                     |
| 36-39  | So mau duoc su dung khi     |                                     |
|        | hien anh                    |                                     |
+--------+-----------------------------+-------------------------------------+

3. Bitmap Palette:
  - Day la tap hop cac entries, moi entry co kich thuoc 4 bytes xep lien
    nhau, theo cau truc Blue-Green-Red va 1 byte danh cho itensity hien
    chua dung toi.
  - So luong entries bang so mau cua anh
  - Kich thuoc Palette = 4 * So entries
  - So mau cua anh dua tren so bits cho 1 pixel:
      8 bits/pixel : Anh 256 mau
      4 bits/pixel : Anh 16 mau
      1 bits/pixel : Anh 2 mau

4. Bitmap Data:
  - Day la phan chua cac gia tri mau cua cac diem anh trong bitmap
  - Cac diem anh duoc luu theo thu tu trai->phai, duoi->tren
  - Cac byte trong vung Bitmap Data bieu dien 1 hay nhieu diem phu thuoc vao
    so bits cho 1 pixel

}

Interface

  Var
    BMPLoadingError : Boolean;

  Procedure LoadBMP(x, y : Integer; BMPFile : String);

Implementation

  Uses DOS, Graph;

  Type
    ColorReg = Record
      Red, Green, Blue : Byte;
    End;

    TPalette256 = Array[0..255] Of ColorReg;
    TPalette16 = Array[0..15] Of ColorReg;

    BitmapColorReg = Record
      Blue, Green, Red, Reserve : Byte;
    End;

    TBitmapPalette16 = Array[0..15] Of BitmapColorReg;
    TBitmapPalette256 = Array[0..255] Of BitmapColorReg;

    BitmapHeaderRec = Record
      BitmapType : Array[1..2] Of Char;
      BitmapSize : LongInt;
      Reserve : Array[1..4] Of Byte;
      DataOffset : LongInt;
    End;

    BitmapInfoRec = Record
      InfoSize : LongInt;
      BitmapWidth : LongInt;
      BitmapHeight : LongInt;
      Planes : Word;
      BitsPerPixel : Word;
      Compression : LongInt;
      ImageSize : LongInt;
      XRes, YRes : LongInt;
      BitmapColorsUses : LongInt;
      ImageColorUses : LongInt;
    End;

  Var
    BMPHeader : BitmapHeaderRec;
    BMPInfo : BitmapInfoRec;
    BMPPalette16 : TBitmapPalette16;
    BMPPalette256 : TBitmapPalette256;

Procedure InstallPalette256(Palette256 : TPalette256);
  Var
    Regs : Registers;
  Begin
    With Regs do
      Begin
         AH := $10;
         AL := $12;
         BX := $00;
         CX := 256;
         ES := Seg(Palette256);
         DX := Ofs(Palette256);
         Intr($10, Regs);
      End;
   End;

Procedure InstallPalette16(Palette16 : TPalette16);
  Var
    Regs : Registers;
  Begin
    With Regs do
      Begin
         AH := $10;
         AL := $12;
         BX := $00;
         CX := 16;
         ES := Seg(Palette16);
         DX := Ofs(Palette16);
         Intr($10, Regs);
      End;
   End;

Procedure InstallBMP;
  Var
    i : Word;
    Palette16 : TPalette16;
    Palette256 : TPalette256;
    AllPlt : Array[0..16] Of ShortInt;
    Regs : Registers;
  Begin
    If BMPInfo.BitsPerPixel <> 8 Then
      Begin
        For i := 0 To 15 Do
          Begin
            Palette16[i].Red := BMPPalette16[i].Red Shr 2;
            Palette16[i].Green := BMPPalette16[i].Green Shr 2;
            Palette16[i].Blue := BMPPalette16[i].Blue Shr 2;
          End;
        AllPlt[16]:=0;
        For i := 0 To 15 Do AllPlt[i] := i;
        With Regs do
          Begin
            AH := $10;
            AL := $02;
            ES := Seg(AllPlt);
            DX := Ofs(AllPlt);
            Intr($10, Regs);
          End;
        InstallPalette16(Palette16);
      End
     Else
      Begin
        For I:=0 to 255 do
          Begin
            Palette256[i].Red := BMPPalette256[i].Red Shr 2;
            Palette256[i].Green := BMPPalette256[i].Green Shr 2;
            Palette256[i].Blue := BMPPalette256[i].Blue Shr 2;
          End;
        InstallPalette256(Palette256);
      End;
  End;

  Procedure LoadBMP;
    Const
      BufSize : Word = 65535;
    Var
      F : File;
      Buffer : Pointer;
    Begin
      BMPLoadingError := False;
      Assign(F, BMPFile);
      {$I-}Reset(F, 1);{$I+}
      If IOResult <> 0 Then
        BMPLoadingError := True
       Else If FileSize(F) < SizeOf(BMPHeader)+SizeOf(BMPInfo) Then
        BMPLoadingError := True
       Else
        Begin
          BlockRead(F, BMPHeader, SizeOf(BMPHeader));
          BlockRead(F, BMPInfo, SizeOf(BMPInfo));
          If BMPHeader.BitmapType <> 'BM' Then
            Begin
              Close(F);
              BMPLoadingError := True;
            End
           Else
            Begin
              If BMPInfo.BitsPerPixel <> 8 Then
                BlockRead(F, BMPPalette16, SizeOf(BMPPalette16))
               Else BlockRead(F, BMPPalette256, SizeOf(BMPPalette256));
              Seek(F, BMPHeader.DataOffset);
              While MemAvail < BufSize Do Dec(BufSize);
              GetMem(Buffer, BufSize);
            End;
        End;
    End;

END.