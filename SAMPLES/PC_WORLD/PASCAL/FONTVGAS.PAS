
Unit fontvgas;

interface

uses graph;

const

{ha(`ng chua cac ky tu co chieu rong bang nhau:}

chieurong2=['!',
            ';','.','I','i','j','I','l'];

chieurong3=['(',')',',',';','[',']'];

chieurong4=['1','/','\','r','t','{','}'];

chieurong6=['$','*','-','0','2','9','<','>','a','h',

            'n','q','k','s','u','=','?','J','z','^'];

chieurong8=['A','H','#','+','K','L','N','V','_','v','x','y','&'];

chieurong10=['M','X','Y','Z','m','w'];

{hang mang chua bo ky tu+. tu+` ky tu "!" den ky tu " " }

{kieu chu vgasys c¢ chieu cao cao  nhat la 14 diem nˆn ta tao moi
ky tu 14 chuoi}

kitu:array['!'..':',1..14]of string[15]=(

('  ',{!}

'00',

'00',

'00',

'00',

'00',

'00',

'00',

'  ',

'00',

'00',

",","),

('   ',{"}

'00  00',

'00  00',

'00  00',

'00  00',

",",",",",",",","),

('      ',{#}

' 00  00',

' 00  00',

' 0000000',

' 00  00',

' 00  00',

'00  00',

'00  00',

'0000000 ',

'00  00 ',

'00  00 ',

",","),

..........

('     ',{A}

' 00  ',

' 00  ',

' 0000  ',

' 0000  ',

'00  00 ',

'00  00 ',

'00  00 ',

'00000000',

'00  00',

'00  00',

",","),

('     ',{B}

'0000000 ',

'00  00',

'00  00',

'00  00',

'0000000 ',

'00  00',

'00  00',

'00  00',

'00  00',

'0000000 ',

",","),

..........

{Cu tiep tuc nhu vay ta tao den ky tu " "}

(",",",{ }

'000 0',

'0 000',

",",",",",",",","));

{sau khi tao xong bo ky tu ta tao thu tuc viet chu:}

Procedure write V(x,y,clor:integer;st:string);

implementation; Procedure

xetchuoi(x,y,clor:integer;ch:char);

{ve ky tu}

var n,m:integer;

begin

For n:=1 to 14 do

For m:=1 to length(kitu[ch][n]) do

 if kitu[ch1][n][m]='0' then

 begin

 {ve tung diem cua ky tu:}

 putpixel(x+m,y+n,clor:integer;st:string);

var

i,dodaichuoi,sodiem:integer;begin

dodaichuoi:=0; sodiem:=0;

for i:=1 to length(st) do

begin

if st[i]='' then

dodaichuoi:=dodaichuoi+6;

if st[i]<>'' then begin

xetchuoi(x+dodaichuoi,y,clor,st[i]);

if st[i] in chieurong2 then

sodiem:=4;

if st[i] in chieurong3 then

sodiem:=5;

if st[i] in chieurong4 then

sodiem:=6;

if st[i] in chieurong6 then

sodiem:=8;

if st[i] in chieurong8 then

sodiem:=10;

if st[i] in chieurong10 then

sodiem:=12;

if st[i]='@' then sodiem:=13;

if st[i]='W' then sodiem:=16;

if st[i]='%' then sofiem:=13;

{sodiem: b‹ r›ng cœa kî t¨}

dodaichuoi:=dodaichuoi+sodiem;

end;end;end;

end.

