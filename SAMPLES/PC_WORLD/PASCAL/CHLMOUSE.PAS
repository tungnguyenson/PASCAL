Unit Mouse;

(*writen in Turbo Pascal by Death Shadow Group - Go Vap - Sai gon *) 

Interface 
Uses Dos; 
Function MouseInit:Boolean; 
Procedure MouseShow; 
Procedure MouseHide; 
Procedure GetMousePos(Var Mx,My:integer); 
Procedure SetMousePos(Mx,My:Integer); 
Procedure GetBPressInfo(Var Status,Count:integer;Button:integer); 
Procedure GetBRelInfo(Var Status,Count:integer;Button:integer);
Function MouseLPressed :Boolean; 
Function MouseRPressed :Boolean; 
Function MouseLReleased :Boolean; 
Function MouseRReleased :Boolean; 
Procedure SetHMinMax(Min,Max:integer); 
Procedure SetVMinMax(Min,Max:integer); 
Procedure MouseGraphCursor(HotX,HotY:integer; Cursor:Pointer); 
Procedure MouseTextCursor(Attr,MaskA,MaskC: Byte;Form:Char); 
Procedure MouseReset; 
Var Mousei:Boolean; 
(*_____________*) 
Implementation 
(*___________*) 
Procedure MouseTextCursor(Attr,MaskA,MaskC:Byte;Form:Char); 
Var R:Registers; 
Begin 
R.AX:=$A; 
R.BX:=0; 
R.CH:=MaskA; 
R.CL:=MaskC; 
R.DH:=Attr; 
R.DL:=Ord(Form); 
Intr($33,R); 
End; 
(*___________*) 
Procedure MouseGraphCursor; 
Var R:Registers; 
Begin 
R.AX:=9;
R.BX:=HotX;
R.CX:=HotY; 
R.DX:=Ofs(Cursor); 
R.ES:=Seg(Cursor); 
Intr($33,R) 
End; 
(*___________*) 
Procedure MouseReset; 
Var R:Registers; 
Begin 
R.AX:=$21; 
R.BX:=0; 
R.CX:=0; 
R.DX:=0; 
R.SI:=0 ;
R.DI:=0 ;
R.ES:=0 ;
R.DS:=0 ;
Intr($33,R) ;
End; 
(*_______________*) 
Procedure MouseShow; 
Var R:Registers; 
Begin 
R.AX:=1;
R.BX:=0;
R.CX:=0; 
R.DX:=0; 
R.SI:=0;
R.DI:=0;
R.ES:=0; 
R.DS:=0;
Intr($33,R)
End; 
(*_______________*) 
Procedure MouseHide; 
Var R:Registers; 
Begin 
R.AX:=2; 
R.BX:=0; 
R.CX:=0;
R.DX:=0;
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R) ;
End;

(*__________*) 

Procedure GetMousePos(Var Mx,My:integer); 
Var R:Registers; 
Begin 
R.AX:=3; 
R.BX:=0; 
R.CX:=0; 
R.DX:=0; 
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R);
Mx:=R.CX;
My:=R.DX;
End;

(*_____________*) 

Procedure SetMousePos(Mx,My:integer);
Var R:Registers; 
Begin 
R.AX:=4 ;
R.BX:=0; 
R.CX:=Mx; 
R.DX:=My; 
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R);
End;

(*___________*) 

Procedure GetBPressInfo(Var Status,Count:integer;Button:integer);
Var R:Registers; 
Begin 
R.AX:=5; 
R.BX:=Button; 
R.CX:=0; 
R.DX:=0; 
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R);
Status:=R.AX;
Count:=R.BX ;
End;

(*_____________*)

Procedure GetBRelInfo(Var Status,Count:integer;Button:integer);
Var R:Registers;
Begin
R.AX:=6;
R.BX:=Button;
R.CX:=0;
R.DX:=0 ;
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R);
Status:=R.AX;
Count:=R.BX ;
End;

(*___________*)

Procedure SetHMinMax(Min,Max:integer);
Var R:Registers;
Begin
R.AX:=7 ;
R.BX:=0 ;
R.CX:=Min;
R.DX:=Max;
R.SI:=0;
R.DI:=0;
R.ES:=0;
R.DS:=0;
Intr($33,R);
End;

(*____________*)

Procedure SetVMinMax(Min,Max:integer);
Var R:Registers;
Begin
R.AX:=8;
R.BX:=0 ;
R.CX:=Min;
R.DX:=Max;
R.SI:=0;
R.DI:=0;
R.ES:=0 ;
R.DS:=0 ;
Intr($33,R);
End;

(*____________*)

Function MouseInit:Boolean;
Var R:Registers;
Begin
R.AX:=0 ;
R.BX:=0;
R.CX:=0;
R.DX:=0;
R.SI:=0;
R.DI:=0 ;
R.ES:=0 ;
R.DS:=0 ;
Intr($33,R);
if R.AX<>0 then MouseInit:=True
Else MouseInit:=False
End;
(*______________*)
Function MouseLPressed:Boolean;
Var Status,Count:integer;
Begin
GetBPressInfo(Status,Count,0);
If (Status And $1)=$1 then MouseLPressed:=True
Else MouseLPressed:=False
End;
(*_____________________*)
Function MouseLReleased:Boolean;
Var Status,Count:integer;
Begin
GetBRelInfo(Status,Count,0);
If (Status And $1 = 0) AND (Count > 0) then MouseLReleased:=True
Else MouseLReleased:=False 
End; 
(*___________*) 
Function MouseRPressed:Boolean; 
Var Status,Count:integer; 
Begin 
GetBPressInfo(Status,Count,1); 
If (Status And $2)=2 then MouseRPressed:=True 
Else MouseRPressed:=False 
End; 
(*______________*) 
Function MouseRReleased:Boolean; 
Var Status,Count:integer; 
Begin 
GetBRelInfo(Status,Count,1); 
If (Status And $2 =0) AND(Count0) then MouseRReleased:=True 
Else MouseRReleased:=False 
End; 
(*______________*) 
END 