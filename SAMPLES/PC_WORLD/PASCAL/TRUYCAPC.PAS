Program Truy_cap_CMOS;
uses crt;
var
 buffer:array[$0e..$7f] of byte;
 f:file; i:integer;

Procedure ghicm;
var
 filename:string;
begin
 for i:=$0e to $7f do
 begin
  port[$70]:=i;
  buffer[i]:=port[$71];
 end;
 write('Ban muon ghi vao file nao ?: ');
 readln(filename);
 if filename <> '' then
 begin
  assign(f,filename);
{SI-}
  rewrite(f,1);
{SI+}
  if IOresult<>0 then
  begin
   write('Loi vao ra dia.');
   exit;
  end;
  blockwrite(f,buffer,sizeof(buffer),i);
  close(f);
  write('OK ! ');
 end;
end;

Procedure tllcm;
var
 filename:string;
begin
 write('Ban muon thiet lap lai CMOS trong file nao?: ');
 readln(filename);
 if filename <> '' then
 begin
  assign(f,filename);
{SI-}
  reset(f,1);
{SI+}
  if IOresult <> 0 then
  begin
   write('Loi vao ra dia.');
   exit;
  end;
  blockread(f,buffer,sizeof(buffer),i);
  close(f);
  for i:=$0e to $7f do
  begin
   port[$70]:=i;
   port[$71]:=buffer[i];
  end;
  write('OK ! ');
 end;
end;

Procedure help;
begin
 writeln('TRUYCAPC [/S] or [/W].');
 writeln('[/S] de thiet lap lai CMOS.');
 writeln('[/W] de ghi lai CMOS.');
end;

BEGIN
 clrscr;
 writeln('Chuong trinh truy cap CMOS. Copyright(C) Nguyen Manh Cuong 1996.');
 writeln;
 if paramcount=0 then help
 else
  if (paramstr(1)= '/S') or (paramstr(1)= '/s')
  then tllcm
  else
   if (paramstr(1)='/W') or (paramstr(1)='/w')
   then ghicm
   else
    help;
End.
