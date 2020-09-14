    {Chuong trinh CMOS_Info }
    program CMOS_Info; 
    var w:byte; 

    function rcmos(diachi:byte):byte; 
    begin 
    port[$70]:=diachi; 
    rcmos:=port[$71]; 
    end; 
    
    function dc2hx(socandoi:byte):string; 
    begin 
    {Vi cac so cua dong ho deu luu duoi dang Hex nen phai doi lai} 
    dc2hx=chr(48 + socandoi div 16) + chr(48 + socandoi mod 16); 
    end; 

    begin 
    writeln('Chuong trinh doc cau hinh may tinh tu CMOS RAM'); 
    writeln('Viet boi Vuong Quang Khai 1/1/1996'); 
    writeln('Time:', dc2hx(rcmos(4)), ':', dc2hx(rcmos(2)), ':', dc2hx(rcmos(0))); 
    writeln('Date:', dc2hx(rcmos(7)), '/', dc2hx(rcmos(8)), '/', dc2hx(rcmos(9))); 
    w:=rcmos($10); 
    write('Kieu cua dia mem thu nhat: '); 
    case (w and 240) shr 4 of 
    0:writeln('khong co'); 
    1:writeln('360 Kb'); 
    2:writeln('1.2 Mb'); 
    3:writeln('720 Kb'); 
    4:writeln('1.4 Mb'); 
    end; 
    write('Kieu cua dia mem thu hai:'); 
    case w and 15 of 
    0:writeln('khong co'); 
    1:writeln('360 Kb'); 
    2:writeln('1.2 Mb'); 
    3:writeln('720 Kb'); 
    4:writeln('1.4 Mb'); 
    end; 
    write('Kieu cua dia cung thu nhat:'); 
    if rcmos($19)=0 
    then writeln('khong co') 
    else writeln(rcmos($19)) 
    write('Kieu cua dia cung thu hai:'); 
    if rcmos($1A)=0 
    then writeln('khong co') 
    else writeln(rcmos($1A)) 
    writeln('Bo nho co so: ', rcmos($16)*256 + rcmos($15)); 
    writeln('Bo nho mo rong: ', rcmos($17) * 256 + rcmos($18)); 
    writeln('Nhan ENTER de thoat khoi chuong trinh'); 
    readln; 
    end. 

