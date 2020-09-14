uses dos,crt;
var  r:registers;
     buf:array[1..512] of byte;
     f:file;
     i:integer;
begin
          assign(f,'a:\mboothd.bin');
          {$I-}reset(f,1);{$I+}
          if ioresult<>0 then
          begin
                    writeln('Loi doc ghi dia .');
                    write('An phim bat ky de thoat...');
                    repeat until keypressed;
                    halt;
          end;
          blockread(f,buf,sizeof(buf),i);
          writeln('Da doc duoc ',i,' byte tu MBOOTHD.BIN');
          close(f);
          r.ax:=$0301;{ham 2,doc 1sector}
          r.dx:=$0080;{mat (dau) 0,dia cung C:}
          r.cx:=$0001;{xi lanh 0,sector1,do la matterboot}
          r.bx:=ofs(buf); {offset cua bo dem}
          r.es:=seg(buf); {segment cua bo dem}
          intr($13,r);
          if (r.ah <> 0) then write('Loi.') else
          writeln('OK...');
          repeat until keypressed;
END.
