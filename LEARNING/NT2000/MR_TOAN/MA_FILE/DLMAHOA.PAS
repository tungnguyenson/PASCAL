Uses crt;
Const
  Bangcs='INDEX.TXT';
  Bangma='CODE.DAT';
Var
  F:Text;
  Ch:Char;
  i,j:Byte;
  B:Array[1..26]Of Boolean;
Begin
  Clrscr;
  Randomize;
  Assign(F,Bangcs);
  Rewrite(F);
  Fillchar(B,sizeof(B),True);
  For i:=1 to 26 do
    Begin
      Repeat j:=random(26)+1;
      Until B[j];
      B[j]:=False;
      Write(F,j,' ');
    End;
  Close(F);
  Assign(F,BangMa);
  Rewrite(F);
  Fillchar(B,sizeof(B),True);
  For i:=1 to 26 do
    Begin
      Repeat j:=random(26)+1;
      Until B[j];
      B[j]:=False;
      Write(F,chr(j+64),' ');
    End;
  Close(F);
End.