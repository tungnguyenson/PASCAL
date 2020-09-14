Procedure Xep_Nhom(x:integer); 
{x la so thu tu cua qua can, (qua can thu x)} 
Var i: integer; {Bien dung de de qui} 
Begin 
For i:=1 to 3 do 
{Duyet cach xep vao nhom cho qua can thu x} 
begin 
nhom[x]:=i; {Luu lai ket qua thu} 
If (x=n) 
then 
 Kiem_Tra {
 Da dat chia nhom xong, kiem tra ket qua} 
Else 
 Xep_Nhom(x+1); 
 {Neu khong goi de qui toi qua can tiep theo} 
end; 
End; 

