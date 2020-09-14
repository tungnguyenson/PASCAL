uses crt,dos;
var
 i,k,
 maxside,o_dia,kieu_o_dia, maxsector:byte;
 j,
 maxtrack,count,tr,tong:word;
 r:registers;
 dl:longint;
 ch:char;

procedure Lay_tham_so_o_dia (o_dia: byte);
begin
if o_dia<>$ff then
begin
 tr:=0;
 r.ah:=$8;
 r.dl:=o_dia;
 intr($13,r);
 if r.ah=0 then
 begin
  maxside:=r.dh;
  kieu_o_dia:=r.bl;
  maxsector:=(r.cl and $3f);
  tr:=r.cl and $c0;
  tr:=tr shl 2;
  maxtrack:=tr + r.ch;
 end
 else
 begin
  write('O dia loi.');
  halt;
 end;
end
else
begin
 write('Ten o dia khong hop le.');
 halt;
end;
end;{of proc}

procedure Kiem_tra_sector (O_dia, side:byte;
        track:word; so_hieu_sector, so_doc:byte);
begin
r.ah:=$4;
r.al:=so_doc;
r.dl:=O_dia;
r.dh:=side;
r.ch:=lo(track);
r.cl:=((hi(track) and $03) shl 6) or so_hieu_sector;
intr($13,R);
if r.ah<>0 then
begin
 count:=count+1;
 gotoxy(1,10);
 writeln('Sector is bad. Press any key to continue...');
 ch:=readkey;
 gotoxy(1,10);
 delline;
 insline;
end;
end;

procedure help;
begin
writeln('Cu phap :');
writeln('CHECKDSK [O_DIA:]');
writeln('VIDU: CHECKDSK A:');
end;

procedure Tieu_de;
begin
writeln('Chuong trinh kiem tra loi dia. Writen by Nguyen Manh Cuong.');
writeln('1b_Dien tu tin hoc_Dai hoc Bach khoa Ha noi.');
end;

BEGIN
clrscr;
Tieu_de;
if paramcount=0 
then begin help;halt;end;
if (paramstr(1)='A:') or (paramstr(1)='a:') then o_dia:=0
else if (paramstr(1)='B:') or (paramstr(1)='b:') then o_dia:=1
else if (paramstr(1)='C:') or (paramstr(1)='c:') then o_dia:=$80
else if (paramstr(1)='D:') or (paramstr(1)='d:')then o_dia:=$81
else o_dia:=$ff;
lay_tham_so_o_dia(o_dia);
gotoxy(1,5);
write('I''m checking ', paramstr(1));
if kieu_o_dia=2 then writeln(' 1.2MB.')
else if kieu_o_dia=4 then writeln(' 1.44MB.')
else begin
 dl:=(maxside+1)*(maxtrack+2);
 dl:=(dl*maxsector) div 2048;
 writeln('  ',dl,' MB.');
end;
writeln('Side :',maxside+1,' track :', maxtrack+1,' sec :',maxsector);
tong:=0; count:=0;
for i:=0 to maxside do
for j:=0 to maxtrack do
for k:=1 to maxsector do
begin
 if keypressed then
 begin gotoxy(1,11);
  write('Da kiem tra ',tong,' sector tren dia.Co ',count,' sector xau .');
  halt;
 end;
 kiem_tra_sector(o_dia,i,j,k,1);
 gotoxy(1,9);
 writeln('Side :',i:2,' track :', j:4,'   sector :',k:2);
 tong:=tong+1;
end;
gotoxy(1,11);
write('Hoan thanh kiem tra ',tong,' sector tren dia. Co ',count,' sector xau .');
END.
