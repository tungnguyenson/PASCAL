Uses CRT;

Const
  TenTepDL = 'BL7.INP';
  TenTepKQ = 'BL7.OUT';

Var
  S : String;

Function Tim_So_Lan_Trung(Xau : String; i, Leng : Byte) : Byte;
  Var
    j, k : Byte;
  Begin
    j := 0;
    k := i;
    Repeat
      Inc(j);
      Inc(k, Leng);
    Until Copy(Xau, i, Leng) <> Copy(Xau, k, Leng);
    Tim_So_Lan_Trung := j;
  End;

Procedure Thu_Gon(Var Xau : String);
  Var
    i, j, Leng : Byte;
    S : String;
  Begin
    Leng := Length(Xau) Div 2;
    Repeat
      i := 0;
      j := 1;
      While i < Length(Xau)-Leng*2+1 Do
        Begin
          Inc(i);
          While (Xau[i] In ['(', ')', '0'..'9'])And(i < Length(Xau)) Do Inc(i);
          If i < Length(Xau) Then
            Begin
              j := Tim_So_Lan_Trung(Xau, i, Leng);
              If j > 1 Then
                Begin
                  Str(j, S);
                  If Leng > 1 Then S := '('+Copy(Xau, i, Leng)+')'+S
                              Else S := Copy(Xau, i, Leng)+S;
                  Delete(Xau, i, Leng*j);
                  Insert(S, Xau, i);
                  i := i+Length(S)-1;
                End;
            End;
        End;
      Dec(Leng);
    Until Leng = 0;
    i := 0;
    While i < Length(Xau)-1 Do
      Begin
        Inc(i);
        If Not (Xau[i] In ['(', ')', '0'..'9']) Then
          If Not (Xau[i+1] In ['(', ')', '0'..'9']) Then
            Insert('1', Xau, i+1);
      End;
  End;

BEGIN
  ClrScr;
  S := 'XCAABAABAABCCADADCAABAABAABCCADADY';
  Thu_Gon(S);
  WriteLn(S);
END.