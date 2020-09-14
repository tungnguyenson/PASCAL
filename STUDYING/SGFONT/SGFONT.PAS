{
  Unit Simple Graphic Font
  (Phien ban thu nghiem)
}

Unit SGFont;

Interface

  Type
    FontDataType = Array[0..(256-33)*16*2] Of Word;

  Var
    CharAddr : Array[33..255] Of Word;
    FontTop, FontWidth, FontHeight : Array[33..255] Of Byte;
    FontData : ^FontDataType;
    FontName : String;

  Procedure LoadFont(FontFile : String);
  Procedure PrintChar(X, Y : Integer; Ch : Char);
  Procedure PrintStr(X, Y : Integer; St : String);
  Function VNIConv(St : String) : String;

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
      Assign(F, FontFile);
      Reset(F, 1);
      BlockRead(F, Buf[1], 4);
      S := '';
      For i := 1 To 4 Do
        S := S+Chr(Buf[i]);
      If S = 'NST-' Then
        Begin
          BlockRead(F, i, 1);  {Length FontName}
          BlockRead(F, Buf[1], i);
          FontName := '';
          For j := 1 To i Do
            FontName := FontName+Chr(Buf[j]);
          BlockRead(F, Count, SizeOf(Count));  { Size of data }
          BlockRead(F, Buf[1], Count);
          New(FontData);
          FillChar(FontData^, SizeOf(FontData^), 0);
          FillChar(CharAddr, SizeOf(CharAddr), 0);
          k := 1;
          For i := 33 To 255 Do
            Begin
              Leng := Buf[k];
              FontTop[i] := Buf[k+1];
              FontWidth[i] := Buf[k+2];
              FontHeight[i] := (Leng-2) Div 2;
              If i = 33 Then CharAddr[i] := 0
                        Else CharAddr[i] := CharAddr[i-1]+FontHeight[i-1];
              For j := 1 To (Leng-2) Div 2 Do
                FontData^[CharAddr[i]+j-1] := Buf[k+(j-1)*2+3]*256+Buf[k+(j-1)*2+4];
              Inc(k, Leng+1);
            End;
        End;
      Close(F);
    End;

  Procedure PrintChar;
    Var
      Addr : Word;
      i, j, W, H, Color : Byte;
    Begin
      If Ch <> ' ' Then
        Begin
          Color := GetColor;
          Addr := CharAddr[Ord(Ch)];
          W := FontWidth[Ord(Ch)];
          H := FontHeight[Ord(Ch)];
          y := y+FontTop[Ord(Ch)]-1;
          For i := 1 To H Do
            For j := W-1 DownTo 0 Do
              If FontData^[Addr+i-1] And (1 Shl j) <> 0 Then
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
                x := x+FontWidth[Ord(St[i])]+1;
              End;
            Inc(i);
          Until i > Length(St);
        End;
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

End.