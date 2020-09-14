Unit ViewPCX; 
Interface 
Uses Crt, ASMGraph, Dos; 
Type 
ColorReg = Record 
	Red: byte; 
	Green: byte; 
	Blue: byte; 
End; 
Palette_16 = Array [0..15] of ColorReg; 
Palette_256 = Array [0..255] of ColorReg; 
ExPalette = Record 
Position: byte; 
Pal_256: Palette_256; 
End; 
MainInfo = Record 
	Password: byte;  Version: byte; 
	Encode: byte;  BitPerPixel: byte; 
	x1: word;  y1: word; 
	x2: word;  y2: word; 
	Hres: word;  Vres: word; 
End; 
SubInfo=Record 
	Mode: byte; 
	Planes: byte; 
	BytesPerLine: word; 
	Pal_info: byte; 
	Unused: Array [0..57] of byte; 
End; 
Header=Record 
	M_Info: MainInfo; 
	Pal_16:Palette_16; 
	S_Info:SubInfo; 
End; 
Const 
bufsize:word=65535; 
Var 
HeaderInfo:Header; 
Pal:Palette_256; 
MaxX, MaxY:word; 

Procedure LoadPCX(filename:string); 
Implementation 
Procedure SetPalette256; 
Var 
r:registers;  i:byte; 
Begin 
For i:=0 to 255 do 
Begin 
pal[i].red:= pal[i].red shr 2; 
pal[i].green:= pal[i].green shr 2; 
pal[i].blue:= pal[i].blue shr 2; 
End; 
if(maxx=319) and (maxy=199) 
setvideo($13, graphon) 
Else setvideo($5d, graphon); 
r.ah:=$10; r.aL:=$12; 
r.bx:=0;  r.cx:=256; 
r.es:=seg(pal); 
r.dx:=ofs(pal); 
intr($10, r); 
End; 
Procedure LoadPCX(filename: string); 
Var 
F:File; 
P, Buffer: Pointer; 
i, j, result, read:word; 
b, loop, color:byte; 
Begin 
assign(f, filename); 
{$I-} 
reset(f,l); 
if ioresult <> 0 then exit; 
{Å$i+}
blockread(f, headerinfo, sizeof (headerinfo)); 
If headerinfo.m_info.password <> $A then 
Begin 
close (f); 
Writeln(filename, 'is not PCX file !'); 
Repeat Until keypressed; 
exit; 
End; 
MaxX:=headerinfo.m_info.x2; 
MaxY:=headerinfo.m_info.y2; 
If HeaderInfo.M_Info.BitPerPixel=8 then 
Begin 
seek(f, filesize(f)-768); 
blockread(f, pal, 768); 
SetPalette256; 
End 
Else Begin 
Writeln('Not load file PCX 16 colors'); 
exit; 
End; 
While maxavail < 65535 do dec(bufsize);
getmem(buffer, bufsize); 
seek(f,128); p:=buffer; 
blockread(f, buffer^, bufsize, result); 
read:=0;  i:=0; j:=0; 
Repeat 
b:=byte(p^); 
p:=ptr(seg(p^), ofs(p^)+1); 
inc(read); 
If (read=result) then 
Begin 
 p=buffer; 
 blockread(f, buffer^, bufsize, result); 
 read:=0 
End; 
If(b shr 6) = 3 then Begin 
color:=byte(p^); 
p:=ptr(seg(p^), ofs(p^)+1); 
inc(read); 
If (read=result) then Begin 
p:buffer; 
blockread(f, buffer^, bufsize, result); 
read :=0; 
End; 
For loop:=1 to (b and 63) do 
Begin 
writepixel(i, j, color); 
If i < MaxX then inc(i)
Else Begin 
i:=0; 
inc(j); 
End; 
End; 
End 
Else Begin 
writepixel(i, j, b); 
If i < MAxX then inc(i)
Else Begin 
i:=0; 
inc(j); 
End; 
End; 
Until (j>MaxY) or (Port[$60]=1); 
Close(f); 
Repeat Until keypressed; 
Setvideo(3, graphoff); 
End;
End. 