{$r+}
uses dos, crt;
const
    dapso: array['1'..'6'] of integer=(19,49,98,497,997,9);
    diem : array['1'..'6'] of real=(2.5,2.5,2,2,1,0.5);
    finp:string='BL2.INP';
    fout:string='BL2.OUT';
type
   vecto = array[1..1200] of integer;
var
   a,ind: vecto;
   n,k : integer;
   chon: char;
   ds:real;

procedure Indl;
var i:integer;
begin
    writeln('************************************');
    writeln('******   I N P U T    D A T   ******');
    writeln('************************************');
    writeln('Day so da cho gom ',n,' phan tu');
    for i:=1 to n do write(a[i]:4);writeln;
    writeln('************************************');
    readln;
end;

procedure Nhapdl;
var i:integer;
    f: text; fn:string;
begin
    writeln;
    write('                Cho ten file: BL2.IN');
    chon:=readkey;writeln(chon);
    fn:='BL2.IN'+chon;
    assign(f,fn);reset(f);
    readln(f,n,k);
    for i:=1 to n do read(f,a[i]);
    close(f);
    writeln('                 n = ',n,'   k = ',k);
    writeln;
    writeln('       =====================================');
    writeln;
end;

procedure Kiemtra;
var i,kt:integer;
    sum: longint;
    f:text;
begin
    assign(f,fout);reset(f);
    readln(f,kt);
    for i:=1 to kt do read(f,ind[i]);
    close(f);
    ds:=0;
    write('* Kiem tra chi so cua day con   ===> ');
    for i:=1 to kt do
       if (ind[i]>n) or (ind[i]<=0) then
       begin
          writeln;
          writeln('*************************************************');
          writeln('****  ERROR  Khong co phan tu voi chi so ',ind[i]);
          writeln('*************************************************');
          readln; exit;
       end;
    writeln(' OK!');
    sum:=0;
    for i:=1 to kt do sum:=sum+a[ind[i]];
    writeln('         Tong cac phan tu cua day con: ',sum);
    write('* Kiem tra tinh chia het cho ',k:2,' ===> ');
    if sum mod k <> 0 then
    begin
        writeln;
        writeln('********************************************');
        writeln('****   ERROR: Tong khong chia het cho ',k);
        writeln('********************************************');
        readln; exit;
    end;
    writeln(' OK!');
    writeln('* Kiem tra tinh toi uu: ');
    writeln('        So phan tu cua day con h/s tim: ',kt);
    writeln('                               Dap so : ',dapso[chon]);
    if kt < dapso[chon] then
    begin
        case chon of
             '1':
                 begin
                     if kt>6 then ds:=0.5;
                     if kt>8 then ds:=1;
                     if kt>11 then ds:=1.5;
                     if kt>15 then ds:=2.0;
                 end;
             '2':
                 begin
                     if kt>10 then ds:=0.5;
                     if kt>20 then ds:=1;
                     if kt>30 then ds:=1.5;
                     if kt>40 then ds:=2.0;
                 end;
             '3':
                 begin
                     if kt>20 then ds:=0.5;
                     if kt>50 then ds:=1;
                     if kt>80 then ds:=1.5;
                 end;
             '4':
                 begin
                     if kt>350 then ds:=0.5;
                     if kt>390 then ds:=1;
                     if kt>450 then ds:=1.5;
                 end;
        end
    end
    else
    begin
        writeln;
        writeln('          **********************************');
        writeln('          ****      P E R F E C T       ****');
        writeln('          **********************************');
        writeln;
        ds:=diem[chon];
    end;
end;

BEGIN
    Textcolor(white);
    Textbackground(Black);
    clrscr;
    writeln('       CHUONG TRINH CHAM BAI 2 KHOI B VOI 98');
    writeln('       =====================================');
    Nhapdl;
    Kiemtra;
    writeln;
    writeln('==================================================');
    writeln('               Diem de nghi: ',ds:1:2);
    writeln('==================================================');
    readln;
END.
