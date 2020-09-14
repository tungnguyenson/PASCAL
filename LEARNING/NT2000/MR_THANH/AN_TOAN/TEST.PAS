uses crt;
const
  maxdiem = 100;
  eps = 1e-6;
  kdapan: array['1'..'7'] of integer = (11, 20, 32, 34, 45, 47, 55);
type
  kieudiem = record
               x, y: real;
             end;
  mangdiem = array[1..maxdiem] of kieudiem;
  daydiem  = record
               sodiem: integer;
               diem  : mangdiem;
             end;
var P, Q: daydiem;
    s, t: array[1..maxdiem] of integer;
    u, v: array[1..maxdiem*maxdiem] of integer;
    l, k: integer;
    f: text;
    fn: string;
    ch: char;

  function Phia(var A, B, C: kieudiem): integer;
  { tra lai 0 neu C thuoc duong thang AB,
            1 neu C thuoc mot phia cua AB,
           -1 neu C thuoc phia kia cua AB }
  var g: real;
  begin
    g := (A.y-B.y)*(C.x-A.x)+(B.x-A.x)*(C.y-A.y);
    if abs(g) < eps then Phia := 0
    else if g > 0 then Phia := 1
         else Phia := -1;
  end;

  function ViTri(var A, B, C: kieudiem): integer;
  { tra lai 2 neu C khong thuoc duong thang AB,
            0 neu C nam trong doan AB,
            1 neu C nam ve phia B cua doan AB,
           -1 neu C nam ve phia A cua doan AB }
  var t, tu, mau: real;
  begin
    if Phia(A, B, C) <> 0 then
      ViTri := 2
    else
    begin
      tu := C.x-A.x; mau := B.x-A.x;
      if abs(mau) < abs(B.y-A.y) then
      begin
        tu := C.y-A.y; mau := B.y-A.y;
      end;
      t := tu/mau;
      if t > 1 then ViTri := 1
      else if t < 0 then ViTri := -1
           else ViTri := 0;
    end;
  end;

  function KhongCat(var A, B, C, D: kieudiem): boolean;
  { kiem tra doan AB co cat doan CD hay khong? }
  begin
    KhongCat := (Phia(A, B, C)*Phia(A, B, D)=1) or
                (Phia(C, D, A)*Phia(C, D, B)=1) or
                (ViTri(A, B, C)*ViTri(A, B, D)=1);
  end;

  function GiaoTG(var a, b, c, d: integer): boolean;
  {kiem tra cac doan thoi gian ab va cd co giao nhau khong}
  begin
    GiaoTG := (b > c) and (a < d);
  end;

  procedure DocData;
  var i: integer;
  begin
    writeln;
    fn := 'TN';
    write('======= Ten file du lieu: ', fn);
    ch := readkey; writeln(ch);
    fn := fn+ch;
    assign(f, fn); reset(f);
    with P do   {quy dao 1}
    begin
      readln(f, sodiem);
      for i := 1 to sodiem do
        read(f, diem[i].x, diem[i].y);
      for i := 1 to sodiem do
        read(f, s[i]);
    end;
    with Q do   {quy dao 2}
    begin
      readln(f, sodiem);
      for i := 1 to sodiem do
        read(f, diem[i].x, diem[i].y);
      for i := 1 to sodiem do
        read(f, t[i]);
    end;
    close(f);
    {in de kiem tra}
    with P do
    begin
      writeln(sodiem);
      for i := 1 to sodiem do
        write(' ', diem[i].x:1:0, ' ', diem[i].y:1:0);
      writeln;
      for i := 1 to sodiem do
        write(' ', s[i]);
      writeln;
    end;
    with Q do
    begin
      writeln(sodiem);
      for i := 1 to sodiem do
        write(' ', diem[i].x:1:0, ' ', diem[i].y:1:0);
      writeln;
      for i := 1 to sodiem do
        write(' ', t[i]);
      writeln;
    end;
  end;

  procedure DocKQ;
  var i: integer;
  begin
    fn := 'TN.OUT';
    writeln('======= Ten file ket qua: ', fn);
    assign(f, fn); reset(f);
    readln(f, k);
    for i := 1 to k do readln(f, u[i], v[i]);
    close(f);
    {in de kiem tra}
    writeln(k);
    for i := 1 to k do
      write(u[i], '-', v[i], '; ');
    writeln;
  end;

  function Err(i, j: integer): integer;
  {0: khong co loi, 1: khong giao thoi gian, 2: khong cat}
  begin
    if KhongCat(P.diem[i], P.diem[i+1], Q.diem[j], Q.diem[j+1]) then
    begin
      Err := 2; exit;
    end;
    if not GiaoTG(s[i], s[i+1], t[j], t[j+1]) then
    begin
      Err := 1; exit;
    end;
    Err := 0;
  end;

  procedure KiemTra;
  var i, soloi: integer;
  begin
    soloi := 0;
    for i := 1 to k do
    case Err(u[i], v[i]) of
      2: begin
           inc(soloi);
           writeln('Doan ', u[i], '-', v[i], ' khong cat nhau!');
         end;
      1: begin
           inc(soloi);
           writeln('Doan ', u[i], '-', v[i], ' khong giao thoi gian!');
         end;
    end;
    if soloi > 0 then writeln('So loi = ', soloi)
    else
    begin
      writeln('Ket qua la hop le');
      if kdapan[ch] > k then
        writeln('Ket qua con thieu! (dap an = ', kdapan[ch], ')')
      else
        if kdapan[ch] = k then writeln('Ket qua la dung dan')
        else
          writeln('Ket qua tot hon dap an');
    end;
  end;

BEGIN
  DocData;
  DocKQ;
  KiemTra;
  readln;
END.
