{
     VSCCP - Very Simple Chinese Chess Program
     Written by Pham Hong Nguyen
     Faculty of Information Technology, Viet Nam National University, Hanoi.
     Email: phhnguyen@yahoo.com
     Home page: http:/www.geocities.com/siliconvalley/grid/6544/
     Version 1.0 - Basic Version
}

Program Very_Simple_Chinese_Chess_Program_1_0;

Uses Crt;

Const
  Max_Ply = 4;                    {Do sau tim kiem cuc dai}
  Version = '1.0';                {Ten phien ban}
  Size_X = 9;                     {Kich thuoc chieu ngang ban co}
  Size_Y = 10;                    {Kich thuoc chieu doc ban co}
  Board_Size = Size_X*Size_Y;
  Move_Stack = 500;               {Kich thuoc ngan xep sinh nuoc di}
  Hist_Stack = 50;                {So nuoc cho phep di thu cung luc}
  Empty = 0;                      {Khong co quan co nao}
  Light = 1;                      {Ben trang}
  Dark = 2;                       {Ben den}

  Pawn = 1;                       {Tot}
  Bishop = 2;                     {Si}
  Elephan = 3;                    {Tuong}
  Knight = 4;                     {Ma}
  Cannon = 5;                     {Phao}
  Rook = 6;                       {Xe}
  King = 7;                       {Tuong}
  Infinity = 20000;               {Vo cuc - thay bang so nguyen lon}
  Normal = 0;                     {Che do hien thuong}
  Select = 1;                     {Che do hien chon}

  {Bieu dien ban co va cac trang thai khoi dau cua ban co}
  Piece : Array[1..Board_Size] of Byte =
          (6, 4, 3, 2, 7, 2, 3, 4, 6,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 5, 0, 0, 0, 0, 0, 5, 0,
           1, 0, 1, 0, 1, 0, 1, 0, 1,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           1, 0, 1, 0, 1, 0, 1, 0, 1,
           0, 5, 0, 0, 0, 0, 0, 5, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           6, 4, 3, 2, 7, 2, 3, 4, 6);

  Color : Array[1..Board_Size] of Byte =
          (1, 1, 1, 1, 1, 1, 1, 1, 1,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 1, 0, 0, 0, 0, 0, 1, 0,
           1, 0, 1, 0, 1, 0, 1, 0, 1,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           2, 0, 2, 0, 2, 0, 2, 0, 2,
           0, 2, 0, 0, 0, 0, 0, 2, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0,
           2, 2, 2, 2, 2, 2, 2, 2, 2);

Type
  Move = Record                   {Dinh nghia cau truc nuoc di}
           From, Dest : Byte      {Mot nuoc di bao gom diem xuat phat}
         End;                     {va diem toi}

  Gen_Rec = Record                {Cau truc nuoc di duoc sinh ra}
              m : Move;
            End;

  Hist_Rec = Record               {Luu thong tin de khoi phuc lai nuoc da di}
               m : Move;
               Capture : Byte;    {Luu thong tin ve quan bi an}
             End;

Var
  Ply,                            {Do sau dang lam viec tren cay tim kiem}
  Side, XSide,                    {Nguoi dang den luot choi va doi phuong}
  ComputerSide : Byte;            {Kiem tra ben nao la may tinh}
  NewMove : Move;
  Gen_Dat : Array[0..Move_Stack] of Gen_Rec;           {Cac nuoc di duoc sinh}
  Gen_Begin, Gen_End : Array[0..Hist_Stack] of Integer;{Cac con tro}
  Hist_Dat : Array[0..Hist_Stack] of Hist_Rec;         {Luu thong tin di thu}
  HDP : Integer;                                       {Con tro cua Hit_Dat}
  SysTicks : LongInt Absolute $0040:$006C;           {Dong ho de do thoi gian}
  EvalCount : LongInt;                               {Dem so nut da luong gia}

{***** INTERFACE - GIAO DIEN *****}
Procedure Move_To(x, y : Byte);    {Chuyen den vi tri tuong doi ban co}
  Begin
    GotoXY(5*x-4, 2*y-1);
  End;

Procedure Draw_Cell(Pos_, Mode : Byte);     {Hien noi dung ban co}
  Const
    Piece_Char : String[8] = '+TSVMPXT';    {Cac chu bieu dien quan co}
  Begin
    If Color[Pos_] = Dark then TextColor(13)
     Else
     If Color[Pos_] = Light then TextColor(10)
     Else TextColor(7);
    If Mode = Normal then TextBackGround(0)
                     Else TextBackGround(1);
    Move_To(((Pos_-1) mod 9)+1, (Pos_+8) div 9);
    Write(Piece_Char[Piece[Pos_]+1]);
  End;

Procedure Draw_Board;             {Hien ban co}
  Var
    i : Integer;
  Begin
    TextColor(7);
    TextBackGround(0);
    ClrScr;
    TextColor(8);
    GotoXY(1, 1);
    WriteLn('+----+----+----+----+----+----+----+----+ 9');
    WriteLn('|    |    |    | \  |  / |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 8');
    WriteLn('|    |    |    | /  |  \ |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 7');
    WriteLn('|    |    |    |    |    |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 6');
    WriteLn('|    |    |    |    |    |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 5');
    WriteLn('|                                       |');
    WriteLn('+----+----+----+----+----+----+----+----+ 4');
    WriteLn('|    |    |    |    |    |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 3');
    WriteLn('|    |    |    |    |    |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 2');
    WriteLn('|    |    |    | \  |  / |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 1');
    WriteLn('|    |    |    | /  |  \ |    |    |    |');
    WriteLn('+----+----+----+----+----+----+----+----+ 0');
    WriteLn('A    B    C    D    E    F    G    H    I');
    TextColor(7);
    GotoXY(48, 1);
    WriteLn('VERY SIMPLE CHINESE CHESS PROGRAM');
    GotoXY(54, 2);
    WriteLn('(C) PHN. Ver '+Version);
    For i := 1 to Board_Size do
      Draw_Cell(i, Normal);
  End;

Procedure Gen; Forward;

Function Get_Human_Move : Boolean;          {Xu li dieu khien cua nguoi}
  Const
    x : Byte = 5;                           {Toa do con tro man hinh}
    y : Byte = 5;
  Var
    Ch : Char;
    p, c, Selecting, From, t, i : Integer;
  Begin
    Gen;           {Sinh nuoc di de kiem tra nuoc di hop le cua nguoi choi}
    Get_Human_Move := False;
    Selecting := 0;
    While True do
      Begin
        Move_To(x, y);
        Ch := ReadKey;
        Case Ch of
          #13, ' ' : Begin                  {Xu li phim Enter}
                       t := x+(y-1)*Size_X;
                       p := Piece[t];
                       c := Color[t];
                       If Selecting = 0 then     {Bat dau chon mot quan}
                         Begin
                           If c = Side then
                             Begin
                               Selecting := 1;
                               From := t;
                               Draw_Cell(t, Select);
                             End;
                         End
                        Else
                         Begin              {Chon vi tri den}
                           If t <> From then Draw_Cell(From, Normal);
                           If c = Side then
                             Begin
                               From := t;
                               Draw_Cell(t, Select);
                             End
                            Else
                             Begin     {Kiem tra xem nuoc di co hop le khong}
                               NewMove.From := From;
                               NewMove.Dest := t;
                               For i := Gen_Begin[Ply] to Gen_End[Ply]-1 do
                                 If (Gen_Dat[i].m.From = From)and
                                    (Gen_Dat[i].m.Dest = t) then Exit;
                               Draw_Cell(From, Select);
                             End;
                         End;
                     End;
          #27 : Begin
                  Get_Human_Move := True;
                  Break;                    {Thoat}
                End;
          #0 : Begin                        {Xu li cac phim mui ten}
                 Ch := ReadKey;
                 Case Ch of
                   #75 : If x > 1 then Dec(x)
                                  Else x := Size_X;
                   #77 : If x = Size_X then x := 1
                                       Else Inc(x);
                   #72 : If y > 1 then Dec(y)
                                  Else y := Size_Y;
                   #80 : If y = Size_Y then y := 1
                                       Else Inc(y);
                 End;{Case}
               End;

        End;{Case}
      End;{While}
  End;

{***** GENERATE - SINH NUOC DI *****}
Const
  {Dung de sinh nuoc di moi}
  Offset : Array[1..7, 1..8] of ShortInt =
           (( -1,  1, -13,  0,  0,  0,  0,  0),        {Pawn (for Dark side)}
            (-12,-14, 12, 14,  0,  0,  0,  0),        {Bishop}
            (-28,-24, 24, 28,  0,  0,  0,  0),        {Elephan}
            (-11,-15,-25,-27, 11, 15, 25, 27),        {Knight}
            ( -1,  1,-13, 13,  0,  0,  0,  0),        {Cannon}
            ( -1,  1,-13, 13,  0,  0,  0,  0),        {Rook}
            ( -1,  1,-13, 13,  0,  0,  0,  0));       {King}

  {Ban co mo rong dung de kiem tra nuoc di vuot bien}
  MailBox182 : Array[1..182] of ShortInt =
               (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                -1,-1, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,
                -1,-1,10,11,12,13,14,15,16,17,18,-1,-1,
                -1,-1,19,20,21,22,23,24,25,26,27,-1,-1,
                -1,-1,28,29,30,31,32,33,34,35,36,-1,-1,
                -1,-1,37,38,39,40,41,42,43,44,45,-1,-1,
                -1,-1,46,47,48,49,50,51,52,53,54,-1,-1,
                -1,-1,55,56,57,58,59,60,61,62,63,-1,-1,
                -1,-1,64,65,66,67,68,69,70,71,72,-1,-1,
                -1,-1,73,74,75,76,77,78,79,80,81,-1,-1,
                -1,-1,82,83,84,85,86,87,88,89,90,-1,-1,
                -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1);

  {Dung de chuyen sang ban co mo rong}
  MailBox90 : Array[1..90] of Byte =
              ( 29, 30, 31, 32, 33, 34, 35, 36, 37,
                42, 43, 44, 45, 46, 47, 48, 49, 50,
                55, 56, 57, 58, 59, 60, 61, 62, 63,
                68, 69, 70, 71, 72, 73, 74, 75, 76,
                81, 82, 83, 84, 85, 86, 87, 88, 89,
                94, 95, 96, 97, 98, 99,100,101,102,
               107,108,109,110,111,112,113,114,115,
               120,121,122,123,124,125,126,127,128,
               133,134,135,136,137,138,139,140,141,
               146,147,148,149,150,151,152,153,154);

  {Dung de kiem tra mot nuoc di co hop le hay khong}
  LegalMove : Array[1..90] of Byte =
              ( 1, 1, 5, 3, 3, 3, 5, 1, 1,
                1, 1, 1, 3, 3, 3, 1, 1, 1,
                5, 1, 1, 3, 7, 3, 1, 1, 5,
                1, 1, 1, 1, 1, 1, 1, 1, 1,
                9, 1,13, 1, 9, 1,13, 1, 9,
                9, 9, 9, 9, 9, 9, 9, 9, 9,
                9, 9, 9, 9, 9, 9, 9, 9, 9,
                9, 9, 9, 9, 9, 9, 9, 9, 9,
                9, 9, 9, 9, 9, 9, 9, 9, 9,
                9, 9, 9, 9, 9, 9, 9, 9, 9);

  {Mat na ung voi tung quan co, dung ket hop voi mang LegalMove}
  MaskPiece : Array[1..7] of Byte = (8, 2, 4, 1, 1, 1, 2);
  {Dung de kiem tra nuoc can cua ma}
  KnightCheck : Array[1..8] of ShortInt = ( 1,-1,-9,-9,-1, 1, 9, 9);
  {Dung de kiem tra nuoc can cua tuong}
  ElephanCheck : Array[1..8] of ShortInt = (-10, -8,  8, 10,  0,  0,  0,  0);
  {Cac o trong cung cua mot ben}
  KingPlace : Array[1..9] of Byte = (4, 5, 6, 13, 14, 15, 22, 23, 24);
  {Cac bien dung de do he so phan nhanh}
  BrandTotal : LongInt = 0;
  GenCount : LongInt = 0;

Procedure Init_Gen;               {Khoi dong qua trinh sinh nuoc di}
  Begin
    Gen_End[0] := 0;
    Gen_Begin[0] := 0;
    Ply := 0;
  End;

{Kiem tra 2 Tuong co lo mat hay kong}
Function King_Face(From, Dest : Integer) : Boolean;
  Var
    i, k, t : Integer;
  Begin
    King_Face := False;
    i := From mod 9;
    If (i >= 4)and(i <= 6)and(Piece[Dest] <> King)then
      Begin
        t := Piece[Dest];
        Piece[Dest] := Piece[From];
        Piece[From] := Empty;
        i := 1;
        Repeat
          k := KingPlace[i];
          Inc(i);
        Until Piece[k] = King;
        Inc(k, Size_X);
        While (k < Board_Size)and(Piece[k] = Empty)do
          Inc(k, Size_X);
        If Piece[k] = King then King_Face := True;
        Piece[From] := Piece[Dest];
        Piece[Dest] := t;
      End;
  End;

Procedure Gen_Push(From, Dest : Byte);      {Luu nuoc di vua sinh}
  Begin
    If Not King_Face(From, Dest) then
      Begin
        Gen_Dat[Gen_End[Ply]].m.From := From;
        Gen_Dat[Gen_End[Ply]].m.Dest := Dest;
        Inc(Gen_End[Ply]);
      End;
  End;

Procedure Gen;                    {Sinh tat ca cac nuoc di tu the co hien tai}
  Var
    i, j, k, n, p, x, y, t, FCannon : Integer;
  Begin
    Gen_End[Ply] := Gen_Begin[Ply];
    For i := 1 to Board_Size do
      If Color[i] = Side then
        Begin
          p := Piece[i];
          For j := 1 to 8 do                {Toi da co 8 huong di}
            Begin
              If Offset[p, j] = 0 then Break;
              x := MailBox90[i];
              FCannon := 0;
              If p in [Rook, Cannon] then n := 9
                                     Else n := 1;
              For k := 1 to n do
                Begin
                  If (p = Pawn)and(Side = Light)then Dec(x, Offset[p, j])
                                                Else Inc(x, Offset[p, j]);
                  y := MailBox182[x];
                  If (i = 26)and(y = 35) then
                    Begin
                      i := i;
                    End;
                  If (i = 20)and(y = 65) then
                    Begin
                      i := i;
                    End;
                  If Side = Light then t := y
                                  Else t := 91-y;
                  If (y = -1)or((LegalMove[t]and MaskPiece[p]) = 0)then Break;
                  If FCannon = 0 then
                    Begin
                      If Color[y] <> Side then
                        Begin
                          Case p of
                            Knight : If Color[i+KnightCheck[j]] = Empty then
                                       Gen_Push(i, y);
                            Elephan : If Color[i+ElephanCheck[j]] = Empty then
                                       Gen_Push(i, y);
                            Cannon : If Color[y] = Empty then Gen_Push(i, y);
                            Else Gen_Push(i, y);
                          End;
                        End;
                      If Color[y] <> Empty then
                        Begin
                          If p = Cannon then FCannon := 1
                                        Else Break;
                        End;
                    End
                   Else
                    Begin                   {Xu li nuoc an cua phao}
                      If Color[y] <> Empty then
                        Begin
                          If Color[y] = XSide then Gen_Push(i, y);
                          Break;
                        End;
                    End;
                End;{For k}
            End;{For j}
        End;
    Gen_End[Ply+1] := Gen_End[Ply];
    Gen_Begin[Ply+1] := Gen_End[Ply];
    BrandTotal := BrandTotal+Gen_End[Ply]-Gen_Begin[Ply];
    Inc(GenCount);
  End;

{***** MOVE - DI THU VA DI THAT *****}
Function Make_Move(m : Move) : Boolean;     {Di thu}
  Var
    From, Dest : Integer;
  Begin
    From := m.From;
    Dest := m.Dest;
    Make_Move := Piece[Dest] = King;
    Hist_Dat[HDP].m := m;
    Hist_Dat[HDP].Capture := Piece[Dest];
    Piece[Dest] := Piece[From];
    Piece[From] := Empty;
    Color[Dest] := Color[From];
    Color[From] := Empty;
    Inc(HDP);
    Inc(Ply);
    Side := XSide;
    XSide := 3-Side;
  End;

Procedure UnMake_Move;                      {Phuc hoi nuoc di thu}
  Var
    From, Dest : Byte;
  Begin
    Dec(HDP);
    Dec(Ply);
    Side := XSide;
    XSide := 3-Side;
    From := Hist_Dat[HDP].m.From;
    Dest := Hist_Dat[HDP].m.Dest;
    Piece[From] := Piece[Dest];
    Color[From] := Color[Dest];
    Piece[Dest] := Hist_Dat[HDP].Capture;
    If Piece[Dest] = Empty then Color[Dest] := Empty
                           Else Color[Dest] := XSide;
  End;

Function Update_New_Move : Boolean;         {Cap nhap nuoc di that su}
  Var
    From, Dest : Integer;
  Begin
    From := NewMove.From;
    Dest := NewMove.Dest;
    Update_New_Move := Piece[Dest] = King;
    Piece[Dest] := Piece[From];
    Piece[From] := Empty;
    Color[Dest] := Color[From];
    Color[From] := Empty;
    Draw_Cell(From, Normal);
    Draw_Cell(Dest, Normal);
  End;

{***** EVALUATE - LUONG GIA TINH *****}
Function Eval : Integer;          {Cho diem the co hien tai}
  Const
    PieceValue : Array[1..7] of Integer = (10, 20, 20, 40, 45, 90, 1000);
  Var
    i, s : Integer;
  Begin
    Inc(EvalCount);
    s := 0;
    For i := 1 to Board_Size do
      Begin
        If Color[i] = Side then Inc(s, PieceValue[Piece[i]])
         Else
          If Color[i] = XSide then Dec(s, PieceValue[Piece[i]])
      End;
    Eval := s;
  End;

{***** ALPHABETA - TIM KIEM TREN CAY TRO CHOI *****}
Function AlphaBeta(Alpha, Beta : Integer; Depth : Byte) : Integer;
  Var
    i, Best, Value : Integer;
  Begin
    If Depth = 0 then AlphaBeta := Eval
     Else
      Begin
        Gen;
        Best := -Infinity;
        i := Gen_Begin[Ply];
        {Lap lai tat ca cac nuoc}
        While (i < Gen_End[Ply])and(Best < Beta)do
          Begin
            If Best > Alpha then Alpha := Best;
            If Make_Move(Gen_Dat[i].m) then Value := 1000-Ply
             Else Value := -AlphaBeta(-Beta, -Alpha, Depth-1);
            UnMake_Move;
            If Value > Best then
              Begin
                Best := Value;
                If Ply = 0 then NewMove := Gen_Dat[i].m;
              End;
            Inc(i);
          End;{While}
        AlphaBeta := Best;
      End;
  End;

{***** THINK - MAY TINH TINH NUOC DI *****}
Procedure Computer_Think;         {Tim nuoc di va hien thong tin}
  Var
    Best : Integer;
    TickStart, TickEnd : LongInt;
  Begin
    GotoXY(50, 11);
    TextColor(7);
    Write('May tinh di : Dang nghi...');
    TickStart := SysTicks;        {Do thoi gian}
    Best := AlphaBeta(-Infinity, Infinity, Max_Ply);
    {Phuc vu hien cac thong tin theo doi}
    TickEnd := SysTicks;
    GotoXY(50, 4);
    Write('Do sau: ', Max_Ply);
    GotoXY(50, 5);
    Write('So nut luong gia: ', EvalCount, ' ');
    GotoXY(50, 6);
    Write('He so phan nhanh: ', BrandTotal/GenCount:0:2, ' ');
    GotoXY(50, 7);
    Write('Thoi gian(giay) : ', (TickEnd-TickStart)/18.23:0:2, ' ');
    GotoXY(50, 8);
    Write('Toc do xet nut  : ', EvalCount*18.23/(TickEnd-TickStart+1):0:0, ' ');
    GotoXY(50, 9);
    Write('Diem dat duoc   : ', Best, ' ');
    GotoXY(50, 11);
    ClrEol;
    Write('May tinh di : ', Chr(((NewMove.From-1) mod Size_X)+65),
                           Size_X-(NewMove.From-1) div Size_X,
                           Chr(((NewMove.Dest-1) mod Size_X)+65),
                           Size_X-(NewMove.Dest-1) div Size_X, ' ');
  End;

{***** MAIN - THAN CHUONG TRINH CHINH *****}
Begin
  Init_Gen;
  Draw_Board;
  Side := Light;
  XSide := Dark;
  ComputerSide := Light;
  Repeat                          {Vong lap xu li chinh}
    If Side = ComputerSide then Computer_Think
     Else
      If Get_Human_Move then Break;
    Side := XSide;
    XSide := 3-Side;               {Nguoi se toi luot}
  Until Update_New_Move;
  TextAttr := 7;
  ClrScr;
End.