PROGRAM LINK_FILE;
Uses dos;
Var
 f,f1:file;
 sof:byte;
 fs,fsc:longint;
 buf:array[1..20000] of byte;
 i:integer;
 name,extname:string;
 kt:boolean;
 name1:string;

Function upst(st:string):string;
Var
 i:byte;
Begin
for i:=1 to length(st) do
 st[i]:=upcase(st[i]);
upst:=st;
End;

BEGIN
writeln('The LINKF * Copyright (c) 1996 by TAD Software Group, All Rights Reseverd');
writeln('Designed by: Truong Anh Duc');
writeln('Address: 3, C4c Thanh Cong, Ba Dinh, Ha Noi');
writeln('Telex  : (04) 8.311441');
writeln;
writeln('Mot dau cham ( . ) ung voi 20000 byte da duoc sao chep');
writeln;
sof:=0;
name:=upst(paramstr(1));
name1:=upst(paramstr(2));
extname:= ' ';
fs:=0;
fsc:=0;
write('Hay cho dia chua tep ',name,'.000 vao o dia',name[1],': ... ');
readln;
writeln;
assign(f,name+'.000');
reset(f,1);
blockread(f,fs,4);
close(f);
if diskfree(ord(name1[1])-64)<fs then
begin
 writeln('Dia khong du cho trong de tao tep dich.');
 halt(1);
end;
assign(f1,name1);rewrite(f1,1);
repeat
 str(sof,extname);
 for i:=length(extname)+1 to 3 do
  extname:='0'+extname;
{$i-}
 assign(f,name+'.'+extname);reset(f,1);
 if IOresult<>0 then
 repeat
  writeln('Dia dang doc khong chua tep ',name+'.'+extname);
  write('Hay cho dia khac va bam Enter ... ');readln;
  assign(f,name+'.'+extname);reset(f,1);
  kt:=true;
  if IOresult<>0 then kt:=false;
 until kt;
{$i+}
 if sof=0 then
  seek(f,4);
 while not eof(f) do
 begin
  blockread(f,buf,sizeof(buf),i);
  if i>0 then
  begin
   blockwrite(f1,buf,i);
   write('.');
  end;
 end;
 if sof=0 then fsc:=filesize(f)-4
 else fsc:=fsc+filesize(f);
 close(f);
 if fsc<fs then
 begin
  writeln;
  write('Hay cho dia tiep theo va bam Enter de tiep tuc ... ');readln;
  writeln;
  sof:=sof+1;
 end;
until fsc=fs;
close(f1);
writeln;
writeln('Da noi ket xong ‘,sof+1,’ tep con ');
writeln('Tao thanh tep dich:'+paramstr(2));
END.