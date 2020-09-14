Uses Crt, Dos; 
Const
 kbPause: Array [0..5] of Byte = ($e1, $1d, $45, $e1, $9d, $c5);
 kbCtrlBrk: Array [0..3] of Byte = ($e1, $46, $e0, $c6);
 kbEsc : Byte = 1;
Var
 v, i: Byte;

Procedure PausePressed;
Begin
Writeln ('Da an nut PAUSE!!!');
End;

Begin 
ClrScr; 
Writeln ('Chuong trinh nhan phim PAUSE. An ESC de thoat');
Repeat
 v := Port [$60];
 {writeln(v);}
 If v = kbPause[0] then
 Begin
  i := 1;
  Repeat
   v := Port [$60];
   i := i+1;
   {writeln(v);}
  Until (i=5) and (v=kbPause [i]);
  If (i=5) then
  Begin
   Port [$60] := $f6;
   PausePressed;
  End;
 End;
Until v=kbEsc
End.

ÿ