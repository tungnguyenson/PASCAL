{ Ch­¬ng tr×nh  tÝnh giai  thõa }
{ ViÕt bëi §inh H¶i Minh - BK80, K42, §H B¸ch Khoa HN }  
var
  Result: array[1..32200] of Word;
  i,n,leng: Word;
  Count: LongInt;
  timeStart,timeEnd,time: LongInt;
  CurrentTime: LongInt absolute $0000:$046C;
{-------------------------------------------------}
procedure Multiply(Count:Word);assembler;
asm
	mov	bx,10000		{ hÖ c¬ sè }
	mov	cx,leng			{ ®é dµi cña kÕt qu¶ }
	mov	di,0			{ sè nhí }
	mov	si,offset Result	{ ®Þa chØ cña kÕt qu¶ }
        mov	bp,Count		{ sè nh©n }
@repeat:
	mov	ax,[si]
	mul	bp
	add	ax,di
	adc	dx,0
	div	bx
	mov	[si],dx
	mov	di,ax
	add	si,2
	loop    @repeat
@while:
	cmp	ax,0
	jz	@finish
	inc	leng
	xor	dx,dx
	div	bx
	mov	[si],dx
	add	si,2
	jmp	@while
@finish:
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

  time:=timeEnd-timeStart;		{ sè nhÞp ®Õm thêi gian }
  WriteResult;
  Count:=Length(Format(Result[leng],0))+LongInt(leng-1)*4;
  Writeln('So chu so : ',Count);
  Writeln('Thoi gian tinh la : ',time/18.2:0:1,' giay');
end.
