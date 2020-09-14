(*....  Chuo+ng  tri`nh  truy  xua^'t  CMOS  tru+.c  tie^'p
tu+`  da^'u nha+'c DOS....*)

(*... Nguo+`i la^.p: Pha.m Va+n Ha?i  
Bo^.  Mo^n Tin Ho.c - DH Thuy? sa?n Nha Trang *)

Const

 CmosMin =$0E;

 CmosMax =$3F;

Var

 i,Value :Byte;

 f       :File of Byte;

 Fn,Tmp  :String;        {Te^n ta^.p tin du`ng  truy xua^'t}

 ID :Char; {
                     R,r: ddo.c tho^ng tin tu+` ddia~
                     W,w: Ghi tho^ng tin le^n ddia~ }

Procedure ReadCmos(CmosAddr:Byte);

Var

 AlReturn:Byte;

Begin

Asm

 Mov      AL,     CmosAddr

 Out      70h,    AL

 In       AL,     71h

 Mov      ALReturn,       AL

End;

Value:=ALReturn;

End;


Procedure WriteCmos(CmosAddr,CmosValue:Byte);

Begin

Asm

 Mov      AL,     CmosAddr

 Out      70h,    AL

 Mov      AL,     CmosValue

 Out      71h,    AL

End;

End;

BEGIN

If ParamCount <> 2 then
 Halt(1); { ddoi` hoi? 2 tham so^' do`ng le^.nh }

{Kiem tra tham so  thu 1 de quy dinh
viec doc  tu file hay ghi ra file}

Tmp:=Copy(ParamStr(1),1,1);

ID:=Tmp[1];

ID:=Upcase(ID);

If(ID<>'R') And (ID<>'W') then Halt(1);

{Nha^.n ten tap tin tu tham so thu 2,
phan mo rong mac dinh l… CMS}

Fn:=ParamStr(2);

If Pos('.',Fn)= 0 then {khong co phan mo rong}

 Fn:=Fn +'.CMS';

Assign(f,Fn);

If ID='W' then {Ghi thong tin hien tai cua CMOS len dia}

Begin

 ReWrite(f);

 For i:=CmosMin to CmosMax do

 Begin

  ReadCmos(i);

  Write(f,Value);

 End;

End

Else
{doc thong tin tu file ghi ra CMOS}

Begin

{$i-}

 Reset(f);

{$i+}

 If ioResult <> 0 then

 Begin

  Writeln('File not found, '+Fn+'!');

  Halt(1);

 End;

 For i:=CmosMin to CmosMax do
 {doc thong tin tu dia vao CMOS}

 Begin

  Read(f,Value);

  WriteCmos(i,Value);

 End;

End;

Close(f);

END.