{
Const
Font: array [0..255, 0..15] of byte =
}

Procedure Khai_bao (fontname, textname: string); 
Var 
 font: array [0..255, 0..15] of byte;
 f: file;
 g: text;
 i, j: byte;
Begin
assign (f,fontname);
reset (f,1);
blockread (f,font,4096);
close(f);
assign (g,textname);
rewrite(g);
writeln (g,'Const font: array [0..255, 0..15] of byte =');
write (g,'(');
For i:= 0 to 254 do
Begin
 write (g,'(');
 For j:=0 to 14 do
  write (g,font[i,j],',');
 writeln (g,font[i,15],'),');
End;
write (g,'(');
For j:=0 to 14 do
 write (g,font[255,j],',');
writeln (g,font[255,15],'));');
close(g);
End;
ÿ