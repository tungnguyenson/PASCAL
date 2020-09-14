Unit LADPAS;

Interface
Uses
 graph, crt;
Var
 keyna, so, na, i, ma, mo,
 tdcvx, tdcvy, mauthua: integer;
 ch: string;
Procedure bip(a, b: integer);
Procedure lad(tdx, tdy: integer;
              argc: string;
              mau: integer);
Procedure khoitao;

Implementation
Procedure bip(a, b: integer);
Begin
if a<b then
 for i:= a to b do begin
  sound(i*223);
  delay(39);
 end
else
 for i:=a downto b do begin
  sound(i*223);
  delay(10);
 end;
nosound;
End;

Procedure lad(tdx, tdy: integer; argc: string; mau: integer);
Const
ff: array[1..11] of integer
 = (16, 6, 13, 4, 14, 5, 14, 4, 15, 5, 999);
ss: array[1..11] of integer
 = (13, 6, 16, 4, 15, 4, 15, 5, 14, 5, 999);
rr: array[1..11] of integer
 = (15, 6, 16, 5, 16, 4, 15, 4, 14, 4, 999);
xx: array[1..15] of integer
 = (13, 6, 17, 6, 18, 5, 13, 5, 14, 4, 15, 5, 16, 6, 999);
jj: array[1..5] of integer
 = (15, 15, 14,15, 999);
aa: array[1..9] of integer
 = (16, 6, 15, 5, 14, 5, 13, 6, 999);
uw: array[1..7] of integer
 = (18, 8, 18, 7, 17, 6, 999);
aw: array[1..9] of integer
 = (13, 5, 14, 6, 15, 6, 16, 5, 999);
dd: array[1..11] of integer
 = (14, 6, 16, 6, 15, 6, 17, 5, 18, 6, 999);
ddd: array[1..7] of integer
 = (10, 8, 13, 8, 14, 8, 999);
os: array[1..7] of integer
 = (18, 5, 19, 4, 20, 4, 999);
off: array[1..9] of integer
 = (18, 5, 17, 4, 16, 3, 17, 3, 999);
orr: array[1..9] of integer
 = (18, 5, 19, 4, 18, 3, 17, 3, 999);
ox: array[1..11] of integer
 = (17, 4, 18, 3, 19, 4, 20, 4, 21, 3, 999);
Begin
insert(' ', argc, 1); 
tdx:= tdx-mauthua;
if mau>=128 then tdy:= tdy-12;
case mau of 
 128..128+16:settextstyle(1,0,1);
 128*2..128*2+16:settextstyle(2,0,1);
 128*3..128*3+16:settextstyle(3,0,1);
 128*4..128*4+16:settextstyle(4,0,1);
 else settextstyle(0,0,1);
end;
setcolor(mau);
tdcvy:=tdy;
tdcvx:=tdx; 
so:=0;
na:=0;
keyna:=0;
for i:=1 to length(argc)do 
begin
 if ((argc[i] = 'f') and (na=1))
    or ((argc[i]= 's') and (na=1))
    or ((argc[i]='r') and (na=1))
    or ((argc[i]='x') and (na=1))
    or ((argc[i]='j') and (na=1))
    or ((argc[i]='F') and (na=1))
    or ((argc[i]='S') and (na=1))
    or ((argc[i]='R') and (na=1))
    or ((argc[i]='X') and (na=1))
    or ((argc[i]='w') and (na=1))
    or ((argc[i]=argc[i-1])
        and ((argc[i]='e') or (argc[i]='o')
             or (argc[i]='a') or (argc[i]='d')
             or (argc[i]='D')
            )) then
 begin
  keyna:= 1;
  tdx:= tdx-mauthua;
 end
 else keyna:= 0;
 if (keyna=0) then
 begin
  outtextxy(tdx, tdy, argc[i]);
  tdcvx:=tdcvx+mauthua;
  if (argc[i]= 'a') or (argc[i]= 'e')
     or (argc[i]= 'i') or (argc[i]= 'o')
     or (argc[i]= 'u') or (argc[i]= 'y')
  then   na:=1
  else na:=0;
  if (argc[i]= 'd')
     and ((argc[i+1]= 'd') or (argc[i+1]= 'D'))
  then
   while(dd[so] <> 999) do
   begin
    putpixel(dd[so]+tdx-11, dd[so+1]+tdy-6, mau);
    so:=so+2;
   end;
   if (argc[i]= 'D')
      and ((argc[i+1]= 'd') or (argc[i+1]= 'D'))
   then
    while(ddd[so]<>999) do
    begin
     putpixel(ddd[so]+tdx-11, ddd[so+1]+tdy-6, mau);
     so:=so+2;
    end;
 end; (*kt of if keyna=0 *)
 so:=1;
 if(na=1) then
 begin
  if mau>=128 then tdy:=tdy+8;
  case (argc[i]) of
   'f':
    while(ff[so]<>999) do
    begin
     putpixel(ff[so] +tdx-11, ff[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   's':
    while(ss[so]<>999) do
    begin
     putpixel(ss[so]+tdx-11, ss[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   'r':
    while(rr[so]<>999) do
    begin
     putpixel(rr[so]+tdx-11, rr[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   'x':
    while(xx[so]<>999) do
    begin
     putpixel(xx[so]+tdx-11, xx[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   'j':
   begin
    if mau>=128 then tdy:= tdy+4;
    while(jj[so]<>999) do begin
     putpixel(jj[so]+tdx-11, jj[so+1]+tdy-6,mau);
     so:=so+2;
    end;
    if mau>=128 then tdy:= tdy-3;
   end;
   'e', 'o', 'a':
    if(argc[i-1]=argc[i]) then
    begin
     if (argc[i+1]= 'f') or (argc[i+1]= 's')
        or (argc[i+1]= 'r') or (argc[i+1]= 'x')
     then argc[i+1] := chr(ord(argc[i+1])-32);
     while ( aa[so]<>999 ) do begin
      putpixel(aa[so]+tdx-11, aa[so+1]+tdy-6, mau);
      so:= so+2;
     end;
    end;
    'w':
    begin
     if (argc[i-1]= 'o') or (argc[i-1]= 'u') then
     begin
      while(uw[so]<>999) do
      begin
       putpixel(uw[so]+tdx-11, uw[so+1]+tdy-6, mau);
       so:= so+2;
      end;
     end;
     if (argc[i-1]= 'a') then
     begin
      if (argc[i+1]= 'f') or (argc[i+1]= 's')
         or (argc[i+1]= 'r') or (argc[i+1]= 'x') then
       argc[i+1]:=chr(ord(argc[i+1])-32);
      while ( aw[so]<>999) do
      begin
       putpixel(aw[so]+tdx-11, aw[so+1]+ tdy-6, mau);
       so:=so+2;
      end;
     end;
    end;
   'F':
    while(off[so]<>999) do
    begin
     putpixel(off[so]+tdx-11, off[so+1]+ tdy-6, mau);
     so:=so+2;
    end;
   'S':
    while(os[so]<>999) do
    begin
     putpixel(os[so]+tdx-11, os[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   'R':
    while (orr[so]<>999) do
    begin
     putpixel(orr[so]+tdx-11, orr[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   'X':
    while (ox[so]<>999) do
    begin
     putpixel(ox[so]+tdx-11, ox[so+1]+tdy-6, mau);
     so:=so+2;
    end;
   else ; (*else of case*)
  end;
  if mau>=128 then tdy:= tdy-8;
 end; (*kt of if ln.86: na=1 *)
 tdx:= tdx+mauthua;
 so:= 1;
end; (*kt of for i*)
End;

Procedure Khoitao;
Begin
ma:=3;
mo:=1; 
mauthua:=9;
initgraph(ma, mo, 'c:\tp\bgi');
End;
END.