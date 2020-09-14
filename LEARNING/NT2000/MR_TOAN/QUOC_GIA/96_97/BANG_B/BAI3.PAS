Program son_cot;
Uses crt;
Const max=101;
      fi='bai3.inp';
      Hx:array[1..4]of shortint=(-1,0,1,0);
      Hy:array[1..4]of shortint=(0,1,0,-1);
Var A:array[0..max,0..max]of integer;
    f:text;
    m,n:integer;
Procedure Khoitao;
   Var i,j:integer;
   Begin
       Fillchar(a,sizeof(a),0);
       Assign(f,fi);
       Reset(f);
           Readln(f,m,n);
           For i:=1 to m do
             For j:=1 to n do Read(f,a[i,j]);
       Close(f);
   End;
Procedure Lam_viec;
   Var i,j,dt,k,i1,j1:longint;
   Begin
       dt:=0;
       For i:=1 to m do
         For j:=1 to n do
           If A[i,j]>0 then
           Begin
               dt:=dt+4*A[i,j]+1;
               For k:=1 to 4 do
                 Begin
                     i1:=i+Hx[k]; j1:=j+Hy[k];
                     If A[i,j]>A[i1,j1] then dt:=dt-A[i1,j1] else
                                             dt:=dt-A[i,j];
                 End;
           End;
       Writeln('Dien tich cot can son:',dt);
   End;
Begin
    Clrscr;
    Khoitao;
    Lam_viec;
    Writeln('Dung chuong trinh',#7);
    Readln;
End.