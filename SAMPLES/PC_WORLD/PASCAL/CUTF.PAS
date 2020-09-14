Program CUT_File;
{Chuong trinh chay nhung chua dung
BBT PCW}

Uses dos;

Var

 f,f1:file;
 name,name1,
 extname,drive:string;
 df,fs:longint;
 sof:byte;
 i:integer;
 buf:array[1..20000] of byte;

BEGIN
writeln('CUTF * Copyright (c) 1996, TAD Software Group.');
writeln('Written by: Truong Anh Duc.');
writeln('Address: 3, C4c Thanh Cong, Ba Dinh, Ha Noi.');
writeln;
writeln('Mot dau Cham (.) ung voi 20000 byte da duoc sao chep');
name := paramstr (1);
drive := paramstr (2);

sof:=0;
if pos('.',name) > 0 then
 name1:=copy(name,1,pos('.',name))
 {tach ext ra khoi pathfilename }
else
 name1:=name;
if pos('\',name1) > 0 then
 repeat
  delete(name1,1, pos('\',name1));
  {tach path ra khoi filename}
 until pos('\',name1) = 0 ;

assign(f,name);
reset(f,1);

write(' Hay cho dia moi roi an Enter de tiep tuc...');
readln;
writeln;
repeat
 str(sof,extname);
 {tao ext cho file moi}
 for i:=length(extname)+1 to 3 do
  extname:='0'+ extname;

 assign(f1,drive[1]+':\'+name1 + extname);
 rewrite(f1,1);

 if sof=0 then
 begin
  fs:=filesize(f);
  {writeln(fs);
  readln;}
  blockwrite(f1,fs,sizeof(fs));
 end;
 df:=diskfree(ord(upcase(drive[1]))-64);
 if df<20000 then
 begin
  blockread(f,buf,df);
  i:=df;
 end
 else blockread(f,buf,sizeof(buf),i);
 while (i>0) and (df>0) do
 begin
  blockwrite(f1,buf,i);
  write('.');
  df:=diskfree(ord(upcase(drive[1]))-64);
  if df>0 then
  begin
   if df<20000 then
   begin
    blockread(f,buf,df);
    i:=df;
   end
   else blockread(f,buf,sizeof(buf),i);
  end;
 end; {while}
 close(f1);
 writeln;
 if not eof(f) then
 begin
  write(' Hay cho dia moi va bam Enter de tiep tuc...');
  readln;
  writeln;
  sof:=sof+1;
 end;
until eof(f);
close(f);
writeln('Da cat xong file:',name);
writeln('Tong cong chia ra:',sof+1,'file.');
END.
