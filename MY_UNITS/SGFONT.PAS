{
  Unit Simple Graphic Font
  (Phien ban thu nghiem)
}

Unit SGFont;

Interface

  Const
    FontPath = 'C:\TP\MY_FONTS\';
    FontHeight = 16;

  Type
    FontType = Record
      Name : String;
      Data : Array[0..(256-33)*16*2] Of Word;
      CharAddr : Array[33..255] Of Word;
      Top, Width, Height : Array[33..255] Of Byte;
    End;
    PFontType = ^FontType;
    FontStyle = (fsRegular, fsBold, fsExt);

  Var
    FontRegular, FontBold, ExtFont, CurFont : PFontType;

  Procedure LoadFont(FontFile : String; Var FontData : PFontType);
  Procedure SetFontStyle(Style : FontStyle);
  Procedure PrintChar(X, Y : Integer; Ch : Char);
  Procedure PrintStr(X, Y : Integer; St : String);
  Function StrWidth(St : String) : Integer;
  Function VNIConv(St : String) : String;
  Procedure UnloadAllFont;

Implementation

  Uses Graph;

  Procedure LoadFont;
    Var
      F : File;
      Buf : Array[1..10000] Of Byte;
      S : String;
      i, j : Byte;
      Count, Leng, k : Word;
    Begin
      Assign(F, FontPath+FontFile);
      {$I-}
      Reset(F, 1);
      If IOResult <> 0 Then
        Begin
          Assign(F, FontFile); { Search in current directory }
          Reset(F, 1);
          If IOResult <> 0 Then
            Begin
              WriteLn;
              WriteLn('Error! No font found!');
              WriteLn('Current font path is set to: ', FontPath);
              WriteLn('To correct this problem, please copy font files to this path');
              WriteLn('  or current directory!');
              WriteLn;
              Halt(1);
            End;
        End;
      BlockRead(F, Buf[1], 4);
      S := '';
      For i := 1 To 4 Do
        S := S+Chr(Buf[i]);
      If S = 'NST-' Then
        Begin
          If FontData <> Nil Then Dispose(FontData); { Release old font }
          New(FontData);
          With FontData^ Do
            Begin
              FillChar(Data, SizeOf(Data), 0);
              FillChar(CharAddr, SizeOf(CharAddr), 0);
              BlockRead(F, i, 1);  {Length FontName}
              BlockRead(F, Buf[1], i);
              Name := '';
              For j := 1 To i Do
                Name := Name+Chr(Buf[j]);
              BlockRead(F, Count, SizeOf(Count));  { Size of data }
              BlockRead(F, Buf[1], Count);
              k := 1;
              For i := 33 To 255 Do
                Begin
                  Leng := Buf[k];
                  Top[i] := Buf[k+1];
                  Width[i] := Buf[k+2];
                  Height[i] := (Leng-2) Div 2;
                  If i = 33 Then CharAddr[i] := 0
                            Else CharAddr[i] := CharAddr[i-1]+Height[i-1];
                  For j := 1 To (Leng-2) Div 2 Do
                    Data[CharAddr[i]+j-1] := Buf[k+(j-1)*2+3]*256+Buf[k+(j-1)*2+4];
                  Inc(k, Leng+1);
                End; { For }
            End; { With }
        End; { If }
      Close(F);
    End; { Proc }

  Procedure SetFontStyle;
    Begin
      Case Style Of
        fsRegular : CurFont := FontRegular;
        fsBold    : CurFont := FontBold;
        fsExt    : CurFont := ExtFont;
      End;
    End;

  Procedure PrintChar;
    Var
      Addr : Word;
      i, j, W, H, Color : Byte;
    Begin
      If Ch <> ' ' Then
        With CurFont^ Do
        Begin
          Color := GetColor;
          Addr := CharAddr[Ord(Ch)];
          W := Width[Ord(Ch)];
          H := Height[Ord(Ch)];
          y := y+Top[Ord(Ch)]-1;
          For i := 1 To H Do
            For j := W-1 DownTo 0 Do
              If Data[Addr+i-1] And (1 Shl j) <> 0 Then
                PutPixel(x+w-j-1, y+i-1, Color);
        End;
    End;

  Procedure PrintStr;
    Var
      i, Color : Byte;
    Begin
      If St <> '' Then
        Begin
          i := 1;
          Repeat
            If St[i] = ' ' Then x := x+3
             Else
              Begin
                PrintChar(x, y, St[i]);
                x := x+CurFont^.Width[Ord(St[i])]+1;
              End;
            Inc(i);
          Until i > Length(St);
        End;
    End;

  Function StrWidth;
    Var
      Width : Integer;
      i, j : Byte;
    Begin
      Width := 0;
      For i := 1 To Length(St) Do
        Begin
          If St[i] = ' ' Then j := 2
                         Else j := CurFont^.Width[Ord(St[i])];
          If i <> Length(St) Then j := j+1;
          Width := Width+j;
        End;
      StrWidth := Width;
    End;

  Function VNIConv;
    Const
      MaxVNChar = 74;
      CharCode : Array[1..MaxVNChar] Of String[3] =
                 ( 'AW', 'AA', 'EE', 'OO', 'OW', 'UW', 'DD','awf','awr',
                  'awx','aws','awj','owf','owr','owx','ows','owj','uwf',
                  'uwr','uwx','uws','uwj','aaf','aar','aax','aas','aaj',
                  'eef','eer','eex','ees','eej','oof','oor','oox','oos',
                  'ooj', 'aw', 'aa', 'ee', 'oo', 'ow', 'uw', 'dd', 'af',
                   'ar', 'ax', 'as', 'aj', 'ef', 'er', 'ex', 'es', 'ej',
                   'if', 'ir', 'ix', 'is', 'ij', 'of', 'or', 'ox', 'os',
                   'oj', 'uf', 'ur', 'ux', 'us', 'uj', 'yf', 'yr', 'yx',
                   'ys', 'yj');
      CharEncode : Array[1..MaxVNChar] Of Byte =
                   (161, 162, 163, 164, 165, 166, 167, 187, 188,
                    189, 190, 198, 234, 235, 236, 237, 238, 245,
                    246, 247, 248, 249, 199, 200, 201, 202, 203,
                    210, 211, 212, 213, 214, 229, 230, 231, 232,
                    233, 168, 169, 170, 171, 172, 173, 174, 181,
                    182, 183, 184, 185, 204, 206, 207, 208, 209,
                    215, 216, 220, 221, 222, 223, 225, 226, 227,
                    228, 239, 241, 242, 243, 244, 250, 251, 252,
                    253, 254);
    Var
      i, j : Byte;
    Begin
      For i := 1 To MaxVNChar Do
        While Pos(CharCode[i], St) <> 0 Do
          Begin
            j := Pos(CharCode[i], St);
            Delete(St, j, Length(CharCode[i]));
            Insert(Chr(CharEncode[i]), St, j)
          End;
      VNIConv := St;
    End;

  Procedure UnloadAllFont;
    Begin
      Dispose(FontRegular);
      Dispose(FontBold);
      If ExtFont <> Nil Then Dispose(ExtFont);
      Dispose(CurFont);
    End;

BEGIN
  FontRegular := Nil;
  FontBold := Nil;
  LoadFont('sans.fon', FontRegular);
  LoadFont('sansbold.fon', FontBold);{}
  SetFontStyle(fsRegular);
END.
