Uses CRT;

Const
  PicFile = 'solitare.pic';
  PalFile = 'solitare.pal';
  DatFile = 'solitare.dat';

Var
  FPal, FPic : Text;
  FDat : File;
  Height, Width, MaxColor : Integer;
  i, j : Integer;
  k : Byte;

BEGIN
  Assign(FPic, PicFile);  Reset(FPic);
  Assign(FPal, PalFile);  Reset(FPal);
  Assign(FDat, DatFile);  Rewrite(FDat, 1);
  Read(FPic, Height, Width);
  Read(FPal, MaxColor);
  BlockWrite(FDat, Height, SizeOf(Height));
  BlockWrite(FDat, Width, SizeOf(Width));
  BlockWrite(FDat, MaxColor, SizeOf(MaxColor));
  For i := 1 To MaxColor Do
    Begin
      Read(FPal, k);
      BlockWrite(FDat, k, SizeOf(k));
    End;
  For i := 1 To Height Do
    For j := 1 To Width Do
      Begin
        Read(FPic, k);
        BlockWrite(FDat, k, SizeOf(k));
      End;
  Close(FPal);
  Close(FPic);
  Close(FDat);
END.