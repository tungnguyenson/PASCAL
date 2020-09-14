Uses
 Crt, Drivers;
Var
 Mouse: TEvent;
 y: integer;
 Button, State: string;
BEGIN
 ClrScr;
 InitEvents;
 HideMouse;
 WriteLn;
 WriteLn('Ba^/m phi/m Enter dde^? ba^.t Mouse cursor');
 ReadLn;
 ShowMouse;
 Clrscr;
 WriteLn;
 WriteLn('Ba^/m phi/m ba^/t ky\ dde^? thoa/t');
 WriteLn('Vi. tri/ Mouse: X=');
 WriteLn('Vi. tri/ Mouse: Y=');
 WriteLn('Ti\nh tra.ng Mouse:');
 for y := 1 to 15 do writeln ;
 state := '' ;
 button := '' ;
 Repeat
  if MouseButtons = $0001 then Button := ' phi/m tra/i'
  else if MouseButtons = $0002 then Button:=' phi/m pha?i';
  GetMouseEvent(Mouse);
  Case Mouse.What of
   $0001:State:=' nha^/n';
   $0002:State:=' tha?  ';
   $0004:begin
    GotoXY(17,3);
    Write(MouseWhere.X, ' ');
    GotoXY(17,4);
    Write(MouseWhere.Y, ' ');
   end;
  end;
  GotoXY(20, 5);
  Write(State+Button);
 Until KeyPressed;
 HideMouse;
 DoneEvents;
END.
