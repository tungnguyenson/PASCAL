Uses Graph,Dos,Crt;
Const
 SotgMau=64; {So thanh ghi mau A}
 Kt_Bangmau=Sotgmau*3;
 dl=50;
Type
 Kieubangmau=array[1..Kt_Bangmau] of byte;
Var
 R:Registers; {Bien thanh ghi A}
 BmChuan,Bangmau:Kieubangmau;
 M,i,j:Integer;
 tm,ti,tj:Boolean;
 mangLg:Array[1..Kt_Bangmau] of Boolean;

Procedure Laybangmau (Var P:Kieubangmau);
(* Thu tuc lay noi dung bang mau *)
Begin
With R do Begin
 AH:=$10;
 AL:=$17;
 BX:=0;
 CX:=Sotgmau;
 ES:=Seg(P);
 DX:=Ofs(P);
End;
Intr($10,R);
{
Sau khi goi int 10h
thi es:dx chua noi dung bang mau
}
End;

Procedure Datbangmau (P: Kieubangmau);
(* Thu tuc dat lai noi dung bang mau *)
Begin
With R do Begin
 AH:=$10;
 AL:=$12;
 BX:=0;
 CX:=Sotgmau;
 ES:=Seg(P);
 DX:=Ofs(P);
End;
Intr($10,R);
End;

Begin
(* Khoi tao che do ddo^\ hoa. *)
I:=VGA;
J:=VGAHI;
InitGraph(I, J, 'd:\bp\bgi');
If GraphResult <> GrOk then Halt;
Laybangmau(BmChuan);
FillChar(Bangmau,SizeOf(Bangmau),0);
FillChar(Manglg,SizeOf(Manglg),True);
(* Dua toan bo bang mau ve mau den *)
Datbangmau(Bangmau);
SetTextStyle(TriplexFont,HorizDir,4);
SetTextJustify(LeftText,TopText);
SetColor(LightGreen);
SetBkColor(Blue);
(* Man hinh sang dan *)
OutTextXY(30,50,'Man hinh sang dan...');
m:=0;
For i:=1 to Kt_bangmau do
 If m< BmChuan[i] then m:=BmChuan[i];
j:=0;
Repeat
 Inc(j);
 For i:=1 to Kt_Bangmau do
 If Bangmau[i] < BmChuan[i] then
  Inc(Bangmau[i]);
 Delay(dl);
 Datbangmau(Bangmau);
 Delay(dl);
Until j=m;
Setcolor(Yellow);
(* Man hinh thay doi sac do *)
OutTextXY(30,100,'Man hinh thay doi sac do...');
Tm:= True;
Tj:=True;
For i:=1 to Kt_bangmau do
 Bangmau[i]:=BmChuan[i];
Repeat
 For i:=1 to Kt_Bangmau do
 Begin
  If MangLg[i] then
   Inc(Bangmau[i])
  Else Dec(Bangmau[i]);
  If Bangmau[i]=255 then
  Begin
   MangLg[i]:=False;
   SetBkColor(Cyan);
  End;
  If Bangmau[i]=0 then
  Begin
   MangLg[i]:=True;
   SetBkColor(Green);
  End;
 End;
 Delay(dl);
 Datbangmau(Bangmau);
 Delay(dl);
Until KeyPressed;
Setcolor(Yellow);
(* Man hinh toi dan *)
OutTextXY(30,150,'Man hinh toi dan...');
m:=0;
For i:=1 to Kt_bangmau do
 If m < BmChuan[i] then
  m:=Bmchuan[i];
Repeat
 For i:=1 to Kt_Bangmau do
  If BmChuan[i]>0 then Dec(BmChuan[i]);
 Delay(dl);
 Datbangmau(BmChuan);
 Dec(M);
 Delay(dl);
Until m=0;
CloseGraph;
End.
