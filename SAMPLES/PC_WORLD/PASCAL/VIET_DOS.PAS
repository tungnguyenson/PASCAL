
Uses DOS; {Ghep UNIT DOS} 
Var 
Regs: Registers; 	
{Bien thanh ghi de goi ngat} 
FontBuffer:array[1..4096] of byte; 
{Vung dem bang ky tu} 
FontSize:word; 	
{Kich thuoc bang ky tu} 
DiskFontFile:File; 	
{Font file tren dia} 

Procedure LoadTextFont(FontFileName:string); 
Begin 
assign(DiskFontFile, FontFileName); 
reset(DiskFontFile,1); 
FontSize:=filesize(DiskFontFile); 
blockread(DiskFontFile,FontBuffer,FontSize); 
close(DiskFontFile); 
case FontSize of 
	2048:Regs.BH:=8; 	
	{Font 8x8:man hinh CGA} 
	3584:Regs.BH:=14; 	
	{Font 14x8:man hinh EGA} 
	4096:Regs.BH:=16; 	
	{Font 16x8:man hinh VGA} 
	else Regs.BH:=0; 	
	{Font file bi loi, khong nap} 
end; 
with Regs do 
begin 
	ES:=seg(FontBuffer); 	
	{dia chi doan bang ky tu} 
	BP:=ofs(FontBuffer); 	
	{dia chi offset bang ky tu} 
	CX:=256; 	
	{Nap toan bo bang ky tu} 
	DX:=0; 	
	{Bat dau tu ky tu dau tien} 
	BL:=0; 	
	{Bang ky tu 0} 
	AX:=$1110; 	
	{Ham 11h, ham con 10h} 
end; 
intr($10,Regs); 	
{Goi ngat man hinh 10h} 
End; 

Procedure RestoreStandardTextFont;assembler; 
ASM 
mov ah,11h 
{Ham tao bo ky tu} 
mov al,4h 
{Font VGA 16x8} 
mov bl,0h 
{Bang ky tu 0} 
int 10h 
END; 


Procedure LoadGrFont(FontFileName:string); 
Begin 
assign(DiskFontFile,FontFileName); 
reset(DiskFontFile,1); 
FontSize:=filesize(DiskFontFile); 
blockread(DiskFontFile,FontBuffer,FontSize); 
close(DiskFontFile); 
case FontSize of 
	2048:Regs.CX:=8; 	{Font 8x8:man hinh CGA} 
	3584:Regs.CX:=14; 	{Font 14x8:man hinh EGA} 
	4096:Regs.CX:=16; 	{Font 16x8:man hinh VGA} 
	else Regs.CX:=0; 	{Font file bi loi, khong nap} 
end; 
with Regs do 
begin 
	ES:=seg(FontBuffer); 	{dia chi doan bang ky tu} 
	BP:=ofs(FontBuffer); 	{dia chi offset bang ky tu} 
	AH:=$11; 		{Ham tao bo ky tu} 
	AL:=$21; 		{Ham con nap bo ky tu do hoa} 
	BL:=0;  		{So dong do nguoi dung dinh nghia} 
	DL:=round(480/CX); 	{do phan giai/chieu cao ky tu} 
end; 
intr($10,Regs); 		{Goi ngat man hinh 10h} 
End; 

Procedure RestoreStandardGrFont;assembler; 
ASM 
mov ah,11h 	{Ham tao bo ky tu} 
mov al,24h 	{Font VGA 16x8, do hoa} 
mov bl,30 	{30 dong ky tu} 
int 10h 
END; 

ÿ