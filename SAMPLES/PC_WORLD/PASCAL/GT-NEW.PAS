{ Ch��ng tr�nh  t�nh giai  th�a }
{ Vi�t b�i �inh H�i Minh - BK80, K42, �H B�ch Khoa HN }  
var
  Result: array[1..32200] of Word;
  i,n,leng: Word;
  Count: LongInt;
  timeStart,timeEnd,time: LongInt;
  CurrentTime: LongInt absolute $0000:$046C;
{-------------------------------------------------}
procedure Multiply(Count:Word);assembler;
asm
	mov	bx,10000		{ h� c� s� }
	mov	cx,leng			{ �� d�i c�a k�t qu� }
	mov	di,0			{ s� nh� }
	mov	si,offset Result	{ ��a ch� c�a k�t qu� }
        mov	bp,Count		{ s� nh�n }
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

  time:=timeEnd-timeStart;		{ s� nh�p ��m th�i gian }
  WriteResult;
  Count:=Length(Format(Result[leng],0))+LongInt(leng-1)*4;
  Writeln('So chu so : ',Count);
  Writeln('Thoi gian tinh la : ',time/18.2:0:1,' giay');
end.
