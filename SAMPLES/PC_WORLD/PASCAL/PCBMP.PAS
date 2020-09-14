Unit PCBMP;
Interface
Uses ASMGraph,Dos,Crt;
Type
ColorReg=Record
   Red1:Byte;
   Green1:Byte;
   Blue1:Byte;
End;
TArray256=Array[0..255] of ColorReg;
TArray16=Array[0..15] of ColorReg;
ExtendedPalette	= Record
	               	ExtendedPalette:Byte;
                 		(* Max size of 768 bytes *)
     	            	ExPalette:TArray256;
                    End;

BMPColorReg=Record
   biBlue:Byte;
   biGreen:Byte;
   biRed:Byte;
   biReserve:Byte;
End;

TBitmapHeader=Record
   bfType:Array[1..2] of char;
   bfSize:longint;
   bfReserve:Array[1..4] of char;
   bfOffBits:longint;
End;

TBitmapInfoHeader = record
   biSize: Longint;
   biWidth: Longint;
   biHeight: Longint;
   biPlanes: Word;
   biBitCount: Word;
   biCompression: Longint;
   biSizeImage: Longint;
   biXPelsPerMeter: Longint;
   biYPelsPerMeter: Longint;
   biClrUsed: Longint;
   biClrImportant: Longint;
end;
TBMPPalette=Array[0..15] of BMPColorReg;
TBMPPalette256=Array[0..255] of BMPColorReg;
Var
   BMPHdr:TBitmapHeader;
   BMPIf:TBitmapInfoHeader;
   BMPPalette:TBMPPalette;
   BMP256:TBMPPalette256;
   BMPMode:Byte;

Procedure LoadBMP(FileName:String);
(*-------------------------*)
Implementation
(*-------------------------*)
Procedure IncPoint(Var P:Pointer;t:longint);
Begin
   P:=Ptr(Seg(P^),Ofs(P^)+t)
End;
(*-------------------------*)
Procedure Install256(Array256:TArray256);
Var R:Registers;
Begin
   With R do begin
	   AH:=$10;  { Set Block of Color Registers }
		AL:=$12;
		BX:=$00;
		CX:=256;
		ES:= Seg(Array256);
	   DX:= Ofs(Array256);
	   Intr($10,R)
	End
End;
(*-------------------------*)
Procedure Install16(Array16:TArray16);
Var R:Registers;
Begin
   With R do begin
	   AH:=$10;  { Set Block of Color Registers }
		AL:=$12;
		BX:=$00;
		CX:=16;
		ES:= Seg(Array16);
	   DX:= Ofs(Array16);
	   Intr($10,R)
	End
End;
(*-------------------------*)
Procedure InstallBMP;
Var i:Word;
    Palette16:TArray16;
    Palette256:TArray256;
    AllPlt:Array[0..16] of Shortint;
    R:Registers;
Begin
   If BMPIf.biBitCount<>8 then begin
      For i:=0 to 15 do begin
          Palette16[i].Red1:=BMPPalette[i].biRed shr 2;
          Palette16[i].Green1:=BMPPalette[i].biGreen shr 2;
          Palette16[i].Blue1:=BMPPalette[i].biBlue shr 2;
      End;
      AllPlt[16]:=0;
      For i:=0 to 15 do AllPlt[i]:=i;
      With R do begin
           AH:=$10;
           AL:=2;
           ES:=Seg(AllPlt);
           DX:=Ofs(AllPlt);
           Intr($10,R)
      End;
      Install16(Palette16)
   End{If}
   Else begin
      For i:=0 to 255 do begin
          Palette256[i].Red1:=BMP256[i].biRed shr 2;
          Palette256[i].Green1:=BMP256[i].biGreen shr 2;
          Palette256[i].Blue1:=BMP256[i].biBlue shr 2;
      End;
      Install256(Palette256);
   End
End;
(*-------------------------*)
Procedure LoadBMP(FileName:String);
Const
   BufSize:Word=65535;
Var
   Buffer,P:Pointer;
   f:File;
   i,Result,ReadRs,NumRead,ByteLine:word;
   b,k,NumS,Mask,Bc:byte;
   j:integer;
   HorLimit,VerLimit,MaxH,MaxV,RealyByte:Word;
Begin
   Assign(f,FileName);
   {$I-}
   Reset(f,1);
   If IOResult<>0 then Exit;
   {$I+}
   BlockRead(f,BMPHdr,Sizeof(BMPHdr));
   BlockRead(f,BMPIf,Sizeof(BMPIf));
   If BMPIf.biBitCount<>8 then BlockRead(f,BMPPalette,Sizeof(BMPPalette))
   Else BlockRead(f,BMP256,Sizeof(BMP256));
   If (BMPHdr.bfType<>'BM') then begin
      Close(f);
      Write(FileName,' is not BMP file.');
      Repeat;
      Until KeyPressed;
      Exit
   End;
   Seek(f,BMPHdr.bfOffBits);
   While MaxAvail<BufSize do Dec(BufSize);
   If (BMPIf.biBitCount<>8) then begin
      BMPMode:=$12;
      MaxH:=640;
      MaxV:=480;
   End
   Else begin
      MaxH:=320;
      MaxV:=200;
      BMPMode:=$13
   End;
   SetVideo(BMPMode,GraphOn);
   InstallBMP;
   Getmem(Buffer,BufSize);
   P:=Buffer;
   NumRead:=0;
   BlockRead(f,Buffer^,BufSize,Result);
   

   If BMPIf.biWidth<=MaxH then ByteLine:=BMPIf.biWidth
   Else ByteLine:=MaxH;

   HorLimit:=ByteLine-1;
   VerLimit:=0;

   If BMPIf.biHeight<=MaxV then j:=BMPIf.biHeight-1
   Else j:=MaxV-1;
   i:=0;
   Bc:= BMPIf.biBitCount;
   NumS:=8 div Bc;
   RealyByte:=BMPIf.biWidth;
   Case Bc of
      8:Begin
          Mask:=$FF;
          While RealyByte mod 4 <> 0 do Inc(RealyByte);
        End;
      4:Begin
          Mask:=$0F;
          While RealyByte mod 8 <> 0 do Inc(RealyByte);
        End;
      1:Begin
          Mask:=1;
          While RealyByte mod 32 <> 0 do Inc(RealyByte);
        End;
   End;

   Dec(RealyByte);

   Repeat
      b:=Byte(P^);
      IncPoint(P,1);
      Inc(NumRead);
      If (NumRead=Result) then begin
         P:=Buffer;
         BlockRead(f,Buffer^,BufSize,Result);
         NumRead:=0
      End;
      If BMPIf.biCompression = 0 then begin
         For k:=1 to NumS do begin
             If i<ByteLine then
             WritePixel(i,j,(b shr (8-Bc*k)) AND Mask);
             If i<RealyByte then Inc(i)
             Else begin
                  i:=0;
                  Dec(j)
             End;
         End;
      End
   Until (j<VerLimit) OR (Port[$60]=1);
   Write(#7);
   Close(f);
   Freemem(Buffer,BufSize);
   Repeat;
   Until KeyPressed;
   SetVideo(3,GraphOff)
End;

(*-------------------------*)

END.
