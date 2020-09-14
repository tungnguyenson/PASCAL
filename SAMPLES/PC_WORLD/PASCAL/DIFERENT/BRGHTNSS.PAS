UNIT Brghtnss;

INTERFACE
USES Dos,Crt;
procedure DecBrghtnss(DelayTime:Byte);
procedure RestoreScr(DelayTime:Byte);
procedure InitBrghtnss;
procedure DoneBrghtnss;

IMPLEMENTATION
const NumStep=63;

type RGB=record
 R,G,B: byte;
end;
type TColorRegs=array[0..15] of RGB;
TGroupRegs=array[0..NumStep] of TColorRegs;
var pGroupRegs: ^TGroupRegs;

procedure SetPalReg (PalRegNo, ColorRegNo:byte);
(*Dat gia tri thanh ghi bang mau*)
var Regs:registers;
begin
 with Regs do
 begin
  ah:=$10; al:=$0;
  bl:=PalRegNo; bh:=ColorRegNo;
  Intr($10,Regs);
 end;
end;

function GetPalReg (Num:byte): byte;
(*Doc noi dung thanh ghi bang mau*)
var Regs:registers;
begin
 with Regs do
 begin
  ah:=$10; al:=$7;
  bl:=Num;
  Intr($10,Regs);
  GetPalReg:=BH;
 end;
end;

procedure GetRGB(Num:byte;var R,G,B:byte);
(*Doc noi dung thanh ghi mau*)
var Regs:registers;
begin
 with Regs do
 begin
  ah:=$10; al:=$15;
  bx:=Num;
  Intr($10,Regs);
  R:=dh; G:=ch; B:=cl;
 end;
end;

procedure SetRGB(Num, R, G, B: byte);
(*Dat noi dung thanh ghi mau*)
var Regs:registers;
begin
 with Regs do
 begin
  ah:=$10; al:=$10; bx:=Num;
  dh:=R; ch:=G; cl:=B;
 Intr($10,Regs);
 end;
end;

procedure SetGroupColorRegs (StartColorReg, Num:byte;
                            Segment, Offset:word);
(*Dat mot nhom thanh ghi mau*)
var Regs:registers;
begin
 with Regs do
 begin
  ah:=$10; al:=$12;
  bx:=StartColorReg; cx:=Num;
  es:=Segment; dx:=Offset;
  Intr($10,Regs);
 end;
end;

procedure SetColorRegs;
(*Chep noi dung 16 thanh ghi mau hien dang su dung
va luu lai cac gia tri nao*)
var i:byte;
R,G,B:byte;
begin
 for i:=0 to 15 do
 begin
  GetRGB(GetPalReg(i),R,G,B);
  SetRGB(i,R,G,B);
  pGroupRegs^[0][i].R:=R;
  pGroupRegs^[0][i].G:=G;
  pGroupRegs^[0][i].B:=B;
 end;
end;

procedure SetPaletteRegs;
(*Dat he thong su dung 16 thanh ghi mau dau tien*)
var i:byte;
begin
 for i:=0 to 15 do SetPalReg(i,i);
end;

function Dec_RGB (RGB:byte): byte;
begin
 if RGB > 0 then Dec_RGB:=RGB-1
 else Dec_RGB:=0;
end;

procedure SetAllColorRegs;
(*Tinh toan gia tri cac thanh ghi mau trong tung buoc giam *)
var i,j:byte;
begin
for i:=1 to NumStep do
 for j:=0 to 15 do
 begin
  pGroupRegs^[i][j].R:= Dec_RGB (pGroupRegs^[i-1][j].R);
  pGroupRegs^[i][j].G:= Dec_RGB (pGroupRegs^[i-1][j].G);
  pGroupRegs^[i][j].B:= Dec_RGB (pGroupRegs^[i-1][j].B);
 end;
end;

procedure DecBrghtnss (DelayTime:byte);
(*Lam mo man hinh*)
var i:byte;
begin
 for i:=0 to NumStep do
 begin
  SetGroupColorRegs(0, 16, Seg(pGroupRegs^[i][0]), Ofs(pGroupRegs^[i][0]));
  Delay(DelayTime);
 end;
end;

procedure RestoreScr (DelayTime: Byte);
(*Phuc hoi man hinh*)
var i:byte;
begin
 for i:=NumStep downto 0 do
 begin
  SetGroupColorRegs(0, 16, Seg(pGroupRegs^[i][0]), Ofs(pGroupRegs^[i][0]));
  Delay(DelayTime);
 end;
end;

procedure DoneBrghtnss;
(*Giai phong vung nho dung de lam mo man hinh*)
begin
 FreeMem(pGroupRegs, SizeOf (TGroupRegs));
end;

procedure GetMemForBrghtnss;
(*Xin cap phat bo nho de lam mo*)
begin
 GetMem(pGroupRegs, SizeOf (TGroupRegs));
end;

procedure InitBrghtnss;
(*Chuan bi de lam mo*)
begin
 GetMemForBrghtnss;
 SetColorRegs;
 SetPaletteRegs;
 SetAllColorRegs;
end;

end.
