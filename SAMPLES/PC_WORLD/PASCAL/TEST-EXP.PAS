Program Test_Expand;
{
VI DU DUNG CHUONG TRINH EXPAND TRONG PASCAL
}
{$A+,B+,D+,E-,F+,I+,L+,N-,O-,R+,S+,V+}
{$L Expand}
Procedure Expand(Var Src,Dst; Siz:word);external;
{Expand from Source to Dest with Sources Size}
Var
 p,t:pointer;
 r,s:word;
 f:file;
Begin
 Assign(f,'EXAMPLE.CMP');
 Reset(f,1);
 r:=FileSize(f)-2;
 Getmem(t,r);
 BlockRead(f,s,2);
 Getmem(p,s);
 BlockRead(f,t^,r);
 Close(f);
 Expand(t^,p^,s);
 Writeln('Original size: ',s);
 Assign(f,'Example.tst');
 Rewrite(f,1);
 Blockwrite(f,p^,s);
 close(f);
End.
