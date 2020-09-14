* Chuong trinh sua doi ky tu
* dung chuc nang 11h , ngat 10
* Viet boi Tran Vinh
* 84 Lach Tray , Ngo Quyen , Tp Hai Phong

Uses crt, dos;

Type

TFonts = Array [ 0..255, 0..15] of byte;

Conts

Count = 255;

BChar = 15;

Bit001 : array [0.. 15] of byte = (
$80, $C0, $F0, $F8, $FC, $FE,  $FF, $D8, $98, $0C, $0C, $0C, $06,
$00, $00) ;

var

R : registers;

Buf : TFonts;

i, j : byte;

TCount : word;

begin

R.AH : = $11; { Func 11h }

R.AL : = $30;

R.BH : = 6;

Intr ( $10, R ) ; {Goi ngat 10 }
{
[ Assembler ]

[ MOV AH, 01h ]

[ MOV AL, 30h ]

[ MOV BH, 6 ]

[ INT 10h ]

}

TCount := 1;

For i := 0 to Count do

For j := 0 to BChar do

begin

Inc (TCount );
Buf [i,j] := Menu [R.ES : R.BP + TCount - 2 ];

{ Chuyen du lieu tu ES:BP vao Buffer }

end;

for TCount:= 0 to 15 do

Buff [ 1, TCount ] := Bit001 [ TCount ];

{ Sua cac byte trong buffer, ky tu so 1 }

{ Nap buffer da sua vao bo nho }

R.AH := $11;    
{Func 11h}

R.AL := 00;

R.CX : =255;    { So ky tu can nap }

R.DX : 0;       { Ky tu dau tien }

R.BL := 0;

R.BH := 16;     { 16 dong / ky tu ]

R.ES := Seg ( Buf );

R.BP := Ofs (Buf );

Intr ($10, r );

end.

{
[ Assembler ]

[ MOV AH,11h ]

[ XOR Al, AL ]

[ MOV CX, 255 ]

[ XOR DX, DX ]

[ XOR BL, BL ]

[ MOV BH, 16 ]

[ LEA BP,BUF ]

[ INT 10h ]

}