{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

uses crt, graph;
const
  maxdiem = 255;
  eps = 1e-6;
type
  kieudiem = record
               x, y: real;
             end;
  mangdiem = array[1..maxdiem] of kieudiem;
  daydiem  = record
               sodiem: integer;
               diem  : mangdiem;
             end;
var S: daydiem;
    motpi, haipi: real;
    nr, nkq: integer;
    ind, kq: array[1..maxdiem] of integer;
    f: text;
    ten: string;

  function Nghieng(var P, A: kieudiem): real;
  { tinh goc nghieng cua tia PA, -Pi < ... <= Pi }
  var dx, dy, anfa: real;
  begin
    dx := A.x-P.x; dy := A.y-P.y;
    if abs(dx) < eps then
      if dy > 0 then Nghieng := motpi/2
      else           Nghieng := -motpi/2
    else
    begin
      anfa := ARCTAN(dy/dx);
      if dx > 0 then Nghieng := anfa
      else if dy >= 0 then Nghieng := anfa+motpi
           else            Nghieng := anfa-motpi;
    end;
  end;

  function Goc(var A, P, B: kieudiem): real;
  { tinh goc tu tia AP toi tia PB, -Pi < ... <= Pi }
  var phi: real;
  begin
    phi := Nghieng(P, B)-Nghieng(A, P);
    if abs(phi+motpi) < eps then phi := motpi
    else
      if abs(phi) > motpi then phi := phi-haipi*abs(phi)/phi;
    Goc := phi;
  end;

    procedure DocData;
    var i: integer;
    begin
      write('Ten file du lieu: '); readln(ten);
      if ten = '' then exit;
      assign(f, ten); reset(f);
      with S do
      begin
        readln(f, sodiem);
        for i := 1 to sodiem do read(f, diem[i].x, diem[i].y);
      end;
      close(f);
      motpi := pi;
      haipi := motpi*2;
    end;

    procedure DocKq;
    var i: integer;
    begin
      ten := 'CAY.OUT';
      assign(f, ten); reset(f);
      readln(f, nkq);
      for i := 1 to nkq do read(f, kq[i]);
      close(f);
    end;

(***********************************************************************
 Thuat toan tim bao loi (cho phep co diem khac nut nam tren bien)
  1. khoi dong:
          + S la day diem nhap
          + danh dau chua xet cac phan tu cua S
  2. kiem tra stop:
          + neu so phan tu cua S < 3 thi stop
  3. tim bao loi cua tap S:
          a/ tim phan tu P cua S dat y min, neu co nhieu phan tu nhu the
          thi tim P la phan tu co x nho nhat. Dat F := P.
          b/ xac dinh A sao cho tia AP la tia nam ngang
          c/ tim trong cac phan tu khac  P  chua danh dau, phan tu Q co
             Goc(A, P, Q) dat min, neu co nhieu phan tu nhu the thi xac
             dinh Q la phan tu xa P nhat. Danh dau Q. Noi PQ. Neu Q = F
             thi ra (xong mot bao loi), trai lai sang d/
          d/ dat A := P, dat P := Q, quay lai c/
************************************************************************)

  procedure ThucHien;
  var
      ChuaXet: array[1..maxdiem] of boolean;
      i, cmin, cmax, dmin, dmax: integer;
      xmin, xmax, ymin, ymax, px, py: real;
      ch: char;
      st3: string[3];
      color: word;

      procedure InitG;
      var grd, grm: integer;
      begin
        grd := detect;
        InitGraph(grd, grm, 'C:\TP\bgi');
        cmin := 70; cmax := getmaxx-40;
        dmin := 70; dmax := getmaxy-40;
        SetTextJustify(centertext, centertext);
{        SetTextStyle(SmallFont, HorizDir, 4);
        Outtextxy(GetMaxX div 2, GetMaxY-Textheight('H'),
                  'Go 1 phim de tiep tuc ...');}
        directvideo := false;
        color := lightred;
      end;

      procedure TinhTyle;
      var i: integer;
          u, v: real;
      begin
        xmin := 1e+37; xmax := -xmin;
        ymin := xmin; ymax := xmax;
        with S do
        for i := 1 to sodiem do
        begin
          u := diem[i].x; v := diem[i].y;
          if u < xmin then xmin := u;
          if v < ymin then ymin := v;
          if u > xmax then xmax := u;
          if v > ymax then ymax := v;
        end;
        if abs(xmax-xmin) < eps then
        begin
          xmax := xmax+1; xmin := xmin-1;
        end;
        if abs(ymax-ymin) < eps then
        begin
          ymax := ymax+1; ymin := ymin-1;
        end;
        px := (cmax-cmin)/(xmax-xmin);
        py := (dmin-dmax)/(ymax-ymin);
      end;

      procedure DatMau(color: word);
      begin
        SetColor(color);
        SetFillStyle(SolidFill, color);
      end;

      procedure VeDiem(var A: kieudiem; var i: integer);
      var c, d: integer;
      begin
        c := round(px*(A.x-xmin)+cmin);
        d := round(py*(A.y-ymin)+dmax);
        fillellipse(c, d, 7, 7);
        setcolor(0);
        str(i, st3); OutTextXY(c, d, st3);
        setcolor(15);
      end;

      procedure Noi(var A, B: kieudiem);
      var c, d, u, v: integer;
      begin
        c := round(px*(A.x-xmin)+cmin);
        d := round(py*(A.y-ymin)+dmax);
        u := round(px*(B.x-xmin)+cmin);
        v := round(py*(B.y-ymin)+dmax);
        setcolor(color); Line(c, d, u, v); setcolor(15);
      end;

      procedure VeKq;
      var i, j, k: integer;
      begin
        { Noi(P, Q);
          VeDiem(Q, j);}
        for i := 1 to nkq-1 do
        begin
          DatMau(color);
          j := kq[i]; k := kq[i+1];
          VeDiem(S.Diem[j], j);
          Noi(S.Diem[j], S.Diem[k]);
        end;
        DatMau(color);
        VeDiem(S.Diem[k], k);
        Noi(S.Diem[k], S.Diem[kq[1]]);
      end;

      procedure TimBaoLoi;
      var i, jF, j: integer;
          P, A, Q: kieudiem;
          gmin, gmax, g: real;
      begin
        for i := 1 to S.sodiem do ChuaXet[i] := true;
        {tim diem dau tien cua bao loi}
        jF := 1;
        with S do
        begin
          {tim phan tu co tung do nho nhat}
          for i := 2 to sodiem do
            if Diem[i].y < Diem[jF].y then jF := i;
          g := Diem[jF].y;
          {tim diem co tung do g, dat nho nhat ve hoanh do}
          for i := 1 to sodiem do
            if Diem[i].y = g then
              if Diem[i].x < Diem[jF].x then jF := i;
        end;
        {--> jF la chi so cua diem dau tien}
        nr := 1; ind[1] := jF;
        P := S.Diem[jF];
        A.x := P.x-100; A.y := P.y;
{        DatMau(color);}
        {bat dau vong lap tim bao loi}
        repeat
          {tim diem noi voi P}
          gmin := 1e37;
          for i := 1 to S.sodiem do
          if ChuaXet[i] then
          begin
            Q := S.Diem[i];
            g := Goc(A, P, Q);
            if g >= 0 then
              if g < gmin then
              begin
                gmin := g;
                j := i;
                gmax := sqr(Q.x-P.x)+sqr(Q.y-P.y);
              end else if g = gmin then
                       begin
                         g := sqr(Q.x-P.x)+sqr(Q.y-P.y);
                         if g > gmax then
                         begin
                           gmax := g;
                           j := i;
                         end;
                       end;
          end;
          {--> j la chi so cua diem tim duoc}
          if j <> jF then
          begin
            inc(nr); ind[nr] := j;
          end;
          ChuaXet[j] := false;
          Q := S.Diem[j];
{          Noi(P, Q);
          VeDiem(Q, j);}
          A := P;
          P := Q;
        until j = jF;
        {xong 1 bao loi}
{        write('So cay hang rao ', nr, ', gom ');
        for i := 1 to nr do write(ind[i], ' ');
        writeln;}
      end;

      procedure Test;
      var Sda, Skq: set of 1..100;
          i: integer;
      begin
        Sda := [];
        for i := 1 to nr do Sda := Sda+[ind[i]];
        Skq := [];
        for i := 1 to nkq do Skq := Skq+[kq[i]];
        write('D.a (', nr, '): ');
        for i := 1 to nr do write(ind[i], ' ');
        writeln;
        write('K.q (', nkq, '): ');
        for i := 1 to nkq do write(kq[i], ' ');
        writeln;
        writeln(Sda = Skq);
      end;


  begin  {ThucHien}
    if S.sodiem < 1 then
    begin
      clrscr;
      write('Chua nhap diem ... go 1 phim de ve menu chinh ...');
      ch := readkey; exit;
    end;
    if S.sodiem < 3 then
    begin
      clrscr;
      write('So diem it hon 3 ... go 1 phim de ve menu chinh ...');
      ch := readkey; exit;
    end;
    InitG;             {dat che do Graph}
    TinhTyle;          {tinh ty le man hinh}
    with S do          {ve cac diem da cho}
    for i := 1 to sodiem do VeDiem(Diem[i], i);
    VeKq;
    TimBaoLoi;
    Test;
    ch := readkey;
    closegraph;
  end;

BEGIN
  DocData;
  DocKq;
  ThucHien;
END.

