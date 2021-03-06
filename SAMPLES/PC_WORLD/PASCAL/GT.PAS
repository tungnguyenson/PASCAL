{ Ch��ng tr�nh  t�nh giai  th�a }
{ Vi�t b�i �inh H�i Minh - BK80, K42, �H B�ch Khoa HN }  
var
  Result: array[1..32200] of Word;
  i,n,leng: Word;
  Count: LongInt;
  timeStart,timeEnd,time: LongInt;
  CurrentTime: LongInt absolute $0000:$046C;
{-------------------------------------------------}
procedure Multiply(count:Word);		{ Th� t�c nh�n bi�n Result v�i Count }
var
  carry,i: Word;
  mul: LongInt;
begin
  carry:=0;			{ carry : s� nh� }
  for i:=1 to leng do	{ x�t t�ng ph�n t� c�a Result }
  begin
    mul:=LongInt(Result[i])*count+carry;
    Result[i]:=mul mod 10000;	{ k�t qu� m�i }
    carry:=mul div 10000;		{ s� nh� m�i }
  end;
  while carry<>0 do
  begin
    Inc(leng);
    Result[leng]:=carry mod 10000;
    carry:=carry div 10000;
  end;
end;
{-------------------------------------------------}
function Format(Number:Word; Count:Byte):string;
var
  s:string;
begin
  Str(Number,s);				{ chuy�n s� th�nh chu�i }
  while Length(s)<Count do s:='0'+s;	{ th�m 0 v�o ��u chu�i n�u thi�u }
  Format:=s;
end;
{-------------------------------------------------}
procedure WriteResult;		{ Th� t�c vi�t k�t qu� }
begin
  Writeln;
  Write(n,'! = ',Result[leng]);
  for i:=leng-1 downto 1 do Write(Format(Result[i],4));
  Writeln;
end;
{-------------------------------------------------}
begin
  Writeln('Chuong trinh tinh giai thua (n! = 1.2.3...n)');
  Write('Cho so n (n <= 31500) : ');
  Readln(n);

  timeStart:=CurrentTime;		{ ��nh d�u th�i �i�m b�t ��u }
  leng:=1;
  Result[1]:=1;			{ g�n gi� tr� ban ��u l� 1 }
  for i:=1 to n do Multiply(i);	{ t�nh giai th�a }
  timeEnd:=CurrentTime;		{ x�c ��nh th�i �i�m k�t th�c }

  WriteResult;
  Count:=Length(Format(Result[leng],0))+LongInt(leng-1)*4;
  Writeln('So chu so : ',Count);
  time:=timeEnd-timeStart;		{ s� nh�p ��m th�i gian }
  Writeln('Thoi gian tinh la : ',time/18.2:0:1,' giay');
end.

