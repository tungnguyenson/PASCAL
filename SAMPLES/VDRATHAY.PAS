{$s-,R-,g+,q-}
Uses crt;
  Var
    a,c,d,e,f,g,h,i,j,k,l,s,x,y,z:word;
    t,u:array[0..1023]of word;
Begin
  h:=$FF00;
  l:=$FF;
  s:=$8000;
  z:=1023;
  asm
    mov ax,13h
    int 10h
  End;
  For a:=0 to z do t[a]:=round(sin(pi*a/512)*127+128);
  For a:=0 to l do
    begin
      port[$3C8]:=a+32;
      port[$3C9]:=t[a*8 and z]shr 2;
      port[$3C9]:=t[a*12 and z]shr 2;
      port[$3C9]:=t[a*4 and z]shr 2;
      u[a]:=trunc(cos(a*pi/127)*sqrt(sin(pi*a/32)/3+0.6)*31+32);
    End;
  For x:=16000 to h do mem[$9DA8:x]:=x div 640+142;
  For x:=0 to 319 do
    for y:=u[x*2 and l]to 99 do
      mem[$A640+Y*20:x]:=32-y shr 1;
  For a:=0 to h+l do mem[s:a]:=hi(a)xor a;
    repeat
      c:=c+3;{}
      j:=t[c*6 and z]div 4 +t[c*8 and z]div 2+50;{}
      k:=J*t[(c+1)and z]shr 6-J*2;{}
      i:=J*t[(c+1)and z]shr 6-J*2;{}
      a:=t[(c-512)and z];{}
      f:=J*(t[(c+1)and z]-a)and h+12800;{}
      g:=J*(t[(c+1)and z]-a)and h-12800;{}
      a:=0;
      For y:=100 to 199 do
        Begin
          d:=f;e:=g;f:=f-i;g:=g-k;
          For x:=100 to 200 do
            Begin
              mem[$A3FC:x+a]:=mem[s:hi(d)+e and h];
              dec(d,i);inc(e,i);
            End;
          a:=a+320;
        end;
      For x:=0 to 99 do
        for y:=0 to 99 do
          mem[s+y*16:x]:=u[(x*y shr 6+c)and l]-c+u[(y+c) and l];
      Delay(10);
      Until port[$60]=1;
    textmode(3);
End.