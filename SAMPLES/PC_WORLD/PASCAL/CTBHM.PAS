PROGRAM CONVERT_TO_BHM;
Var
 f:file;
 f1:text;
 x,y:word;
 i:integer;
 buf:array[1..60] of byte;
 st:string;
 dem:word;
 e:byte;

Procedure writetof(st:string;len:integer);
Var
 j:byte;
 k:integer;
begin
 if st[1]=' ' then delete(st,1,1);
 if len<length(st)
 then k:=len
 else k:=length(st);
 for j:=1 to k do
  buf[j]:=ord(st[j]);
 for j:=k+1 to len do
  buf[j]:=32;
 blockwrite(f,buf,len);
 buf[1]:=13;
 buf[2]:=10;
 blockwrite(f,buf,2);
end;

Begin
 assign(f,paramstr(2));
 rewrite(f,1);
 assign(f1,paramstr(1));
 reset(f1);
 st:='BHM10';
 writetof(st,5);
 readln(f1,e,e,st);
 st:='Created by:'+st;
 writetof(st,42);
 readln(f1,e,e,st);
 st:='Address:'+st;
 writetof(st,69);
 readln(f1,e,e,st);
 st:='Date:'+st;
 writetof(st,16);
 readln(f1,e,e,st);
 writetof(st,60);
 dem:=0;
 blockwrite(f,dem,sizeof(dem));
 while not eof(f1) do
 begin
  readln(f1,x,y);
  dem:=dem+1;
  blockwrite(f,x,sizeof(x));
  blockwrite(f,y,sizeof(y));
 end;
 seek(f,202);
 blockwrite(f,dem,sizeof(dem));
 close(f);
 close(f1);
End.
