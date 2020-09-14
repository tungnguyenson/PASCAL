Unit Utils;

Interface

  Function Hexa(D : Word) : String;

  Function Binary(D : Word) : String;

  Function StrConv(i : Integer) : String;

  Function StrAlignCenter(Left, Right : Integer; St : String) : Integer;

Implementation

  Function Hexa;
    Var
      i : Word;
      S : String;
    Begin
      S := '';
      Repeat
        i := D Mod $10;
        D := (D-i) Div $10;
        Case i Of
          0..9 : S := Chr(i+48)+S;
          10..15 : S := Chr(i+55)+S;
        End;
      Until D <= 0;
      Hexa := S;
    End;

  Function Binary;
    Var
      i : Byte;
      S : String;
    Begin
      S := '';
      For i := 0 To 15 Do
        If D And (1 Shl i) <> 0 Then S := '1'+S
                                Else S := '0'+S;
      Binary := S;
    End;

  Function StrConv;
    Var
      S : String;
    Begin
      Str(i, S);
      StrConv := S;
    End;

  Function StrAlignCenter;
    Begin
      StrAlignCenter := Left+Round(((Right-Left+1)-Length(St))/2);
    End;

END.