Uses CRT;

Const
  MaxMN = 50;

Type
  MangMN = Array[1..MaxMN, 1..MaxMN] Of Char;

Var
  Grid : MangMN;
  DaXet : Array['A'..'Z'] Of Boolean;
  ThuTu : Array[1..26] Of Char;
  Count, FrameCount : Byte;
  M, N : Byte;

Procedure Show_Grid;
  Var
    i, j : Byte;
  Begin
    ClrScr;
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Write(Grid[i, j]:3);
        WriteLn;
      End;
    WriteLn(Count);
{    ReadLn;{}
  End;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    TenTepDL := 'frame.in1';
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Read(F, Grid[i, j]);
        ReadLn(F);
      End;
    Close(F);
    Show_Grid;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    FillChar(DaXet, SizeOf(DaXet), False);
    FrameCount := 0;
    For i := 1 To M Do
      For j := 1 To N Do
        If (Grid[i, j] <> '.') Then
          If DaXet[Grid[i, j]] = False Then
            Begin
              Inc(FrameCount);
              DaXet[Grid[i, j]] := True;
            End;
    For i := 1 To 26 Do ThuTu[i] := #0;
  End;

Function IsFrame(Var y1, x1, y2, x2 : Byte; CheckFrame : Boolean) : Boolean;
  Var
    i, j : Byte;
    Dem : Byte;
    Ch : Char;
  Begin
    y2 := y1;
    x2 := x1;
    Ch := Grid[y1, x1];
    For i := 1 To M Do
      For j := 1 To N Do
        If Grid[i, j] = Ch Then
          Begin
            If i > y2 Then y2 := i;
            If i < y1 Then y1 := i;
            If j > x2 Then x2 := j;
            If j < x1 Then x1 := j;
          End;
    IsFrame := True;
    If ((y2-y1 < 2)Or(x2-x1 < 2))And(CheckFrame = True) Then IsFrame := False
     Else
      Begin
        Dem := 0;
        For i := y1 To y2-1 Do
    	   If (Grid[i, x1] = Ch)Or(Grid[i, x1] = '*') Then Inc(Dem);
        For j := x1 To x2-1 Do
    	   If (Grid[y2, j] = Ch)Or(Grid[y2, j] = '*') Then Inc(Dem);
        For i := y2 DownTo y1+1 Do
    	   If (Grid[i, x2] = Ch)Or(Grid[i, x2] = '*') Then Inc(Dem);
        For j := x2 DownTo x1+1 Do
    	   If (Grid[y1, j] = Ch)Or(Grid[y1, j] = '*') Then Inc(Dem);
        If Dem <> ((y2-y1)+(x2-x1))*2 Then IsFrame := False;
      End;
  End;

Function SearchFrame(y, x : Byte; CheckFrame : Boolean) : Boolean;
  Var
    i, j, y2, x2, y1, x1 : Byte;
    FoundFrame : Boolean;
  Begin
    FoundFrame := False;
    y1 := y;
    x1 := x;
    If IsFrame(y1, x1, y2, x2, CheckFrame) Then
      Begin
        FoundFrame := True;
        Inc(Count);
        ThuTu[Count] := Grid[y, x];
        For i := y1 To y2 Do
          Begin
            Grid[i, x1] := '*';
            Grid[i, x2] := '*';
          End;
        For j := x1 To x2 Do
          Begin
            Grid[y1, j] := '*';
            Grid[y2, j] := '*';
          End;
        Show_Grid;
      End;
    SearchFrame := FoundFrame;
  End;

Function Tim(CheckFrame : Boolean) : Boolean;
  Var
    i, j : Byte;
    FoundFrame : Boolean;
    Ch : Char;
  Begin
    FillChar(DaXet, SizeOf(DaXet), False);
    i := 1;
    FoundFrame := False;
    While (i <= M)And(Not FoundFrame) Do
      Begin
        j := 1;
        While (j <= N)And(Not FoundFrame) Do
          Begin
            If (Grid[i, j] <> '.')And(Grid[i, j] <> '*') Then
              If DaXet[Grid[i, j]] = False Then
                Begin
                  Ch := Grid[i, j];
                  If SearchFrame(i, j, CheckFrame) Then FoundFrame := True;
                  DaXet[Ch] := True;
                End;
            Inc(j);
          End;
        Inc(i);
      End;
    Tim := FoundFrame;
  End;

Procedure Thuc_Hien;
  Begin
    Count := 0;
    Repeat
      If Tim(True) = False Then Tim(False);
    Until Count = FrameCount;
  End;

Procedure Ghi_Ket_Qua;
  Var
    TenTepKQ : String;
    F : Text;
    i : Byte;
  Begin
    TenTepKQ := 'frame.out';
{    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To FrameCount Do
      Write(F, ThuTu[i]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;{}
END.