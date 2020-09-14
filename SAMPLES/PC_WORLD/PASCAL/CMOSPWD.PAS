{Chuong trinh xoa password khong gay mat cau hinh cua CMOS}
{Viet boi Vuong Quang Khai ngay 17/8/1995} 
program Delete_Password_version_2; 
uses crt; 
function rcmos(diachi:byte):byte; 
begin 
port[$70]:=diachi; 
rcmos:=port[$71]; 
end; 
procedure wcmos(diachi, giatri:byte); 
begin 
port[$70]:=diachi; 
port[$71]:=giatri; 
port[$70]:=diachi+128; 
port[$71]:=giatri; 
end; 
var 
i,j:byte; 
f:file of byte; 
begin 
if (paramcount=1) and ((paramstr(1)='r')or (paramstr(1)='R')) then 

begin 
{Chi tien hanh xoa CMOS khi chay chuong trinh voi tham so r hoac R} 
assign(f,'cmosinfo.dat'); 
rewrite(f); 
for i:=0 to 127 do 
begin 
j:=rcmos(i); 
write(f, j); 
end; 
close(f); 
halt; 
end; 

{Hoi truoc khi ghi de len cau hinh CMOS moi}
 
writeln('Are you sure(Y/N):'); 
if upcase(readkey)='Y'then 
begin 
assign(f, 'cmosinfo.dat'); 
reset(f); 
for i:=0 to 127 do 
begin 
read(f, j) 
wcmos(i, j) 
end; 
close(f); 
end; 
writeln('OK'); 
end. 
