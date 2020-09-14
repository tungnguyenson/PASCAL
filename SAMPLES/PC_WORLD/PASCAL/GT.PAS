{ Ch­¬ng tr×nh  tÝnh giai  thõa }
{ ViÕt bëi §inh H¶i Minh - BK80, K42, §H B¸ch Khoa HN }  
var
  Result: array[1..32200] of Word;
  i,n,leng: Word;
  Count: LongInt;
  timeStart,timeEnd,time: LongInt;
  CurrentTime: LongInt absolute $0000:$046C;
{-------------------------------------------------}
procedure Multiply(count:Word);		{ Thñ tôc nh©n biÕn Result víi Count }
var
  carry,i: Word;
  mul: LongInt;
begin
  carry:=0;			{ carry : sè nhí }
  for i:=1 to leng do	{ xÐt tõng phÇn tö cña Result }
  begin
    mul:=LongInt(Result[i])*count+carry;
    Result[i]:=mul mod 10000;	{ kÕt qu¶ míi }
    carry:=mul div 10000;		{ sè nhí míi }
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
  Str(Number,s);				{ chuyÓn sè thµnh chuçi }
  while Length(s)<Count do s:='0'+s;	{ thªm 0 vµo ®Çu chuçi nÕu thiÕu }
  Format:=s;
end;
{-------------------------------------------------}
procedure WriteResult;		{ Thñ tôc viÕt kÕt qu¶ }
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

  timeStart:=CurrentTime;		{ ®¸nh dÊu thêi ®iÓm b¾t ®Çu }
  leng:=1;
  Result[1]:=1;			{ g¸n gi¸ trÞ ban ®Çu lµ 1 }
  for i:=1 to n do Multiply(i);	{ tÝnh giai thõa }
  timeEnd:=CurrentTime;		{ x¸c ®Þnh thêi ®iÓm kÕt thóc }

  WriteResult;
  Count:=Length(Format(Result[leng],0))+LongInt(leng-1)*4;
  Writeln('So chu so : ',Count);
  time:=timeEnd-timeStart;		{ sè nhÞp ®Õm thêi gian }
  Writeln('Thoi gian tinh la : ',time/18.2:0:1,' giay');
end.

