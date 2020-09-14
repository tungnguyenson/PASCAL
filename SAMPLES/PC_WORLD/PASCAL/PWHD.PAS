
Program PWHD;

Uses dos;

Var

r:registers;

buf,buf1:array[1..512] of byte;

f:file;i:integer;

procedure setpw;

begin

write('Reading Master Boot...');

r.ax:=$0201;

r.dx:=$0080;

r.cx:=$0001;

r.bx:=ofs(buf);

r.es:=seg(buf)

intr($13,r);

writeln('OK!');

assign(f,'password.bin');

reset(f,l);

blockread(f,bufl,sizeof(bufl),i;

close(f);

for i:=400 to 512 do

bufl[i]:=buf[i];

write('Set password ...');

r.ax:=$0301;

r.dx:=$0080;

r.cx:=$0001;

r.bx:=ofs(bufl);

r.es:=seg(buf1);

intr($13,r);

write1n('OK! ');

write('Save Master Boot ...');

r.ax:=$0301;

r.dx:=$0080;

r.cx:=$0003;

r.bx:=ofs(buf);

r.es:=seg(buf);

intr($13,r);

writeln('OK!');

end;

procedure clearpw;

begin

write('Reading Master Boot...');

r.ax:=$0201;

r.dx:=$0080;

r.cx:=$0003;

r.bx:=ofs(buf);

r.es:=seg(buf);

intr($13,r);

writeln('OK!');

write('Clear password ...');

r.ax:=$0301;

r.dx:=$0080;

r.cx:=$0001;

r.bx:=ofs(buf);

r.es:=seg(buf);

intr($13,r);

writeln('OK!');

end;

BEGIN

write1n("The Password hard disk * ver 1.0A 01-20-96');

write1n('(C) Copyright 1996, TAD Software Group.');

write1n('Written by: Truong Anh Duc.');

write1n('Address: 3,C4c Thanh Cong, Ha Noi.');

write1n;

if (paramstr(1)='/S") or (paramstr(1)='/s') then setpw else

if (paramstr(1)='/C") or (paramstr(1)='/c') then clearpw;

END.