
Procedure Hoanvi(i:integer); 
Var j: integer; 
Begin 
For j:=1 to n do 
If (j in dienvao) 
then {dienvao la tap hop tren} 
begin 
 a[i]:=j; {dien vao so j} 
 dienvao:=dienvao+j; {loai j khoi tap dienvao truoc khi thu tiep} 
 If i < n then Hoanvi(i+1)
 Else Xuat; 
 dienvao:= dienvao-j; {quay lui va tra lai gia tri cu cho tap dienvao} 
end; 
End; 

