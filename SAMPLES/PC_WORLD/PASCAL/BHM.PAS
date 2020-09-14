PROGRAM MUSIC_OF_BICH_HANH;
{$m 15000,0,0}
Uses crt,dos;
Var f:file;
buf:array[1..15000] of word;
x,y,nhip,dem:word;i,j:integer;
old:procedure;
buf1:array[1..80] of byte;
st:string;

{$f+}
procedure intvec1c; interrupt;
Begin
if (nhip=0) or (dem=0) then
begin
dem:=dem+1;
if dem*2<=i then
begin
sound(buf[dem*2-1]);
nhip:=1;
end
else
begin
dem:=0;
nhip:=0;
end;
end
else
nhip:=nhip+1;
if (nhip>=round(buf[dem*2]/80)) or (dem=0) then
begin
nosound;
nhip:=0;
end;
inline($9c);
old;
end;
{$f-}

procedure readinfo(len:integer);
begin
seek(f,filepos(f)+2);
blockread(f,buf1,len);
st:=' ';
for j:=1 to len do
st:=st+chr(buf1[j]);
writeln(st);
end;

procedure readf;
Begin
{$i-}
assign(f,paramstr(1));reset(f,1);
if ioresult<>0 then
begin
writeln('Error: Can"t read the file: ',paramstr(1));
writeln;
halt(1);
end;
{$i+}
blockread(f,buf1,5);
st:=' ';
for j:=1 to 5 do
st:=st+chr(buf1[j]);
if st<>'BHM10' then
begin
writeln('Error:  ',paramstr(1),'is not a valid BHM file.');
writeln;
close(f);
halt(1);
end;
writeln('The file: ',paramstr(1));
writeln('—————————————');
readinfo(42);
readinfo(69);
readinfo(16);
readinfo(60);
seek(f,filepos(f)+2);
blockread(f,dem,sizeof(dem),i);
if dem>7500 then
begin
writeln('Error: The file: ',paramstr(1),' is too big.');
writeln;
halt(1);
end;
writeln('—————————————');
blockread(f,buf,sizeof(buf),i);
close(f);
dem:=0;
nhip:=0;
End;

Begin
writeln;
writeln('The BHM - Bich Hanh Music.  Version 1.0A   *   07-30-1996, 3:00p');
writeln('Copyright (c) 1996 - 1997 by Technology And Development Software Group');
writeln('Designed by:  SP. Truong Anh Duc,   Tel:  (04) 8.311441');
writeln;
if (pos('.',paramstr(1))=0) or (pos('?',paramstr(1))<>0) or (pos('.bhm',paramstr(1))=0) then
begin
writeln('Command line: BHM <filename>.bhm');
writeln;
writeln('Thanks for using this program. Give copies to your friends. Good Bye!');
halt(1);
end;
readf;
getintvec($1c,@old);
setintvec($1c,@intvec1c);
writeln('Thanks for using this program. Give copies to your friends. Good Bye!');
keep(0);
End.
