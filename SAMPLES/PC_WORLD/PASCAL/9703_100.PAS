
Procedure Floyd_Bellman;
Var i,j,n:integer;
Begin

{Phan khoi tao gia tri}
For i:=1 to n do
For j:=1 to n do
begin
 d[i,j]:=c[i,j];
 {c la ma tran ke}
 r[i,j]:=0;
 {r la ma tran bao duong di ngan nhat qua dinh thu+' ma^'y}
end;

{Phan tim duong di ngan nhat voi 3 vong cho cac cap dinh i,j va k}
For i:=1 to n do
For j:=1 to n do
For k:=1 to n do
 If (d[i,j]>d[i,k]+d[k,j]) then
 {kiem tra duong di tu i toi j qua k
 co ngan hon duong tu i toi j hien thoi hay khong}
 begin
 {Neu dung thi luu lai gia tri}
  d[i,j]:= d[i,k]+d[k,j];
  {tim duoc duong di ngan hon}
  r[i,j]:=k;
  {duong di nay qua dinh thu k}
 end;
End;


Procedure Find(i,j:integer); 
Begin 
If r[i,j]=0 then write('--->', j) 
Else 
Begin 
 Find(i,r[i,j]);
 Find(r[i,j],j);
End;
End;
