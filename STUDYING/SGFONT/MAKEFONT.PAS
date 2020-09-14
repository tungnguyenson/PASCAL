Uses Graph;

Const
  InputFile = 'vntimeh';
  FontName : String = 'VNI Times H';
  HGrid = 14;
  VGrid = 18;
  HChr = HGrid-2;
  VChr = VGrid-2;
  CharsPerRow = 32;

Type
  CharacterArray = Array[0..VChr-1, 0..HChr-1] Of Byte;

Var
  HBmp, VBmp : Integer;
  FontArray : Array[33..255, 0..VChr-1] Of Word;
  Width, Height, Top : Array[33..255] Of Byte;

Procedure InitGraphMode;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := VGA;
    GraphMode := VGAHi;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Procedure Show_Pic;
  Var
    F : Text;
    i, j : Integer;
    Ch : Char;
  Begin
    Assign(F, InputFile+'.dat');
    Reset(F);
    ReadLn(F, VBmp, HBmp);
    For i := 0 To VBmp-1 Do
      Begin
        For j := 0 To HBmp-1 Do
          Begin
            Read(F, Ch);
            If Ch = '1' Then PutPixel(j, i, 1)
                        Else PutPixel(j, i, 15);
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

Procedure Zoom(x, y, xn, yn, zh, zv : Integer);
  Var
    i, j : Integer;
  Begin
  End;

Procedure Rut_Gon(Var Ch : CharacterArray; Var Top, Width, Height : Byte);
  Var
    Ch0 : Array[-1..VChr, -1..HChr] Of Byte;
    i, j : Byte;
    Left, Right, Bottom : Byte;
  Begin
    Top := 0;
    Left := 0;
    Bottom := VChr-1;
    Right := HChr-1;
    FillChar(Ch0, SizeOf(Ch0), 0);
    For j := 0 To VChr-1 Do
      For i := 0 To HChr-1 Do
        Ch0[j, i] := Ch[j, i];
    i := 0;
    While (Ch0[Top, i] = 0)And(Top <= Bottom) Do
      If i < HChr-1 Then Inc(i)
        Else
          Begin
            Inc(Top);
            i := 0;
          End;
    i := 0;
    While (Ch0[Bottom, i] = 0)And(Top <= Bottom) Do
      If i < HChr-1 Then Inc(i)
        Else
          Begin
            Dec(Bottom);
            i := 0;
          End;
    i := 0;
    While (Ch0[i, Left] = 0)And(Left <= Right) Do
      If i < VChr-1 Then Inc(i)
        Else
          Begin
            Inc(Left);
            i := 0;
          End;
    i := 0;
    While (Ch0[i, Right] = 0)And(Left <= Right) Do
      If i < VChr-1 Then Inc(i)
        Else
          Begin
            Dec(Right);
            i := 0;
          End;
    FillChar(Ch, SizeOf(Ch), 0);
    If (Top > Bottom)Or(Left > Right) Then
      Begin
        Top := 0;
        Width := 0;
        Height := 0;
      End
     Else
      Begin
        Width := Right-Left+1;
        Height := Bottom-Top+1;
        For j := Top To Bottom Do
          For i := Left To Right Do
            Ch[j-Top, i-Left] := Ch0[j, i];
      End
  End;

Procedure Convert;
  Var
    i, j, k : Byte;
    x, y : Integer;
    Ch : CharacterArray;
    W : Word;
  Begin
    FillChar(FontArray, SizeOf(FontArray), 0);
    For i := 33 To 255 Do
      Begin
        y := ((i-32) Div CharsPerRow)*(VGrid-1);
        x := ((i-32) Mod CharsPerRow)*(HGrid-1);
        FillChar(Ch, SizeOf(Ch), 0);
        For k := 0 To VChr-1 Do
          For j := 0 To HChr-1 Do
            If GetPixel(x+j+1, y+k+1) <> 15 Then Ch[k, j] := 1
                                            Else Ch[k, j] := 0;
        For k := 0 To VChr-1 Do
          For j := 0 To HChr-1 Do
            If Ch[k, j] = 1 Then PutPixel(j+200, k+200, 15)
                            Else PutPixel(j+200, k+200, 0);
{        Asm
          Mov AH, 00H
          Int 16H
        End;{}
{        WriteLn(i);{}
        If i = 249 Then
          i := i;
        Rut_Gon(Ch, Top[i], Width[i], Height[i]);
        If Height[i] <> 0 Then
          For j := 0 To Height[i]-1 Do
            Begin
              W := 0;
              For k := Width[i]-1 DownTo 0 Do
                W := W+Ch[j, Width[i]-k-1] Shl k;
              FontArray[i, j] := W;
            End;
{        ReadLn;{}
      End;
  End;

Procedure Write_Result;
  Const
    BufSize = (256-33)*(VChr*2+3)+2+512;
  Var
    i, j : Byte;
    F : File;
    Buf : Array[1..BufSize] Of Byte;
    Count, InfoLeng : Word;
    StID : String;
  Begin
    StID := 'NST-';
    FillChar(Buf, SizeOf(Buf), 0);
    For i := 1 To Length(StID) Do
      Buf[i] := Ord(StID[i]);
    Count := i+1;
    Buf[Count] := Length(FontName);
    For i := 1 To Length(FontName) Do
      Buf[Count+i] := Ord(FontName[i]);
    Inc(Count, Length(FontName));
    InfoLeng := Count;
    Inc(Count, 2);
    For i := 33 To 255 Do
      Begin
        Buf[Count+1] := 2+Height[i]*2;  {Length character data}
        Buf[Count+2] := Top[i];
        Buf[Count+3] := Width[i];
        Inc(Count, 3);
        If Height[i] <> 0 Then
          For j := 0 To Height[i]-1 Do
            Begin
              Buf[Count+1] := Hi(FontArray[i, j]);
              Buf[Count+2] := Lo(FontArray[i, j]);
              Inc(Count, 2);
            End;
      End;
    Buf[InfoLeng+1] := Lo(Count-InfoLeng-2);
    Buf[InfoLeng+2] := Hi(Count-InfoLeng-2);{}
    Assign(F, InputFile+'.fon');
    Rewrite(F, 1);
    BlockWrite(F, Buf, Count);
    Close(F);
  End;

BEGIN
  InitGraphMode;
  Show_Pic;
  Convert;
  Write_Result;
  ReadLn;
  CloseGraph;
END.