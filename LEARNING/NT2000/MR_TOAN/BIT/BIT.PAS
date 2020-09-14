Uses CRT;

Const
  TenTepDL = 'BIT.IN0';
  TenTepKQ = 'BIT.OUT';
  MaxMN = 100;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Type
  Rectangle = Record
    y1, x1, y2, x2 : Byte;
  End;

Var
  Map, Xet : Array[0..MaxMN+1, 0..MaxMN+1] Of Byte;
  Queue : Array[1..MaxMN*MaxMN, 1..2] Of Byte;
  Luu : Array[1..(MaxMN*MaxMN Div 6)] Of Rectangle;
  DemT, LeftQ, RightQ : Word;
  Row, Col : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
    Ch : Char;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, Row, Col);
    FillChar(Map, SizeOf(Map), 0);
    For i := 1 To Row Do
      Begin
        For j := 1 To Col Do
          Begin
            Read(F, Ch);
            Map[i, j] := Ord(Ch)-48;
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

Procedure BFS(y, x : Byte);
  Var
    DaXet : Array[1..MaxMN, 1..MaxMN] Of Byte;
    i, j, yn, xn : Byte;
  Begin
    LeftQ := 1;
    RightQ := 1;
    Queue[RightQ, 1] := y;
    Queue[RightQ, 2] := x;
    While LeftQ <= RightQ Do
      Begin
        For i := 1 To 4 Do
          Begin
            yn := y+Next[i, 1];
            xn := x+Next[i, 2];
            If Map[yn, xn] = 1 Then
              Begin
                Inc(RightQ);
                Queue[RightQ, 1] := yn;
                Queue[RightQ, 2] := xn;
                Map[yn, xn] := 2;
              End;
          End;
        Inc(LeftQ);
        y := Queue[LeftQ, 1];
        x := Queue[LeftQ, 2];
      End;
  End;

Function KTra_Canh(R : Rectangle; c1, c2, c3, c4 : Byte) : Boolean;
  Var
    i : Byte;
    KTra : Boolean;
  Begin
    KTra := True;
    If c1 <> 0 Then
      For i := R.y1 To R.y2 Do
        If Map[i, R.x1-1] = 1 Then KTra := False;
    If c2 <> 0 Then
      For i := R.x1 To R.x2 Do
        If Map[R.y1-1, i] = 1 Then KTra := False;
    If c3 <> 0 Then
      For i := R.y1 To R.y2 Do
        If Map[i, R.x2+1] = 1 Then KTra := False;
    If c4 <> 0 Then
      For i := R.x1 To R.x2 Do
        If Map[R.y2+1, i] = 1 Then KTra := False;
    KTra_Canh := KTra;
  End;

Function TimHCN(R1 : Rectangle; Var R2 : Rectangle) : Boolean;
  Var
    i, j, k, LC, x, y : Byte;
    c1, c2, c3, c4 : Byte;
  Begin
    TimHCN := True;
    k := 0;
    For i := R1.y1 To R1.y2 Do
      For j := R1.x1 To R1.x2 Do
        If Map[i, j] <> 1 Then Inc(k);
    If k <> 0 Then
      Begin
        TimHCN := False;
        Exit;
      End;
    LC := 0;
    c1 := 1;
    c2 := 1;
    c3 := 1;
    c4 := 1;
    With R1 Do
      Begin
        y := y1+1;
        While Map[y, x1] = 1 Do
          Begin
            If Map[y, x1-1] = 1 Then
              Begin
                Inc(LC);
                c3 := 0;
                R2.y1 := y;
                R2.x2 := x1-1;
                While (Map[y, x1] = 1)And(Map[y, x1-1] = 1) Do Inc(y);
                R2.y2 := y-1;
                R2.x1 := R2.x2;
                While Map[R2.y1, R2.x1-1] = 1 Do Dec(R2.x1);
              End
             Else Inc(y);
          End;
        x := x1;
        While Map[y1, x] = 1 Do
          Begin
            If Map[y1-1, x] = 1 Then
              Begin
                Inc(LC);
                c4 := 0;
                R2.y2 := y1-1;
                R2.x1 := x;
                While (Map[y1, x] = 1)And(Map[y1-1, x] = 1) Do Inc(x);
                R2.x2 := x-1;
                R2.y1 := R2.y2;
                While Map[R2.y1-1, R2.x1] = 1 Do Dec(R2.y1);
              End
             Else Inc(x);
          End;
        y := y1;
        While Map[y, x2] = 1 Do
          Begin
            If Map[y, x2+1] = 1 Then
              Begin
                Inc(LC);
                c1 := 0;
                R2.y1 := y;
                R2.x1 := x2+1;
                While (Map[y, x2] = 1)And(Map[y, x2+1] = 1) Do Inc(y);
                R2.y2 := y-1;
                R2.x2 := R2.x1;
                While Map[R2.y1, R2.x2+1] = 1 Do Inc(R2.x2);
              End
             Else Inc(y);
          End;
        x := x1;
        While Map[y2, x] = 1 Do
          Begin
            If Map[y2+1, x] = 1 Then
              Begin
                Inc(LC);
                c2 := 0;
                R2.y1 := y2+1;
                R2.x1 := x;
                While (Map[y2, x] = 1)And(Map[y2+1, x] = 1) Do Inc(x);
                R2.x2 := x-1;
                R2.y2 := R2.y1;
                While Map[R2.y2+1, R2.x1] = 1 Do Inc(R2.y2);
              End
             Else Inc(x);
          End;
      End;
    If LC = 1 Then
      Begin
        k := 0;
        For i := R2.y1 To R2.y2 Do
          For j := R2.x1 To R2.x2 Do
            If Map[i, j] <> 1 Then Inc(k);
        If Not ((((c1 <> 0)Or(c3 <> 0))And(R2.y1 > R1.y1)And(R2.y2 < R1.y2)) Or
           (((c2 <> 0)Or(c4 <> 0))And(R2.x1 > R1.x1)And(R2.x2 < R1.x2))) Then
          TimHCN := False;
        If k <> 0 Then TimHCN := False
         Else If KTra_Canh(R2, c1, c2, c3, c4) = False Then TimHCN := False;
      End
     Else TimHCN := False;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
    R, R1, R2 : Rectangle;
  Begin
    FillChar(Xet, Sizeof(Xet), 0);
    DemT := 0;
    For i := 1 To Row Do
      For j := 1 To Col Do
        If (Xet[i, j] = 0)And(Map[i, j] = 1) Then
          Begin
            With R1 Do
              Begin
                y1 := i;
                x1 := j;
                y2 := y1;
                x2 := x1;
                While Map[y2+1, x1] = 1 Do Inc(y2);
                While Map[y1, x2+1] = 1 Do Inc(x2);
              End;
            If TimHCN(R1, R2) Then
              Begin
                If R1.x1 <= R2.x1 Then R.x1 := R1.x1
                                  Else R.x1 := R2.x1;
                If R1.y1 <= R2.y1 Then R.y1 := R1.y1
                                  Else R.y1 := R2.y1;
                If R1.x2 >= R2.x2 Then R.x2 := R1.x2
                                  Else R.x2 := R2.x2;
                If R1.y2 >= R2.y2 Then R.y2 := R1.y2
                                  Else R.y2 := R2.y2;
                Inc(DemT);
                Luu[DemT] := R;
              End;
            BFS(R1.y1, R1.x1);
          End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, DemT);
    For i := 1 To DemT Do
      With Luu[i] Do
        WriteLn(F, y1, ' ', x1, ' ', y2, ' ', x2);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.