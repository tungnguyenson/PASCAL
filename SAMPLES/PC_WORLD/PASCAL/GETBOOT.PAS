uses dos,crt;
var  r:registers;
buf:array[1..512] of byte;
f:file;
i:integer;
begin
          writeln('Doc MBoot vao bo dem.');
          r.ax:=$0201;{ham 2,doc 1sector}
          r.dx:=$0080;{mat (dau) 0,dia mem}
          r.cx:=$0001;{xi lanh 0,sector1,do la bootsector}
          r.bx:=ofs(buf); {offset cua bo dem}
          r.es:=seg(buf); {segment cua bo dem}
          intr($13,r);    {ngat 13 cua bios doc boot}
          writeln('OK...');
          assign(f,'a:\mboothd.bin');
          {$I-}rewrite(f,1);{$I+}
          if ioresult<>0 then
          begin
                    writeln('Loi doc ghi dia .');
                    write('An phim bat ky de thoat...');
                    repeat until keypressed;
                    halt;
          end;
          blockwrite(f,buf,sizeof(buf),i);
          writeln('Da ghi duoc ',i,' byte vao MBOOTHD.BIN');
          close(f);
          repeat until keypressed;
END.
