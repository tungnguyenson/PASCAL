uses crt,dos;
type arr1 = array[1..40000] of byte;
     arr2 = array[0..200,0..200] of byte;
const
     dapso: array['1'..'6'] of integer=(7,15,93,92,117,4);
     diem: array['1'..'6'] of real=(2.5,2.5,2,2,1,4);
     fout='BL1.OUT';
     finp='BL1.IN1';
var
   a: array[0..200,0..200] of byte;
   a1: ^arr2;
   row: ^arr1;
   col: ^arr1;
   coloru: array[1..1000] of boolean;
   m,n:integer;
   k: longint;
   fn:string;
   chon: char;

procedure Nhapdl;
var f:text;
    i,j,p,q: integer;
    ik:longint;
begin
     write('Doc tu file BL1.IN');
     chon:=readkey;writeln(chon);
     fn:='BL1.IN'+chon;
     assign(f,fn); reset(f);
     readln(f,m,n,k);
     writeln('Kich thuoc bang: m x n = ',m,' x ',n);
     fillchar(a,sizeof(a),0);
     ik:=0;
     for i:=1 to k do
     begin
         readln(f,p,q);
         a[p,q]:=1;
         ik:=ik+1;
         row^[ik]:=p; col^[ik]:=q;
     end;
     close(f);
     if (m<10) and (n<10) then
     begin
         writeln('*****  INPUT DATA:   BANG VI TRI BONG DEN  ***** ');
         for i:=0 to m do
         begin
             for j:=0 to n do write(a[i,j]:4);
             writeln;
         end;
     end;
end;


procedure Kiemtra;
var i,j,Ncol1,p:integer;
    ik: longint;
    f: text;
    tl,ds:real;
begin
   Nhapdl;
   writeln;
   writeln('=====     KIEM TRA KET QUA TINH TOAN    =====');
   writeln('=====     Ten file: ',fn,'             =====');
   writeln('=============================================');
   assign(f,fout); reset(f);
   readln(f,Ncol1);
   writeln('So mau hoc sinh su dung: ',Ncol1);
   for i:=0 to m do
      for j:=0 to n do  a1^[i,j]:=0;
   for ik:=1 to k do
   begin
       readln(f,p);
       a1^[row^[ik],col^[ik]]:=p;
   end;
   close(f);
   if (m<10) and (n<10) then
   begin
      writeln('Cach to mau tim duoc: ');
      for i:=0 to m do
      begin
         for j:=0 to n do  write(a1^[i,j]:4);
         writeln;
      end;
   end;
   writeln;
   write('****   Kiem tra chi so mau tren bang  : ');
   for i:=0 to m do
     for j:=0 to n do
        if a1^[i,j]>Ncol1 then
        begin
            writeln;
            writeln('********************************');
            writeln('ERROR:  Su dung mau voi chi so lon hon so mau thong bao!');
            writeln('********************************');
            readln;exit;
        end;
   writeln('OK!');
   writeln;
   write('****   Kiem tra cac vi tri can gan mau: ');
   for i:=0 to m do
     for j:=0 to n do
        if (a[i,j]>0) and (a1^[i,j]=0) then
        begin
            writeln;
            writeln('********************************');
            writeln('ERROR:  Den o vi tri (',i,', ',j,' ) khong duoc gan mau!');
            writeln('********************************');
            readln;exit;
        end;
   writeln('OK!');
   writeln;
   write('****   Kiem tra cac vi tri gan mau    : ');
   for i:=0 to m do
     for j:=0 to n do
        if (a[i,j]=0) and (a1^[i,j]<>0) then
        begin
            writeln;
            writeln('********************************');
            writeln('ERROR:  Gan mau cho vi tri (',i,', ',j,' ) khong co den!');
            writeln('********************************');
            readln;exit;
        end;
   writeln('OK!');
   writeln;
   write('****   Kiem tra mau tren cac dong     : ');
   for i:=0 to m do
   begin
       for j:=1 to Ncol1 do Coloru[j]:=false;
       for j:=0 to n do
       begin
          p:=a1^[i,j];
          if (p<>0) then
          begin
              if Coloru[p] then
              begin
                 writeln;
                 writeln('********************************');
                 writeln('ERROR: Dung lai mau ',p,' o dong ',i);
                 writeln('********************************');
                 readln;exit;
              end
              else Coloru[p]:=true;
          end;
       end;
   end;
   writeln('OK!');writeln;
   write('****   Kiem tra mau tren cac cot      : ');
   for j:=0 to n do
   begin
       for i:=1 to Ncol1 do Coloru[i]:=false;
       for i:=0 to m do
       begin
          p:=a1^[i,j];
          if (p<>0) then
          begin
              if Coloru[p] then
              begin
                 writeln;
                 writeln('********************************');
                 writeln('ERROR: Dung lai mau ',p,' o cot ',j);
                 writeln('********************************');
                 readln;exit;
              end
              else Coloru[p]:=true;
          end;
       end;
   end;
   writeln('OK!');writeln;
   writeln('***************************************');
   writeln('****    KET QUA KIEM TRA GAN MAU   ****');
   writeln('Khong phat hien sai sot trong gan mau');
   writeln('***************************************');
   writeln;
   writeln('************************************');
   writeln('*****   KIEM TRA TINH TOI UU   *****');
   if Ncol1>dapso[chon] then
   begin
      writeln('So mau tim duoc khong dung dap so');
      writeln('So mau hoc sinh tim duoc: ',Ncol1);
      writeln('                  dap so: ',dapso[chon]);
{      tl:= Ncol1*1.0/(dapso[chon]*1.0);
      writeln('****   Ty le tuong doi Fhs/Fopt: ',tl:1:2);}
      ds:=0;
      case chon of
         '1':
             begin
                    if (Ncol1 >9)  then ds:=0.5;
                    if (Ncol1<=9)  then ds:=1.0;
                    if (Ncol1<=8)  then ds:=1.5;
             end;
         '2':
             begin
                    if (Ncol1>19)  then ds:=0.5;
                    if (Ncol1<=19)  then ds:=1.0;
                    if (Ncol1<=17)  then ds:=1.5;
             end;
         '3':
             begin
                    if (Ncol1>120)  then ds:=0.5;
                    if (Ncol1<=120)  then ds:=1.0;
                    if (Ncol1<=100)  then ds:=1.5;
             end;
         '4':
             begin
                    if (Ncol1 >120)  then ds:=0.5;
                    if (Ncol1<=120)  then ds:=1.0;
                    if (Ncol1<=100)  then ds:=1.5;
             end;
       end;
   end
   else
   begin
      writeln('*****     PERFECT! PERFECT!    *****');
      writeln('************************************');
      ds:=diem[chon];
   end;
   writeln('############################################');
   writeln('Diem de nghi cho test BL4.IN',chon,': ',ds:4:1);
   writeln('############################################');
   readln;
end;

BEGIN
    New(row);new(col);New(a1);
    clrscr;
    writeln('      CHUONG TRINH GIAI BAI 1 KHOI A VOI 98');
    writeln('      =====================================');
    Kiemtra;
END.



4   5   13
1  1
1  2
1  5
3  1
4  1
3  2
2  3
3  3
4  3
2  4
4  4
2  5
4  5
