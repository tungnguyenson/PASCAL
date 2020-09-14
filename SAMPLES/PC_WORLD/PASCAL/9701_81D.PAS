Uses crt;
Begin
 {Cbcscr.}
 clrscr;
 Writeln ('Nhan mot phim bat ky de kiem tra');
 Repeat
  Gotoxy (1,3);
  Case Port [$60] of
   91: Write ('Phim Taskbar 1 duoc nhan');
   92: Write ('Phim Taskbar 2 duoc nhan');
   93: Writeln ('Phim co hinh con tro chuot duoc nhan')
  End;
  Write (#32:36);
 Until KeyPressed;
End. 


