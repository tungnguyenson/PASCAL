(*-------------------------------------------------------------------------*)
(*        Graphics Library for Turbo Pascal version 5.0 or later           *)
(*            Written in Turbo Assembler and Turbo Pascal for DOS          *)
(* Copyright (c) Chau Hong Linh _ S…i g•n University _ All rights reserved *)
(*-------------------------------------------------------------------------*)

{$F+}
Unit ASMGraph;

(*-------------------------*)
Interface
(*-------------------------*)
Uses Crt;
Const
   GraphOn:Word=0;
   GraphOff:Word=1;

Procedure SetVideo(Vid,Dr:Word);
{ Set Video Mode and turn Graphics On or Off }

Procedure WritePixel(Col,Row:Word;Color:Byte);
{ Draw a pixel at column Col,row Row with color Color }

Function  ReadPixel(Col,Row:Word):Byte;
{ Return color of pixel at column Col,row,Row }

Procedure WriteLine(X1,Y1,X2,Y2:Integer;Color:Byte);
{ Draw a line from (X1,Y1) to (X2,Y2) with color Color }

Procedure WriteRectangle(X1,Y1,X2,Y2:Word;Color:Byte);
{ Draw a rectangle with Top Left (X1,Y1) and Right Bottom (X2,Y2) }

Procedure Circle(xc,yc,r:integer;Color:Byte);
{ Draw a circle with center (xc,yc),radius r,using Color }

Procedure Ellipse(xc,yc,a,b:real;Color:Byte);
{ Draw an ellipse with center (xc,yc),Horizon radius a,Vertical radius b }

Procedure FillEllipse(xc,yc,a,b:real;Color:Byte);
{ Draw an ellipse with center (xc,yc),Horizon radius a,Vertical radius b
  and fill it with Color }

Procedure Bar(x1,y1,x2,y2:word;color:Byte);
{ Draw a Bar using the Color }

Procedure Bar3D(x1,y1,x2,y2,Depth:word;color:Byte);
{ Draw a 3-D Bar using the Color }

Procedure GoXY(X,Y:Byte);
{ Move Charracter cursor to (X,Y) }

Function GetMaxX:Word;
{ Return Max of Horizontal Resolution in Graphics Mode in pixels }

Function GetMaxY:Word;
{ Return Max of Vertical Resolution in Graphics Mode in pixels }

Procedure FloodFill(x,y:integer;Color:Byte);
{           Fill the area which the point (x,y) belongs to          }
{ Warning : It doesn't work on super hight resolution
because of function GetMaxX }

Procedure ClearScr(X1,Y1,X2,Y2,Color:Byte);
{ Clear the Window (X1,Y1,X2,Y2) with Color }
{ Notes : X1,Y1,X2,Y2 are Charracter window coordinates }


(*-------------------------*)
Implementation
(*-------------------------*)
Procedure SetVideo(Vid,Dr:Word);External;
Procedure WritePixel(Col,Row:Word;Color:Byte);External;
Function  ReadPixel(Col,Row:Word):Byte;External;
Procedure GoXY(X,Y:Byte);External;
Procedure ClearScr(X1,Y1,X2,Y2,Color:Byte);External;
{$L SetVid }
(*-------------------------*)
Procedure WriteLine(X1,Y1,X2,Y2:Integer;Color:Byte);
Var dx,dy,i,ix,iy,x,y,temp:integer;
    inc,plotx,ploty:integer;
Begin
   dx:=X2-X1;
   dy:=Y2-Y1;
   ix:=Abs(dx);
   iy:=Abs(dy);
   If ix>=iy then inc:=ix
   Else inc:=iy;
   plotx:=x1;
   ploty:=y1;
   x:=0;
   y:=0;
   WritePixel(plotx,ploty,Color);
   i:=0;
   While i<=inc do begin
      x:=x+ix;
      y:=y+iy;
      If x>inc then begin
         x:=x-inc;
         If dx>0 then temp:=1
         Else If dx=0 then temp:=0
              Else temp:=-1;
         plotx:=plotx+temp
      End;{If}
      If y>inc then begin
         y:=y-inc;
         If dy>0 then temp:=1
         Else If dy=0 then temp:=0
              Else temp:=-1;
         ploty:=ploty+temp
      End;{If}
      WritePixel(plotx,ploty,Color);
      i:=i+1;
   End;{While}
End;
(*-------------------------*)
Procedure WriteRectangle(X1,Y1,X2,Y2:Word;Color:Byte);
Begin
   WriteLine(X1,Y1,X2,Y1,Color);
   WriteLine(X2,Y1,X2,Y2,Color);
   WriteLine(X2,Y2,X1,Y2,Color);
   WriteLine(X1,Y2,X1,Y1,Color);
End;
(*-------------------------*)
Function GetMaxX:Word;
Begin
   Case Mem[0:$0449] of
      4,5,$D,$13         :GetMaxX:=319;
      6,$E,$F,$10,$11,$12:GetMaxX:=639;
      Else                GetMaxX:=0;
   End;
End;
(*-------------------------*)
Function GetMaxY:Word;
Begin
   Case Mem[0:$0449] of
      4,5,6,$D,$E,$13:GetMaxY:=199;
      $11,$12        :GetMaxY:=479;
      $F,$10         :GetMaxY:=349;
      Else            GetMaxY:=0;
   End;
End;
(*-------------------------*)
Procedure Ellipse(xc,yc,a,b:real;Color:Byte);
  var p:real;
  x,y:real;
(*--------------------------*)
    procedure dxung;
    Begin
       Writepixel(round(xc+x),round(yc+y),Color);
       Writepixel(round(xc-x),round(yc+y),Color);
       Writepixel(round(xc-x),round(yc-y),Color);
       Writepixel(round(xc+x),round(yc-y),Color);
    end;
 begin
      x:=0;
      y:=b;
      p:=2*(sqr(b)/sqr(a))-2*b+1;
      while ((sqr(b)/sqr(a))*(x/y)<=1 ) do
         begin
            dxung;
            if p<0 then
             p:=p+2*((sqr(b)/sqr(a))*(2*x+3))
            else begin
                p:=p-4*y+2*(sqr(b)/sqr(a))*(2*x+3);
                y:=y-1;
                end;
                x:=x+1;
         end;
       y:=0;
       x:=a;
       p:=2*(sqr(a)/sqr(b))-2*a+1;
      while ((sqr(a)/sqr(b))*(y/x) <1 ) do
         begin
           dxung;
            if p<0 then
             p:=p+2*((sqr(a)/sqr(b))*(2*y+3))
             else begin
                  p:=p-4*x+2*(sqr(a)/sqr(b))*(2*y+3);
                  x:=x-1;
                  end;
                y:=y+1;
         end;
  end;
(*-------------------------*)
Procedure Circle(xc,yc,r:integer;Color:Byte);
Var
    dteta,teta,c1,c2,asp:real;
    xold,yold,x,y,mx,my : real;
    n,i:integer;
Begin
  mx:=GetMaxX+1;
  my:=GetMaxY+1;
  asp:=480/(640/mx)/my;
  If asp<1 then asp:=1/asp;
  n:=round(2*pi*r);
  dteta:=2*pi/n;
  For i:=1 to n do  begin
    teta:=dteta*i;
    xold:=(xc +r*cos(teta))*asp;
    yold:=yc +r*sin(teta);
    x:=(xold-xc)*cos(dteta)-(yold-yc)*sin(dteta)+xc;
    y:=(xold-xc)*sin(dteta)+(yold-yc)*cos(dteta)+yc ;
    WriteLine(round(xold),round(yold),round(x),round(y),Color);
   End;
End;
(*-------------------------*)
Procedure FloodFill(x,y:integer;Color:Byte);
Type
   StPtr=^Stp;
   Stp=Array[1..32767] of integer;
Var
    Px,Py:StPtr;
    Top,plotx,ploty:integer;
    MaxX,MaxY:Word;
    DotColor:Byte;
    Done:Boolean;
Begin
   New(Px);
   New(Py);
   Top:=1;
   Px^[Top]:=x;
   Py^[Top]:=y;
   MaxX:=GetMaxX;
   MaxY:=GetMaxY;
   DotColor:=ReadPixel(x,y);
   Repeat
   Repeat
      plotx:=Px^[Top];
      ploty:=Py^[Top];
      WritePixel(plotx,ploty,Color);
      Dec(Top);
      If (plotx+1<=MaxX) AND (ReadPixel(plotx+1,ploty)=DotColor) then begin
         Inc(Top);
         Px^[Top]:=plotx+1;
         Py^[Top]:=ploty;
      End;
      If (plotx-1>=0) AND (ReadPixel(plotx-1,ploty)=DotColor) then begin
         Inc(Top);
         Px^[Top]:=plotx-1;
         Py^[Top]:=ploty;
      End;
      If (ploty+1<=MaxY) AND (ReadPixel(plotx,ploty+1)=DotColor) then begin
         Inc(Top);
         Px^[Top]:=plotx;
         Py^[Top]:=ploty+1;
      End;
      If (ploty-1>=0) AND (ReadPixel(plotx,ploty-1)=DotColor)then begin
         Inc(Top);
         Px^[Top]:=plotx;
         Py^[Top]:=ploty-1;
      End;
   Until (Top=0) OR (Top=32767);
   If Top=32767 then begin
      Done:=False;
      Top:=1;
      Px^[Top]:=Px^[32767];
      Py^[Top]:=Py^[32767];
   End
   Else Done:=True;
   Until Done;
   Dispose(Py);
   Dispose(Px);
End;
(*-------------------------*)
Procedure FillEllipse(xc,yc,a,b:real;Color:Byte);
Var p:real;
  x,y:real;
(*------------------------*)
    procedure Dxung;
    Begin
       WriteLine(round(xc+x),round(yc+y),round(xc-x),round(yc+y),Color);
       WriteLine(round(xc-x),round(yc-y),round(xc+x),round(yc-y),Color);
    End;

Begin
      x:=0;
      y:=b;
      p:=2*(sqr(b)/sqr(a))-2*b+1;
      while ((sqr(b)/sqr(a))*(x/y)<=1 ) do
         begin
            Dxung;
            if p<0 then
             p:=p+2*((sqr(b)/sqr(a))*(2*x+3))
            else begin
                p:=p-4*y+2*(sqr(b)/sqr(a))*(2*x+3);
                y:=y-1;
                end;
                x:=x+1;
         end;
       y:=0;
       x:=a;
       p:=2*(sqr(a)/sqr(b))-2*a+1;
      while ((sqr(a)/sqr(b))*(y/x) <1 ) do
         begin
           Dxung;
            if p<0 then
             p:=p+2*((sqr(a)/sqr(b))*(2*y+3))
             else begin
                  p:=p-4*x+2*(sqr(a)/sqr(b))*(2*y+3);
                  x:=x-1;
                  end;
                y:=y+1;
         end;
End;
(*-------------------------*)
Procedure Bar(x1,y1,x2,y2:Word;Color:Byte);
Var i:Word;
Begin
   For i:=y1 to y2 do WriteLine(x1,i,x2,i,Color)
End;
(*-------------------------*)
Procedure Bar3D(x1,y1,x2,y2,Depth:word;color:Byte);
Var i:Word;
Begin
   Bar(x1,y1,x2,y2,color);
   For i:=x1 to x2 do
      WriteLine(i,y1,i+Depth,y1-Depth,Color);
   For i:=y1 to y2 do
      WriteLine(x2,i,x2+Depth,i-Depth,Color);
   WriteLine(x1,y1,x2,y1,Color+1);
   WriteLine(x2,y1,x2,y2,Color+1);
End;
(*-------------------------*)
END.