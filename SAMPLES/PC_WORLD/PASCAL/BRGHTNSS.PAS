
UNIT Brghtnss;
{Unit dung de lam mo man hinh -
An ban 1.0 chua cai tien toc do thuc hien,
chi thuc hien tren cac che do 16 mau}

INTERFACE
USES Crt, Dos;
type RGB = record
 Red,Green,Blue:byte;
End;

{Mang chua gia tri 16 thanh ghi mau hien dang su dung }
RegsRGB=array [0..15] of RGB;

{Noi dung 16 thanh ghi bang mau}
var Pallete: array[0..16] of byte; 

{Luu gia tri cua 16 thanh ghi mau dang dung de phuc hoi lai}
ColorRegisters : RegsRGB;

procedure GetPallete;
procedure GetColorRegisters;
procedure DecBrightness;
procedure NormalBrightness;

IMPLEMENTATION
procedure SetRGB(k,R,G,B:byte);
(*Dat thanh ghi mau thu <k> co gia tri <R><G><B>*)
var Reg:registers;
begin
with Reg do
begin
bx:=k; dh:=R;
ch:=G; cl:=B;
al:=$10; ah:=$10;
intr($10,Reg);
end;
end;{ SetRGB }

procedure GetRGB(k:byte; var R, G, B:byte);
(*Doc gia tri thanh ghi mau thu <k> va luu noi dung vao R, G, B *)
var Reg:registers;
begin
with Reg do
begin
bx:=k;
al:=$15; ah:=$10;
intr($10,Reg);
R:=dh; G:=ch; B:=cl;
end; end;

procedure GetPallete; 
(*Doc noi dung tat ca 16 thanh ghi bang mau, 
nhu vay chung ta se ghi nho so thu tu cac thanh ghi mau dang duoc su dung 
de dung trong thao tac lam mo*)
var Reg:registers;
begin
with Reg do
begin
es:=Seg(pallete);
dx:=Ofs(pallete);
al:=9; ah:=$10;
intr($10,Reg);
end;end;

procedure GetColorRegisters; 
(*Doc noi dung 16 thanh ghi mau dang duoc su dung de phuc hoi lai sau*)
var I : byte;
begin
for i:=0 to 15 do 
with ColorRegisters[i] do
GetRGB(Pallete[i], Red, Green, Blue);
end;

procedure NormalBrightness; 
(*Phuc hoi man hinh sau khi da lam mo, nghia la phuc hoi gia tri 16 thanh ghi mau da bi doi thanh 0 0 0 do qua trinh lam mo *)
var i:byte;
begin
for i:=0 to 15 do
with ColorRegisters[i] do 
SetRGB(Pallete[i],Red, Green, Blue);
end;

procedure DecBrightness;
(*Thu tuc lam mo man hinh trong cac che do 16 mau (ca TEXT lan GRAPH) 
Luu y: de co the phuc hoi lai man hinh,
nho chay GetColorRegisters truoc khi goi thu tuc nay
va goi thu tuc FastNormScreen de phuc hoi man hinh*)

const DEC_Step=1; {So don vi cuong do mau giam trong mot buoc}
procedure DEC_RGB (var i:Byte );
(*Giam cuong do sang cua mot mau co ban*)
begin
{Chi giam khi thanh phan mau khac khong}
if i > Dec_Step then Dec(i, Dec_Step)
else i:=0;
end;
var i, j:byte; {Cac bien cua thu tuc DecBrightness}
ch: char;
tmpColorReg:RegsRGB; {mang tam chua 16 thanh ghi mau dung de tinh toan}
LABEL Quit;
(*Chung toi su dung lenh GOTO trong thu tuc nay 
de cac ban thay ro y do cua chuong trinh hon 
chu khong co y pha vo loi lap trinh cau truc thong thuong cua chung ta*)
begin
GetPallete;
GetColorRegisters;
tmpColorReg:=ColorRegisters; 
{Thuc hien giam cuong do sang qua tung buoc}
for i:=1 to 63 div Dec_Step + 1 do
begin
for j:=0 to 15 do {giam cuong do cac mau co ban cua tung thanh ghi mau}
with tmpColorReg[ j ] do
begin
Dec_RGB(Red);
Dec_RGB(Green);
Dec_RGB(Blue);
SetRGB(Pallete[ j ],Red, Green, Blue );
if KeyPressed then 
GOTO Quit; 
end; 
end;
Write(#7); {Bao hieu mot tieng beep cho biet da hoan tat thao tac lam mo}
ch:=ReadKey; {Cho nhan phim de phuc hoi lai man hinh}
Quit:
NormalBrightness;
end; 
end.


