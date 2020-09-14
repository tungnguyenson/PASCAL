Program Test_compress;
{
VI DU DUNG CHUONG TRINH COMPRESS TRONG PASCAL
}
{$A+,B+,D+,E-,F+,I+,L+,N-,O-,R+,S+,V+}
{$L Compress}
Function Compress(Var Src,Dst; Siz:word):word;external;
{Compresses from Source to Dest with Sources Size]}
Var
 p,t:pointer;
 r,s:word;
 f:file;
Begin
 Assign(f,'EXAMPLE.TXT');
 Reset(f,1);
 s:=FileSize(f);
 Getmem(p,s);
 Getmem(t,s);
 BlockRead(f,t^ ,s);
 Close(f);
 r:=Compress(t^ ,p^ , s);
 Writeln('Compress size: ',r);
 Assign(f,'Example.cmp');
 Rewrite(f,1);
 Blockwrite(f,s,2);
 Blockwrite(f,p^,r);
 close(f);
End.
