Var
  I : Byte;
  F : File;
  S : String;

BEGIN
  For I := 1 To 100 Do
    Begin
      Str(I, S);
      While Length(S) < 3 Do S := '0'+S;
      Assign(F, 'tmp_file.'+S);
      Rewrite(F);
      Close(F);
    End;
END.