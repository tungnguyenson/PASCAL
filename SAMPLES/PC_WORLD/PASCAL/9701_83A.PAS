Function FindMode: Word; 
{Ham de tim man hinh dang su dung la Mono hay mau}
Begin
If Mem [$0000:$0449] = 7 then
 FindMode := $B000
Else
 FindMode := $B800;
End;

Procedure SaveScr (Var P : Pointer); 
{Luu lai vung du lieu man hinh}
Begin
 Getmem (P, 4000);
 Move (Mem[FindMonitor:$0000], P^, 4000);
End; 

Procedure RestoreScr (P : Point); 
{Phuc hoi trang thai man hinh}
Begin
 Move (P^, Mem[FindMonitor : $0000], 4000);
End;
