{$M 65520,0,655360}
type
  huong = array[1..4] of integer;
const
  fi = 'BIT.IN0';
  fo = 'BIT.OUT';
  di: huong = (0, 1, 0,-1);
  dj: huong = (1, 0,-1, 0);
var
  m, n, ii, jj, dongmin, cotmin, dongmax, cotmax, cao, rong: byte;
  a, b, c: array[1..100, 1..100] of byte;
  xet: array[0..101, 0..101] of boolean;
  dem: word;
  f: text;

    procedure Nhap;
    var
      i, j: byte;
      s: string;
    begin
      writeln;
      fillchar(a, sizeof(a), 0);

      assign(f, fi); reset(f);
      readln(f, m, n);
      for i := 1 to m do
      begin
        readln(f, s);
        for j := 1 to n do a[i, j] := ord(s[j])-48;
      end;
      close(f);

{      for i := 1 to m do
      begin
        for j := 1 to n do write(a[i, j]);
        writeln;
      end;}

      fillchar(xet, sizeof(xet), false);
      for i := 1 to m do
        for j := 1 to n do xet[i, j] := true;
    end;

    function LaT(h, w: byte): boolean;
    var s, t: string[100];
        i, j: byte;
    begin
      i := 1;
      t := '';
      for j := 1 to w do t := t+chr(48+c[i, j]);
      s := t;
      while (i <= h) and (t = s) do
      begin
        inc(i);
        t := '';
        for j := 1 to w do t := t+chr(48+c[i, j]);
      end;
      if i > h then
      begin
        LaT := false; exit;
      end;
      s := t;
      j := 1;
      while (j <= w) and (s[j] = '0') do inc(j);

      if (j = 1) or (j >= w) then
      begin
        LaT := false; exit;
      end;
      while (j <= w) and (s[j] = '1') do inc(j);
      if j > w then
      begin
        LaT := false; exit;
      end;
      while (j <= w) and (s[j] = '0') do inc(j);
      if j <= w then
      begin
        LaT := false; exit;
      end;
      while (i <= h) and (t = s) do
      begin
        inc(i);
        t := '';
        for j := 1 to w do t := t+chr(48+c[i, j]);
      end;
      LaT := i>h;
    end;

    function Loai: byte;
    {0: khong bien doi, 1: quay trai, 2: lat len, 3: quay phai, 4: invalid}
    var i, j: byte;
    begin
      i := dongmin; j := cotmin;
      while (j <= cotmax) and (b[i, j] = 1) do inc(j);
      if j > cotmax then
      begin
        Loai := 0; exit;
      end;
      i := dongmin; j := cotmax;
      while (i <= dongmax) and (b[i, j] = 1) do inc(i);
      if i > dongmax then
      begin
        loai := 1; exit;
      end;
      i := dongmax; j := cotmin;
      while (j <= cotmax) and (b[i, j] = 1) do inc(j);
      if j > cotmax then
      begin
        Loai := 2; exit;
      end;
      i := dongmin; j := cotmin;
      while (i <= dongmax) and (b[i, j] = 1) do inc(i);
      if i > dongmax then
      begin
        loai := 3; exit;
      end;
      Loai := 4;
    end;

    procedure InHinh;
    var i, j, l: byte;
        yes: boolean;

    begin
      fillchar(c, sizeof(c), 0);
{      writeln('loai = ', loai);
      for i := dongmin to dongmax do
      begin
        for j := cotmin to cotmax do write(b[i, j]);
        writeln;
      end;
      writeln('Bien doi:');}
      yes := false;
      case loai of
        0: begin
             for i := dongmin to dongmax do
               for j := cotmin to cotmax do
               c[i+1-dongmin, j+1-cotmin] := b[i, j];
             cao := dongmax-dongmin+1; rong := cotmax-cotmin+1;
             yes := LaT(cao, rong);
           end;
        1: begin
             for j := cotmax downto cotmin do
               for i := dongmin to dongmax do
               c[cotmax+1-j, i+1-dongmin] := b[i, j];
             cao := cotmax-cotmin+1; rong := dongmax-dongmin+1;
             yes := LaT(cao, rong);
           end;
        2: begin
             for i := dongmax downto dongmin do
               for j := cotmin to cotmax do
               c[dongmax+1-i, j+1-cotmin] := b[i, j];
             cao := dongmax-dongmin+1; rong := cotmax-cotmin+1;
             yes := LaT(cao, rong);
           end;
        3: begin
             for j := cotmin to cotmax do
               for i := dongmax downto dongmin do
               c[j+1-cotmin, dongmax+1-i] := b[i, j];
             cao := cotmax-cotmin+1; rong := dongmax-dongmin+1;
             yes := LaT(cao, rong);
           end;
      end;
      if yes then
      begin
        inc(dem);
        writeln(f, dongmin:4, cotmin:4, dongmax:4, cotmax:4);
      end;
    end;



    procedure Loang(i, j: byte);
    var k: byte;
    begin
      if dongmin > i then dongmin := i;
      if dongmax < i then dongmax := i;
      if cotmin > j then cotmin := j;
      if cotmax < j then cotmax := j;
      xet[i, j] := false; b[i, j] := 1;
      for k := 1 to 4 do
      begin
        ii := i+di[k]; jj := j+dj[k];
        if xet[ii, jj] and (a[ii, jj] = 1) then Loang(ii, jj);
      end;
    end;

    procedure Tim;
    var i, j: byte;
    begin
      dem := 0;
      assign(f, 'temp'); rewrite(f);
      for i := 1 to m do
        for j := 1 to n do
        if xet[i, j] and (a[i, j] = 1) then
        begin
            dongmin := 255; cotmin := 255;
            dongmax := 0; cotmax := 0;
            fillchar(b, sizeof(b), 0);
            Loang(i, j);
            {in kiem tra}
            InHinh;
        end;
      close(f);
    end;


    procedure Test;
    var s, t: array[1..100] of string[4];
        dd, thua, thieu: word;
        comat: array[1..100] of boolean;

        procedure DocFile;
        var u, v, x, y: byte;
            i: word;

        begin
          assign(f, 'temp'); reset(f);
          for i := 1 to dem do
          begin
            readln(f, u, v, x, y);
            s[i] := chr(u)+chr(v)+chr(x)+chr(y);
          end;
          close(f);
          assign(f, fo); reset(f);
          readln(f, dd);
          for i := 1 to dd do
          begin
            readln(f, u, v, x, y);
            t[i] := chr(u)+chr(v)+chr(x)+chr(y);
          end;
          close(f);
          fillchar(comat, sizeof(comat), false);
          thieu := 0; thua := 0;
        end;

        procedure SoSanh;
        var i, j, k: word;
        begin
          for i := 1 to dd do
          begin
            {tim t[i] trong day s[j]}
            k := 0;
            for j := 1 to dem do
            if s[j] = t[i] then
            begin
              k := j; break;
            end;
            if k = 0 then
            begin
              inc(thua);
              writeln('Thua : ',
              ord(t[i][1]):4, ord(t[i][2]):4, ord(t[i][3]):4, ord(t[i][4]):4);
            end else comat[k] := true;
          end;
          for i := 1 to dem do
          if not comat[i] then
          begin
            inc(thieu);
            writeln('Thieu: ',
            ord(s[i][1]):4, ord(s[i][2]):4, ord(s[i][3]):4, ord(s[i][4]):4);
          end;
        end;
    begin
      DocFile; SoSanh;
      if (thieu = 0) and (thua = 0) then writeln ('OK');
    end;

BEGIN
  Nhap; Tim; Test;
  write('Da xong! ... '); readln;
END.





