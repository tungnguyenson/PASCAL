
Procedure Load_font; 
Var 
r: registers; 
Begin 
r.ah:=$11; 
r.al:=0; 
r.bh:=16; 
r.bl:=0; 
r.cx:=256; 
r.dx:=0; 
r.es:=seg(font); 
r.bp:=ofs(font); 
intr($10,r); 
End; 


Procedure Load_RomFont; 
Var 
r: registers; 
Begin 
r.ah:=$11 
r.al:=4; 
r.bl:=0; 
intr($10,r); 
End; 

 
Program Chuyen_font_thanh_mang; 
Begin 
Khai_bao ('vgath', 'Khai_bao.pas');
{Luu y phai co file font vgath trong thu muc hien hanh}
End 
 
Program Vi_du_lien_ket_font; 
Uses Dos; Crt; 
{$I Khai_bao.pas}
Begin 
Loadfont; 
Writeln ('Day la chuong trinh minh hoa viec lien ket font vao chuong trinh');
Writeln ('Viet boi Vu Huy Phuong - Truong PTTH Luong The Vinh, Bien Hoa, Dong Nai');
Readkey;
Load_Romfont;
End.

