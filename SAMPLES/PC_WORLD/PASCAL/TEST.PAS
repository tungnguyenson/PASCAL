{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}
Program TESTXMS;
uses dos,crt;
{$I XMS.INC}
var
 handle,index:integer;
 i,j:integer;
 a,b:word;
 p:pointer;
begin
if not xmsinit then halt;
p:=@mem[$b800:0]; {p tro den vung nho man hinh van ban}
clrscr;
writeln('XMS Test     Written 1995 by Vuong Quang Khai');
writeln;
{Lay thong tin ve bo nho mo rong}
xmsqueryfree(a,b);
writeln('XMS Avaible: ',a,' KB');
writeln('XMS HMA Access: ', xmsqueryver(i,j));
writeln('XMS Version Number : ', i div 100, '.', i mod 10);
writeln;
readkey;
{Xin cap phat 4KB bo nho mo rong}
handle:=xmsgetmem(4);
{Chep bo nho man hinh vao khoi nho múo rong vua cap phat}
xmscopy(0, longint(p), handle, 0, 2000);
clrscr;
for index:=1 to 24 do
 writeln('XMS Test    Written 1995 by Vuong Quang Khai');
readkey;
{Ghi de lai man hinh bang du lieu  trong khoi nho mo rong vua cap phat}
xmscopy(handle, 0, 0, longint(p), 2000);
{Giai phong khoi nho mo rong}
xmsfreemem(handle);
readkey;
end.
