Uses graph,crt,dos; 
type dsp = array[1..64000] of byte; 
var a,b,i,j,k,x,y,z,n,m,cg,Driver,Mode,TestDriver:integer; 
color :array[0..15,0..2] of byte; 
colortp :array[0..15,0..3] of byte; 
screen :array[0..31999] of byte; 
r:registers; name:string; f:file; 
{$F+} 

Function TestDetect: Integer; 
Begin 
TestDectect:=0; 
End; 
{$F-} 
begin clrscr; 
writeln('Chuong trinh xem anh tro choi Tam Quoc Chi ..Copyright (c) 1995 by Le Anh Duc'); 
writeln; 
writeln(' 00: Linh'); 
writeln(' 01: Quan Vu'); 
writeln(' 02: Truong Phi'); 
writeln(' 03: Trieu Van'); 
writeln(' 04: Ma Sieu'); 
writeln(' 05: Hoang Trung'); 
writeln(' 06: Tu Hoang'); 
writeln(' 07: Ha Hau Uyen'); 
writeln(' 08: Ha Hau Don'); 
writeln(' 09: Hua Chu'); 
writeln(' 10: Dien Vi'); 
writeln(' 11: La Bo'); 
writeln(' 12: Tao Thao');writeln; 
write(' Nhap lua chon cua ban: (00..12) :');readln(k); 
case k of 
00:begin name:='ll'; cg:=00; end; 
01:begin name:='aa'; cg:=60; end; 
02:begin name:='bb'; cg:=58; end; 
03:begin name:='cc'; cg:=60; end; 
04:begin name:='dd'; cg:=59; end; 
05:begin name:='ww'; cg:=66; end; 
06:begin name:='ee'; cg:=53; end; 
07:begin name:='ff'; cg:=55; end; 
08:begin name:='gg'; cg:=57; end; 
09:begin name:='hh'; cg:=49; end; 
10:begin name:='ii'; cg:=47; end; 
11:begin name:='jj'; cg:=57; end; 
12:begin name:='kk'; cg:=54; end; 
end; 
TestDriver :=InstallUserDriver ('Svga256', @TestDetect); 
Driver := 0;Mode := 0; 
InitGraph(Driver,Mode,'Duong dan cac file do hoa 256 mau '); 
assign(f,' Thu muc chua cac file SPR'+name+'.spr'); 
reset(f,1); 
blockread(f,color,48); 
blockread(f,colortp,48); 
color[0,0]:=63; 
color[0,1]:=63; 
color[0,2]:=63; 
colortp[0,0]:=63; 
colortp[0,1]:=63; 
colortp[0,2]:=63; 
r.Ah :=$10; r.Al :=$12; 
r.es :=seg(color); r.dx :=ofs(color); 
r.bx :=0; r.cx :=16; 
intr($10,r); seek(f,$1f0); 
z:=0; 
repeat 
fillchar(mem[$A000:0],64000,0); 
z:=z+1; 
if z=cg then 
begin 
r.Ah :=$10; r.Al :=$12; 
r.es :=seg(colortp); r.dx :=ofs(colortp); 
r.bx :=0; r.cx :=16; 
intr($10,r); 
end; 
blockread(f,y,1); blockread(f,x,1); 
y:=y+1; 
blockread(f,screen,x*(y div 2)); 
a:=100-x; 
b:=160-y; 
for i:=0 to x-1 do 
for j:=0 to (y div 2) - 1 do 
begin 
k:=screen[i*(y div 2)+j]; 
for m:=0 to 1 do 
for n:=0 to 1 do 
begin 
mem[$A000:(a+i*2+m)*320+(j*2)*2+n+b]:=k shr 4; 
mem[$A000:(a+i*2+m)*320+(j*2+1)*2+n+b]:=k and 15; 
end; 
end; 
if readkey=#0 then readkey; 
until eof(f); 
close(f); 
CloseGraph; 
End. 
