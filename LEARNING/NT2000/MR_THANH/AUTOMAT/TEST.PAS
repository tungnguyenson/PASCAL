{test bai may sinh so}
const
  max = 199;
type
  info = record
           status: byte;
           out: byte;
         end;
var
  s, y: array[0..max, 0..9] of byte;
  n: byte;  {so trang thai}
  q: array[0..(max+1)*10] of info;
  nq, code, nck: integer;
  thutu: array[0..max, 0..9] of integer;
  batdau, ketthuc, khoidong: byte;
  f: text;
  fn: string;

  procedure DocData;
  var i, j: byte;
  begin
    writeln;
    write('Ten file du lieu: '); readln(fn);
    if fn <> '' then
    begin
      assign(f, fn); reset(f);
      readln(f, n);
      for i := 0 to n-1 do
      begin
        for j := 0 to 9 do read(f, s[i, j]);
        for j := 0 to 9 do read(f, y[i, j]);
      end;
      read(f, batdau, ketthuc, khoidong);
      close(f);
    end;
    {in kiem tra
    for i := 0 to n-1 do
    begin
      for j := 0 to 9 do write(s[i, j]:4);
      write('  ³ ');
      for j := 0 to 9 do write(y[i, j]:3);
      writeln;
    end;
    writeln(batdau, '  ', ketthuc, '  ', khoidong);
    writeln;}
  end;

  procedure Aut;
  var u, v, uu, vv: byte;
  begin
    fillchar(thutu, sizeof(thutu), 0);
    u := batdau; v := khoidong;
    q[0].status := u; q[0].out := v;
    nq := 0;
    while u <> ketthuc do
    begin
      uu := s[u, v];
      vv := y[u, v];
      if thutu[uu, vv] > 0 then   {xuat hien chu ky}
      begin
        code := thutu[uu, vv]; exit;
      end;
      thutu[uu, vv] := thutu[u, v]+1;
      inc(nq);
      q[nq].status := uu; q[nq].out := vv;
      u := uu; v := vv;
    end;
    code := nq+1;
  end;

  function LaChuKy(k: integer): boolean;
  var d, i, j: integer;
  begin
    d := nck div k;
    for i := 1 to d-1 do
      for j := 0 to k-1 do
      if q[code+j].out <> q[code+i*k+j].out then
      begin
        Lachuky := false; exit;
      end;
    Lachuky := true;
  end;

  procedure TimCode;
  var i, k: integer;
  begin
    i := 1; k := nck-1;
    while code > i do
    begin
      if q[code-i].out <> q[code+k].out then
      begin
        code := code-i+1; exit;
      end;
      inc(i);
      if k = 0 then k := nck-1 else dec(k);
    end;
    code := 1;
  end;

  procedure Kq;
  var i: integer;
  begin
    write('So sinh ra: ');
    nck := nq-code+1;
    if nck = 0 then
    begin
      writeln('huu han (', nq, ' chu so)');
      for i := 1 to nq do write(q[i].out);
      writeln;
    end
    else
    begin
      {kiem tra doan cuoi}
      for i := 1 to (nck div 2) do
      if nck mod i = 0 then
        if LaChuKy(i) then
        begin
          nck := i;
          break;
        end;
      {kiem tra doan dau}
      TimCode;
      writeln('vo han (vi tri chu ky ', code, ')');
      for i := 1 to code-1 do write(q[i].out);
      write('(');
      for i := code to code+nck-1 do write(q[i].out);
      writeln(')');
    end;
  end;

  procedure Test;
  var i, len: integer;
     ch: char;
  begin
    if nck = 0 then len := code-1 else len := nck+code+1;
    fn := 'aut.out';
    writeln('Ten file ket qua: ', fn);
    assign(f, fn); reset(f);
    i := 0;
    while not eoln(f) do
    begin
      read(f, ch); inc(i); write(ch);
    end;
    writeln;
    if i <> len then
    begin
      writeln('Error! Do dai sai');
      readln; exit;
    end;
    {kiem tra tung ky tu}
    reset(f);
    for i := 1 to code-1 do
    begin
      read(f, ch);
      if ord(ch)-48 <> q[i].out then
      begin
        writeln('Error! Sai ky tu thu ', i);
        readln; exit;
      end;
    end;
    if nck > 0 then
    begin
      read(f, ch);
      if ch <> '(' then
      begin
        writeln('Error! thieu ( tai vi tri ', code);
        readln; exit;
      end;
      for i := code to code+nck-1 do
      begin
        read(f, ch);
        if ord(ch)-48 <> q[i].out then
        begin
          writeln('Error! Sai ky tu thu ', i+1);
          readln; exit;
        end;
      end;
      read(f, ch);
      if ch <> ')' then
      begin
        writeln('Error! thieu ) tai vi tri ', len);
        readln; exit;
      end;
    end;
    writeln('Ok'); readln;
  end;

BEGIN
  DocData;
  Aut;
  Kq;
  Test;
END.
