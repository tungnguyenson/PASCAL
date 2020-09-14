Program Vi_Du_Ve_Truyen_Tham_So_Cho_Chuong_Trinh_Con;

Uses CRT;

Procedure Example1(ts1, ts2, ts3 : Integer);
  Var
    a, b, c : Integer;
  Begin
    Asm
      Mov AX, [BP+4]
      Mov c, AX
      Mov AX, [BP+6]
      Mov b, AX
      Mov AX, [BP+8]
      Mov a, AX
    End;
    WriteLn('Vi du ve truy cap truc tiep tham so:');
    WriteLn('  Gia tri tham so thu 1: ', a);
    WriteLn('  Gia tri tham so thu 2: ', b);
    WriteLn('  Gia tri tham so thu 3: ', c);
  End;

Procedure Example2(Var ts1, ts2, ts3 : Integer); Near;
  Var
    a, b, c : Integer;
  Begin
    Asm
      Mov BX, [BP+4]
      Mov AX, [BX]
      Mov c, AX
      Mov BX, [BP+8]
      Mov AX, [BX]
      Mov b, AX
      Mov BX, [BP+12]
      Mov AX, [BX]
      Mov a, AX
    End;
    WriteLn('Vi du ve truy cap gian tiep tham so:');
    WriteLn('  Gia tri tham so thu 1: ', a);
    WriteLn('  Gia tri tham so thu 2: ', b);
    WriteLn('  Gia tri tham so thu 3: ', c);
  End;

Procedure Example3(Var ts1, ts2, ts3 : Integer); Near;
  Var
    a, b, c : Integer;
  Begin
    a := 111;
    b := 222;
    c := 333;
    Asm
      Mov AX, c
      Mov BX, [BP+4]
      Mov [BX], AX
      Mov AX, b
      Mov BX, [BP+8]
      Mov [BX], AX
      Mov AX, a
      Mov BX, [BP+12]
      Mov [BX], AX
    End;
    WriteLn('Vi du ve gan gia tri cho tham so:');
    WriteLn('  Gia tri tham so thu 1: ', a);
    WriteLn('  Gia tri tham so thu 2: ', b);
    WriteLn('  Gia tri tham so thu 3: ', c);
  End;

Var
  i, j, k : Integer;

Begin
  ClrScr;
  i := 11;
  j := 22;
  k := 33;
  Example1(1, 2, 3);
  Example2(i, j, k);
  Example3(i, j, k);
  ReadLn;
End.