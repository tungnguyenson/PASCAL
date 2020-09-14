{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT, Graph32;

Var
  i : Byte;
  S : String;

BEGIN
  ClrScr;
  If GetVESAInfor Then
    With VESAInfor Do
      Begin
        WriteLn('VESA Information');
        S := '';
        For i := 1 To 4 Do
          S := S+Signature[i];
        WriteLn('  Signature: ', S);
        WriteLn('  Version: ', Hi(Version), '.', Lo(Version));
        S := '';
        i := 0;
        While (i <= 255)And(OEMStringPtr^[i] <> #0) Do
          Begin
            S := S+OEMStringPtr^[i];
            Inc(i);
          End;
        WriteLn('  OEM: ', S);
      End
    Else WriteLn('False in reading information!');
  ReadLn;
END.