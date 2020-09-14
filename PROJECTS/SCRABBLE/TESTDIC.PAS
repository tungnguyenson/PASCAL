Uses Dic, Keyboard;

Var
  Dictionary : PDictionary;
  I : Integer;
  C : Char;

BEGIN
  SetKeyboardSpeed(0,0);
  New(Dictionary);
  With Dictionary^ Do
    Begin
      Write('Loading word list...');
      LoadDictionary('words.dat');
      WriteLn('Completed');
      WriteLn('Total words loaded : ', WordCount);
      WriteLn('Word offset:');
      For C := 'A' To 'Z' Do
        Write(' ', C, ' : ', WordOffset[C]:5);
      ReadLn;
    End;
  Dispose(Dictionary);
END.