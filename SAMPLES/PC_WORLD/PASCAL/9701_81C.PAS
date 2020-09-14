{Thu nghiem 2}

Uses crt; 

Begin 
 {cbcscr;}
 clrscr;
 Writeln ('Nhan Ctrl - Break de ket thuc');
 Repeat
  Gotoxy (1,2);
  Write ( port[$60]: 4);
 Until False;
End.


