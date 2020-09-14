(*MAPHUONG.PAS*)
{PCW: chi chay dung den bac 5}
uses crt;
const MN = 50; 
TT = 'T';
DD = 'D'; NN = 'N';
KK = 'B';
var M: array[1..MN,1..MN] of word;

(***Bao loi***)
procedure Err(s: string; d: integer);
begin
writeln(#7);
write('LOI: ',s,d);
readln;
Halt;
end;

(***Hien thi va kiem tra ket qua ***)
procedure Test(n: word);
var i,j,ss,s: word;
begin
{Hien thi Ma phuong}
for i:=1 to n do
begin
 writeln;
 for j:=1 to n do
  write(M[i,j]:4);
end;
writeln;

{Tinh Dac so}
s:=(n*n+1)*n div 2;
{Kiem tra Dong}
for i:=1 to n do
begin
 ss:=0;
 for j:=1 to n do
  ss:=ss+M[i,j];
 if ss<>s then Err('Dong ',i);
end;
{Kiem tra Cot}
for j:=1 to n do
begin
 ss:=0;
 for i:=1 to n do
  ss:=ss+M[i,j];
 if ss<>s then Err('Cot ',j);
end;
{Kiem tra Duong cheo thu nhat}
ss:=0;
for i:=1 to n do
 ss:=ss+M[i,i];
if ss<>s then Err('Cheo ',1);
{Kiem tra Duong cheo thu hai}
ss:=0;
for i:=1 to n do
 ss:=ss+M[i,n-i+1];
if ss<>s then Err('Cheo ',2);
write('Ma phuong bac ',n);
readln;
end;

(***Ma phuong bac le***)
procedure MPL(n: word);
var k,i,ii,j,jj: word;
begin
{Buoc 1: Khoi tri}
for i:=1 to n do
for j:=1 to n do
 M[i,j]:=0;
{Buoc 2: Xac dinh o xuat phat}
i:=n; j:=n div 2 + 1;

{Buoc 3: Dien so}
for k := 1 to n*n do
begin
 { 3.1. Dien o (i,j)}
 M[i,j]:=k;
 { 3.2. Xac dinh vi tri ii, jj moi cho so tiep theo (k+1)}
 if (i=n) and (j=n) then
 begin
 {3.2.1. Tinh huong Dong-Nam: Ddie^`n tre^n}
  ii:=i-1;jj:=j;
 end else
 begin {3.2.2 va 3.2.3}
  ii:=i mod n + 1;
  jj:=j mod n + 1;
 end;

 if M[ii,jj]<>0 then
 begin
 {3.2.4. Dung do: Dien tren}
  ii:=i-1;
  jj:=j;
 end;
 i:=ii; j:=jj;
end;
Test(n);
end;

(***So nam tren hang i, cot j***)
function Num(i,j,n: word):word;
begin
Num:=(i-1)*n+j;
end;

(**Lay doi xung qua tam (2 so) **)
procedure Tam(i,j,n: word);
begin
M[i,j]:=Num(n-i+1,n-j+1,n);
M[n-i+1,n-j+1] := Num(i,j,n);
M[n-i+1,j] := Num(i,n-j+1,n);
M[i,n-j+1] := Num(n-i+1,j,n);
end;

(***Doi xung doc***)
procedure Doc(i,j,n: word);
begin
M[i,j]:=Num(i,n-j+1,n);
M[i,n-j+1]:=Num(i,j,n);
end;

(***Doi xung ngang***)
procedure Ngang(i,j,n: word);
begin
M[i,j]:=Num(n-i+1,j,n);
M[n-i+1,j]:=Num(i,j,n);
end;

(*** Quay xau mau***)
procedure Quay(var s: string);
var c: char;
i: byte;
begin
c:=s[length(s)];
for i:=length(s) downto 2 do
s[i]:=s[i-1];
s[1]:=c;
end;

(***Ma phuong bac chan***)
procedure MPC(n: word);
var k,i,j: word;
s: string;
begin
if n=2 then exit;

{Buoc1: Khoi tri}
for i:=1 to n do
 for j:=1 to n do
  M[i,j]:=Num(i,j,n);

{Buoc 2: Tao xau mau}
s:= ' '; {Khoi tri xau rong}
k:=n div 2;
{Nap (k div 2) ki tu T}
for i:=1 to (k div 2) do s := s+TT;
{Nap them 2 ki tu D va N neu k le}
if Odd(k) then s := s+DD+NN;
{Bu cac ki tu B cho du k ki tu}
for i:= length(s)+1 to k do s:=s+KK;
{Dien so theo xau mau}
for i:=1 to k do
begin { xu ly dong i }
for j:=1 to k do
case s[j] of
TT: Tam(i,j,n);
DD: Doc(i,j,n);
NN: Ngang(i,j,n);
end;
Quay(s);
end;
Test(n);
end;

procedure MP(n: word);
begin
if Odd(n) then MPL(n) else MPC(n);
end;

procedure TestMP;
var i: word;
begin
clrscr;
for i:=1 to 20 do MP(i);
end;

BEGIN
TestMP;
END.
