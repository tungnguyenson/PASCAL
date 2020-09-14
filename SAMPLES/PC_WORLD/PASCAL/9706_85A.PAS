{Listing 2: Pascal }
Uses crt,dos; 
{$L VGA256}
Procedure Init256; external; 
Type 
Dsp=Array[1..64000] of byte; 
Var 
a, b, i, j, k, x, y, z, n, m, cg, drive, mode, testdrive: integer; 
color:array[0..15, 0..2] of byte; 
colortp:array[0..15, 0..3] of byte; 
screen:array[0..31999] of byte; 
r:registers; 
name:string; 
f:file; 
begin 
clrscr; 
writeln ('Chuong trinh xem anh tro choi Tam Quoc Chi...Copyright(c) 1995 by Le Anh Duc'); 
writeln; 
writeln('00: Linh'); 
writeln('01: Quan Vu'); 
writeln('02: Truong Phi'); 
writeln('03: Trieu Van'); 
wtiteln('04: Ma Sieu'); 
writeln('05: Hoang Trung'); 
writeln('06: Tu Hoang'); 
writeln('07: Ha Hau Uyen'); 
writeln('08: Quan Don'); 
writeln('09: Hua Chu'); 
writeln('10: Dien Vi'); 
writeln('11: La Bo'); 
writeln('12: Tao Thao'); 
writeln; 
writeln(‘Nhap lua chon cua ban: (0..12)'); readln(k); 
case k of 
00:Begin name:='ll'; cg:=00; end; 
01:Begin name:='aa'; cg:=60; end; 
02:Begin name:='bb'; cg:=58; end; 
03:Begin name:='cc'; cg:=60; end; 
04:Begin name:='dd'; cg:=59; end; 
05:Begin name:='ww'; cg:=66; end; 
06:Begin name:='ee'; cg:=53; end; 
07:Begin name:='ff'; cg:=55; end; 
08:Begin name:='gg'; cg:=57; end; 
09:Begin name:='hh'; cg:=49; end; 
10:Begin name:='ii'; cg:=47; end; 
11:Begin name:='jj'; cg:=57; end; 
12:Begin name:='kk'; cg:=54; end; 
end; 
init256; 
assign(f,'Thu muc chua cac file .SPR'+name+'.spr'); 
rest(f,1); 
blockread(f,color,48); 
blockread(f,colortp,48); 
color[0,0]:=63; 
color[0,1]:=63; 
color[0,2]:=63; 
colortp[0,0]:=63; 
colortp[0,1]:=63; 
colortp[0,2]:=63; 
r.ah:=$10; 
r.al:=$12; 
r.es:=seg(color); 
r.dx:=ofs(color); 
r.bx:=0; 
r.cx:=16; 
intr($10,r); 
seek(f,$1f0); 
z:=0; 
repeat 
fillchar(mem[$A000:0],64000,0); 
z:=z+1; 
if z=cg then 
Begin 
r.ah:=$10; 
r.al:=$12; 
r.es:=seg(colortp); 
r.dx:=ofs(colortp); 
r.bx:=0; 
r.cx:=16; 
intr($10,r); 
end; 
blockread(f,y,1); 
blockread(f,x,); 
y:=y+1; 
blockread(f,screen,x*(y div 2)); 
a:=100-x; 
b:=160-y; 
for i:=0 to x-1 do 
for j:=0 to (y div 2)-1 do 
begin 
k:=screen[i*(y div 2)+j]; 
for m:=0 to 1 do 
for n:=0 to 1 do 
begin 
mem[$A000: (a+i*2+m) *320+(j*2) *2+n+b]:= k shr 4; 
mem[$A000: (a+i*2+m) *320+(j*2+1) *2+n+b]:=k and 15; 
end; 
end; 
if readkey=#0 then readkey; 
until eof(f); 
close(f); 
textmode(co80); 
end. 
