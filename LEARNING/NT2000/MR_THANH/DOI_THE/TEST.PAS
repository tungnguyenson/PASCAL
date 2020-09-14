{test bai DOITHE}
uses crt;
type
  arr1 = array['1'..'6'] of integer;
  arr2 = array['1'..'6'] of byte;
const
  max = 200;
  kdapan: arr1 = (6, 5, 5, 5, 5, -1);
  mdapan: arr2 = (5, 5, 4, 4, 5, 4);
  smaxdapan: arr2 = (20, 40, 70, 90, 100, 96);

var f: text;
  fn: string;
  a: array[1..max, 1..max] of byte;
  n, m, s, smax, t: byte;
  x, y: array[1..max] of byte;
  k: integer;
  ch: char;

  procedure DocData;
  var i, j: byte;
  begin
    writeln;
    write('Ten file du lieu: A');
    ch := readkey; writeln(ch); fn := 'A'+ch;
    assign(f, fn);
    reset(f);
    readln(f, n);
    for i := 1 to n do
      for j := 1 to n do read(f, a[i, j]);
    readln(f, s, t);
    close(f);
    writeln('n = ', n, ', ', s, ' --> ', t);
  end;

  procedure DocKQ;
  var i: byte;
  begin
    fn := 'DOITHE.OUT';
    writeln('Ten file ket qua: ', fn);
    assign(f, fn); reset(f);
    readln(f, k);
    if k > 0 then
    begin
      for i := 1 to k do read(f, x[i]);
      readln(f);
    end;
    readln(f, m);
    for i := 1 to m do read(f, y[i]);
    close(f);
    {in de kiem tra}
    writeln(k);
    if k > 0 then
    begin
      for i := 1 to k do write(x[i]:4);
      writeln;
    end;
    writeln(m);
    if m >= 1 then
    begin
      for i := 1 to m do write(y[i]:4);
      writeln;
    end;
  end;

  procedure KiemTra1;
  var u, i: byte;
  begin
    writeln('Test yeu cau 1:');
    write('  Ket qua: ');
    if k = -1 then
    begin
      writeln('khong doi duoc the ', t);
      if (kdapan[ch] <> -1) then writeln('  Error! doi duoc')
      else writeln('  OK');
    end else
    begin
      u := s;
      for i := 1 to k do u := a[u, x[i]];
      writeln('sau ', k, ' lan doi the duoc the co so hieu ', u);
      if u <> t then
        writeln('  Error! khong phai the mong muon')
      else
        if k > kdapan[ch] then
          writeln('  Chua toi uu (dap an = ', kdapan[ch], ')')
        else
          writeln('  OK');
    end;
  end;

  procedure KiemTra2;
  var u, i: byte;
  begin
    writeln('Test yeu cau 2:');
    write('  Ket qua: ');
    u := s;
    for i := 1 to m do u := a[u, y[i]];
    writeln('sau ', m, ' lan doi the duoc the co so hieu ', u);
    if u <> smaxdapan[ch] then
      writeln('  Error! khong phai the co so hieu lon nhat')
    else
      if m > mdapan[ch] then
        writeln('  Chua toi uu (dap an = ', mdapan[ch], ')')
      else
        writeln('  OK');
  end;

BEGIN
  DocData;
  DocKQ;
  KiemTra1;
  KiemTra2;
  readln;
END.
