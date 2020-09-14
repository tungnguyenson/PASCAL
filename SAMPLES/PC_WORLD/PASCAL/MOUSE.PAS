Unit Mouse;
Interface
Uses Dos;
Type
 St=String[30];
Procedure MouseGetVersion(Var Ver:Word;var IRQ:Byte;var Sort:St);
Procedure MouseGShapeSet(ShapeName:St);
Procedure MouseTShapeSet(Sort,Part1,Part2:Word);
Procedure MouseSetLimit(HMin,HMax,VMin,VMax:Integer);
Procedure MouseGetPreInfo(Var State,Count,Button:Integer);
Procedure MouseGetRelInfo(Var State,Count,Button:Integer);
Procedure MouseGetPosition(Var x,y:Integer);
Procedure MouseSetPosition(x,y:Integer);
Function MouseLPressed:Boolean;
Function MouseRPressed:Boolean;
Function MouseMPressed:Boolean;
Function MouseLReleased:Boolean;
Function MouseRReleased:Boolean;
Function MouseMReleased:Boolean;
Procedure MouseReset;
Function MouseInitiated:Boolean;
Procedure MouseShow;
Procedure MouseHide;
Implementation
Var
 i:Integer;
 R:Registers;
Procedure MouseReset;
Begin
 R.AX:=$21;
 R.BX:=0;
 R.CX:=0;
 R.DX:=0;
 INTR($33,R);
End;
Function MouseInitiated:Boolean;
Begin
 R.AX:=0;
 INTR($33,R);
 If R.AX<>0 then MouseInitiated:=True
 Else MouseInitiated:=False;
End;
Procedure MouseHide;
Begin
 R.AX:=2;
 INTR($33,R);
End;
Procedure MouseShow;
Begin
 R.AX:=1;
 INTR($33,R);
End;
Procedure MouseGetPreInfo(Var State,Count,Button:Integer);
Begin
 R.AX:=5;
 R.BX:=BUTTON;
 INTR($33,R);
 State:=R.AX;
 Count:=R.BX;
End;
Procedure MouseGetRelInfo(Var State,Count,Button:Integer);
Begin
 R.AX:=6;
 R.BX:=Button;
 INTR($33,R);
 State:=R.AX;
 Count:=R.BX;
End;
Procedure MouseGShapeSet(ShapeName:St);
Type
  CellGrid=Array[1..16,1..2] of byte;
  AllGrid=Array[1..32,1..2] of byte;
  Shape=Record
   Name:String[30];
   Sh:CellGrid;
   Xpoint,Ypoint:Integer;
  End;
Var
 TmpShape:Shape;
 F:File of shape;
 AndXorGrid:AllGrid;
 i,j:Integer;
Begin
 {$I-}
 Assign(F,'C:\TURBO\BIN\MSHAPE.DAT');
 Reset(F);
 {$I+}
 If IOResult<>0 then halt;
 Repeat
  Read(F,TmpShape);
 Until TmpShape.Name=ShapeName;
 For i:=17 to 32 do for j:=1 to 2 do AndXorGrid[i,j]:=TmpShape.Sh[i-16,3-j];
 For i:=1 to 16 do for j:=1 to 2 do AndXorGrid[i,j]:=Not TmpShape.Sh[i,3-j];
 With R do begin
  ES:=SEG(AndXorGrid);
  DX:=OFS(AndXorGrid);
  AX:=$0009;
  BX:=TmpShape.Ypoint;
  CX:=TmpShape.Xpoint;
 End;
 INTR($33,R);
 Close(F);
End;
Procedure MouseTShapeSet(Sort,Part1,Part2:Word);
Begin
 R.BX:=Sort;
 R.AX:=$000A;
 R.CX:=Part1;
 R.DX:=Part2;
 INTR($33,R);
End;
Function MouseLPressed:Boolean;
Var
 State,Count,Button:Integer;
Begin
 Button:=0;
 MouseGetPreInfo(State,Count,Button);
 If (State and 1)=1 then MouseLPressed:=True
 Else MouseLPressed:=False;
End;
Function MouseLReleased:Boolean;
Var
 State,Count,Button:Integer;
Begin
 Button:=0;
 MouseGetRelInfo(State,Count,Button);
 If (State and 1)=1 then MouseLReleased:=True
 Else MouseLReleased:=False;
End;
Function MouseRPressed:Boolean;
Var
 State,Count,Button:Integer;
Begin
 Button:=1;
 MouseGetPreInfo(State,Count,Button);
 If (State and 2)=2 then MouseRPressed:=True
 Else MouseRPressed:=False;
End;
Function MouseRReleased:Boolean;
Var
 State,Count,Button:Integer;
Begin
 Button:=1;
 MouseGeTRelInfo(State,Count,Button);
 If (State and 2)=2 then MouseRReleased:=True
 Else MouseRReleased:=False;
End;
Function MouseMPressed:Boolean;
Var
 State,Count,Button:Integer;
Begin
 Button:=2;
 MouseGetPreInfo(State,Count,Button);
 If (State and 4)=4 then MouseMPressed:=True
 Else MouseMPressed:=FalSe;
End;
Function MouseMReleased;
Var
 State,Count,Button:Integer;
Begin
 Button:=2;
 MouseGetRelInfo(State,Count,Button);
 If (State and 4)=4 then MouseMReleaSed:=True
 Else MouseMReleased:=False;
End;
Procedure MouseGetPosition(Var x,y:Integer);
Begin
 R.AX:=3;
 INTR($33,R);
 x:=R.CX;
 y:=R.DX;
End;
Procedure MouseSetPosition(x,y:Integer);
Begin
 R.AX:=4;
 R.CX:=x;
 R.DX:=y;
 INTR($33,R);
End;
Procedure MouseSetLimit(HMin,HMax,VMin,VMax:Integer);
Begin
 R.AX:=7;
 R.CX:=HMin;
 R.DX:=HMax;
 INTR($33,R);
 R.AX:=8;
 R.CX:=VMin;
 R.DX:=VMax;
 INTR($33,R);
End;
Procedure MouseGetVersion(Var Ver:Word;var IRQ:Byte;var Sort:St);
Var TmpSort:Byte;
Begin
 R.AX:=$0024;
 INTR($33,R);
 Ver:=R.BX;
 TmpSort:=R.CH;
 IRQ:=R.CL;
 Case TmpSort of
  1:Sort:='Bus Mouse';
  2:Sort:='Serial Mouse';
  3:Sort:='Inport Mouse';
  4:Sort:='PS/2 Mouse';
  5:Sort:='HP Mouse';
 End;
End;
End.


