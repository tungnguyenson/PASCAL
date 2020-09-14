Uses Dos,graph;

Const
  InputFile = 'solitare.bmp';
  OutputFile = 'solitare.pic';
  PaletteFile = 'solitare.pal';

Type
   ColorReg=Record
               Red1,Green1,Blue1:Byte;
            End;
   TArray256=Array[0..255]of ColorReg;
   TArray16=Array[0..15]of ColorReg;
   ExtendedPalette=Record
                       ExtendedPalette:Byte;
                       ExPalette:TArray256;
                   End;
   BMPColorReg=Record
                  BiBlue,BiGreen,BiRed,BiReserve:Byte;
               End;
   TBitmapHeader=Record
                    BfType:Array[1..2]of Char;
                    BfSize:LongInt;
                    BfReserve:Array[1..4]of Char;
                    BfOffBits:LongInt;
                 End;
   TBitmapInfoHeader=Record
                        BiSize,BiWidth,BiHeight:LongInt;
                        BiPlanes,BiBitCount:Word;
                        BiCompression,BiSizeImage,BiXPelsPerMeter,
                        BiYPelsPerMeter,BiClrUsesd,BiClrImportant:LongInt;
                     End;
   TBMPPalette=Array[0..15]of BMPColorReg;
   TBMPPalette256=Array[0..255]of BMPColorReg;
Var
   BMPHdr:TBitmapHeader;
   BMPIf:TBitmapInfoHeader;
   BMPPalette:TBMPPalette;
   BMP256:TBMPPalette256;
   BMPMode:Byte;
Procedure SetVideo(Mode:Integer);
   Var
      R:Registers;
   Begin
      With R do
         Begin
            AX:=Mode;
            Intr($10,R);
         End;
   End;
Procedure WritePixel(Col,Row:Word;Color:Byte);
   Var
      R:Registers;
   Begin
      FillChar(R,SizeOf(R),0);
      With R do
         Begin
            AH:=$0C;
            BH:=$00;
            AL:=Color;
            CX:=Col;
            DX:=Row;
            Intr($10,R);
         End;
   End;
Procedure IncPoint(Var P:Pointer;T:LongInt);
   Begin
      P:=Ptr(Seg(P^),Ofs(P^)+t);
   End;
Procedure Install256(Array256:TArray256);
   Var
      R:Registers;
   Begin
      With R do
         Begin
            AH:=$10;
            AL:=$12;
            BX:=$00;
            CX:=256;
            ES:=Seg(Array256);
            DX:=Ofs(Array256);
            Intr($10,R);
         End;
   End;
Procedure Install16(Array16:TArray16);
   Var
      R:Registers;
   Begin
      With R do
         Begin
            AH:=$10;
            AL:=$12;
            BX:=$00;
            CX:=16;
            ES:=Seg(Array16);
            DX:=Ofs(Array16);
            Intr($10,R);
         End;
   End;
Procedure InstallBMP;
   Var
      I:Word;
      Palette16:TArray16;
      Palette256:TArray256;
      AllPlt:Array[0..16]of ShortInt;
      R:Registers;
      F : Text;
   Begin
     Assign(F, PaletteFile);
     ReWrite(F);
     If BMPIf.BiBitCount<>8 then
         Begin
            WriteLn(F, 16);
            For I:=0 to 15 do
               Begin
                  Palette16[i].Red1:=BMPPalette[i].BiRed Shr 2;
                  Palette16[i].Green1:=BMPPalette[i].BiGreen Shr 2;
                  Palette16[i].Blue1:=BMPPalette[i].BiBlue Shr 2;
                  WriteLn(F, Palette16[i].Red1:3,
                             Palette16[i].Green1:3,
                             Palette16[i].Blue1:3);
               End;
            AllPlt[16]:=0;
            For I:=0 to 15 do AllPlt[i]:=i;
            With R do
               Begin
                  AH:=$10;
                  AL:=2;
                  ES:=Seg(AllPlt);
                  DX:=Ofs(AllPlt);
                  Intr($10,R);
               End;
            Install16(Palette16);
         End
      Else
         Begin
            WriteLn(F, 256);
            For I:=0 to 255 do
               Begin
                  Palette256[i].Red1:=BMP256[i].BiRed Shr 2;
                  Palette256[i].Green1:=BMP256[i].BiGreen Shr 2;
                  Palette256[i].Blue1:=BMP256[i].BiBlue Shr 2;
                  WriteLn(F, Palette256[i].Red1:3,
                             Palette256[i].Green1:3,
                             Palette256[i].Blue1:3);
               End;
            Install256(Palette256);
         End;
     Close(F);
   End;

Procedure Convert;
   Const
      BufSize:Word=65535;
   Var
      Buffer,P:Pointer;
      F:File;
      FT : Text;
      H, V : Integer;
      I,Result,ReadRs,NumRead,ByteLine:Word;
      B,K,NumS,Mask,Bc:Byte;
      J:Integer;
      HorLimit,VerLimit,MaxH,MaxV,RealyByte:Word;
   Begin
      Assign(F, InputFile);
      {$I-}
      Reset(F,1);
      If IOResult<>0 Then Exit;
      {$I+}
      BlockRead(F,BMPHdr,SizeOf(BMPHdr));
      BlockRead(F,BMPIf,SizeOf(BMPIf));
      If BMPIf.BiBitCount<>8 then BlockRead(F,BMPPalette,Sizeof(BMPPalette))
                             Else BlockRead(F,BMP256,SizeOf(BMP256));
      If BMPHdr.BfType<>'BM' then
         Begin
            Close(F);
            Writeln(InputFile,' is not BMP file.');
            Exit;
         End;
      Seek(F,BMPHdr.BfOFFBits);
      While MaxAvail<BufSize do Dec(BufSize);
      If BMPIf.BiBitCount<>8 then
         Begin
            BMPMode:=$12;
            MaxH:=640;
            MaxV:=480;
         End
         Else Begin
                 BMPMode:=$12;
                 MaxH:=640;
                 MaxV:=480;
              End;
{      SetVideo(BMPMode);}
      InstallBMP;
      GetMem(Buffer,Bufsize);
      P:=Buffer;
      NumRead:=0;
      BlockRead(F,Buffer^,BufSize,Result);
      If BMPIf.BiWidth<MaxH Then ByteLine:=BMPIf.BiWidth
                            Else ByteLine:=MaxH;
      HorLimit:=ByteLine-1;
      VerLimit:=0;
      If BMPIf.BiHeight<MaxV Then J:=BMPIf.BiHeight-1
                            Else J:=MaxV-1;
      I:=0;
      Bc:=BMPIf.BiBitCount;
      NumS:=8 Div Bc;
      RealyByte:=BMPIf.BiWidth;
      H := RealyByte;
      V := J;
      Case BC of
         8:Begin
              Mask:=$FF;
              While RealyByte Mod 4 <> 0 do Inc(RealyByte);
           End;
         4:Begin
              Mask:=$0F;
              While RealyByte Mod 8 <> 0 do Inc(RealyByte);
           End;
         1:Begin
              Mask:=$01;
              While RealyByte Mod 32 <> 0 do Inc(RealyByte);
           End;
      End;
      Dec(RealyByte);
      Repeat
         B:=Byte(P^);
         IncPoint(P,1);
         Inc(NumRead);
         If NumRead=Result Then
            Begin
               P:=Buffer;
               BlockRead(F,Buffer^,BufSize,Result);
               NumRead:=0;
            End;
         If BMPIf.BiCompression=0 Then
            Begin
               For K:=1 to NumS do
                  Begin
                     If I<ByteLine Then PutPixel(i,j,(B Shr (8-Bc*K))and Mask);
                     If I<RealyByte Then Inc(I)
                                    Else
                                       Begin
                                           I:=0;
                                           Dec(j);
                                       End;
                  End;
            End;
      Until (j<VerLimit)or(Port[$60]=1);
      Close(f);
      FreeMem(Buffer,BufSize);
      Asm
        Mov AX, 0000H
        Int 33H
        Mov AX, 0001H
        Int 33H
      End;
      Assign(FT, OutputFile);
      Rewrite(FT);
      WriteLn(FT, V+1, ' ', H);
      For i := 0 To V Do
        Begin
          For j := 0 To H-1 Do Write(FT, GetPixel(j, i):3);
          WriteLn(FT);
        End;
      Close(FT);
      ReadLn;
      SetVideo(3);
   End;


Var
  gd, gm : Integer;

Begin
  Gd := InstallUserDriver('svga256', Nil);
  gm := 2;
  InitGraph(Gd, Gm, 'c:\tp\bgi');
  Convert;
  CloseGraph;
End.