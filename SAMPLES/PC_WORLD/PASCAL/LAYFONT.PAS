program layfont; 
var 
 f:text; 
 mang:array[1..1330] of Byte;
 i,j:integer;
 st:String[3];
begin
ASM
 push es
 push ds
 mov ax,1130h { ah=11h bo phat sinh ky tu
                al=30h lay thong tin ve man hinh}
 mov bh,2     { bh=2   tra ve es:bp dia chi rom cua font chu 8x14}
 int 10h
 mov si,bp 
 add si,462   { bo 33=(462/14) ky tu dau tien}
 mov di,OFFSET MANG
 push ds
 push es
 pop ds
 pop es
 mov cx,1330  {1330=14*95 chuyen vao mang 95 ky tu}
 cld
 rep movsb
 pop ds
 pop es
END;
assign(f,'font.byt');
rewrite(f);
write(f,'0,0,');
for i:=1 to 95 do
begin
 for j:=1 to 14 do
 begin
  str(mang[((i-1)*14)+j],st);
  write(f,st,',');
 end;
 writeln(f); 
 write(f,'0,0,'); 
end; 
close(f); 
end. 

ÿ