uses dos,crt;
const length=10;
var  r:registers;
buf:array[0..511] of byte;
f:file;
i,lpw:integer;
pw:array[1..length] of byte;
ch:char;
procedure  Doc_mboot;
begin
          r.ax:=$0201;
          r.dx:=$0080;
          r.cx:=$0001;
          r.bx:=ofs(buf);
          r.es:=seg(buf);
          intr($13,r);
end;
procedure Ghi_mboot;
begin
          r.ax:=$0301;
          r.dx:=$0080;
          r.cx:=$0005;
          r.bx:=ofs(buf);
          r.es:=seg(buf);
          intr($13,r);
end;
procedure Dat_pw;
begin
          clrscr;gotoxy(30,12);
          write('Nhap vao password :');
          i:=0;
          repeat
               i:=i+1;
               ch:=readkey;
               IF ch<>#13 then
               pw[i]:=ord(ch);
          until (ch=#13) or (i=length);
	  if i=length then lpw:=length else lpw:=i-1;
          assign(f,'a:\password.bin');
          {$I-}reset(f,1);{$I+}
          if ioresult<>0 then
          begin
                    clrscr;
                    writeln('Loi doc dia hoac khong thay file "PASSWORD.BIN" trong thu muc hien thoi.');
                    write('An phim bat ky de thoat...');
                    repeat until keypressed;
                    halt;
          end;
          blockread(f,buf,sizeof(buf),i);
          close(f);
          buf[$1ee]:=lpw xor $43;
          buf[$1fd]:=$43;
          for i:=$1f0 to $1f0+lpw do buf[i]:=pw[i-$1ef] xor $43;
          r.ax:=$0301;
          r.dx:=$0080;
          r.cx:=$0001;
          r.bx:=ofs(buf);
          r.es:=seg(buf);
          intr($13,r);
end;
procedure Xoa_pw;
begin
          r.ax:=$0201;
          r.dx:=$0080;
          r.cx:=$0005;
          r.bx:=ofs(buf);
          r.es:=seg(buf);
          intr($13,r);
          r.ax:=$0301;
          r.dx:=$0080;
          r.cx:=$0001;
          r.bx:=ofs(buf);
          r.es:=seg(buf);
          intr($13,r);
end;
BEGIN
          clrscr;textbackground(4);textcolor(15);
          writeln('****Chuong trinh dat password cho dia cung.Copyright (C) Nguyen Manh Cuong****');
          writeln('******************1b-Dien tu tin hoc Dai hoc bach khoa Ha noi*****************');
          Doc_mboot;
          if buf[$1fd]=$43  then
          begin
               gotoxy(15,12);
               write('Dia cung da cai password .Ban co muon sua khong (C/K) :');
               ch:=readkey;
               textbackground(black);textcolor(15);
               if (ch='C') or (ch='c') then begin Dat_pw;halt;end;
               gotoxy(15,12);clreol;
          end;
          textbackground(black);textcolor(15);
          gotoxy(30,12);writeln('1-Sua password.');
          gotoxy(30,13);writeln('2-Dat password.');
          gotoxy(30,14);writeln('3-Xoa password.');
          gotoxy(30,15);writeln('4-Thoat khoi truong trinh');
          gotoxy(30,17);write('Ban hay chon :');
          ch:=readkey;
          case ch of
               '1':Dat_pw;
               '2':begin ghi_mboot;Dat_pw;end;
               '3':Xoa_pw;
               '4':halt;
          end;
END.
