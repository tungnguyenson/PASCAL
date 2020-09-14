uses dos,crt;
type
	pallete_type = array[1..768] of byte;
var
   f:file;
   name:string;
	screen:array[1..320,1..200] of byte absolute $A000:0000;
   dirinfo:searchrec;
(*------------------------------------------------------------------------*)
Procedure Setmode(mode:byte);
var
	r:registers;
begin
   with r do
   begin
		ah:=0;
      al:=mode;
	end;
   intr($10,r);
end;
(*------------------------------------------------------------------------*)
procedure set_pallete(p:pallete_type);
var
	r:registers;
begin
	r.ah:=$10;
   r.al:=$12;
   r.bx:=0;
   r.cx:=256;
   r.es:=seg(p);
   r.dx:=ofs(p);
   intr($10,r);
end;
procedure	readthp(filename:string);
var
	f:file;
   p:pallete_type;
begin
   {$i-}
   assign(f,filename);
   reset(f,1);
   if ioresult<>0 then
   begin
   	writeln('File not found');
      writeln;
      halt(1);
   end;
   {$i+}
   blockread(f,p,768);
	set_pallete(p);
   blockread(f,screen,64000);
   close(f);
   readkey;
End;
(*------------------------------------------------------------------------*)
Begin
   if paramcount = 0 then
   begin
   	writeln('Read bitmap THP 1.0. Written by Vu Huy Phuong. Luong The Vinh high school.');
      writeln('Bien Hoa - Dong Nai. Tel (061) 827732.');
      writeln('Syntax : ReadTHP < filename.thp > or < *.thp>');
   end
	else
   begin
      name:=paramstr(1);
   	if name = '*.thp' then
		begin
         setmode($13);
			FindFirst('*.thp', Archive, DirInfo); { Same as DIR *.PAS }
			while DosError = 0 do
 			begin
   			readthp(DirInfo.Name);
   			FindNext(DirInfo);
 			end;
         setmode(3);
      end
      else
      begin
			setmode($13);
         readthp(name);
      	setmode(3);
      end;
   end;
End.