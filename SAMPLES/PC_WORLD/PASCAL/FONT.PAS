
unit font; 
interface 
const
 fontbyte: array [1..4096] of byte = ( dat tap tin 'font16.Byt' o day va thay cac dong can thiet);
procedure cai_font;
procedure xoa_font;
implementation

procedure cai_font;
begin
ASM
 mov ax, 1100h
 lea bp,fontbyte
 mov cx,255
 xor dx,dx
 mov bx, 1000h
 int 10h
end;
end;

procedure xoa_font; 
begin 
ASM 
 mov ax,1114h
 mov bl,0
 int 10h
end;
end;

begin
end.

ÿ