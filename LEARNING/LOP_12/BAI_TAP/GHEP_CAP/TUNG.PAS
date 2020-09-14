Program Ghep_Cap;

Uses CRT;

Const
  MaxN = 100;

Var
  C : Array[1..MaxN, 1..MaxN] Of Integer;
  XetX, XetY : Array[1..MaxN] Of Byte;
  Queue, F, UN : Array[1..MaxN*2] Of Integer;
  N : Byte;
  SoBuocLap, Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    TenTepDL := 'gc.i1';
{    Write('Nhap ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
    Max : Integer;
  Begin
    FillChar(F, SizeOf(F), 0);
    FillChar(XetX, SizeOf(XetX), 0);
    FillChar(XetY, SizeOf(XetY), 0);
    For i := 1 To N Do
      Begin
        Max := C[i, 1];
        For j := 1 To N Do
          If C[i, j] > Max Then Max := C[i, j];
        F[i] := Max;
      End;
  End;

Function Dinh_Tu_Do : Byte;
  Var
    i : Byte;
  Begin
    Dinh_Tu_Do := 0;
    i := 1;
    While (i <= N)And(XetX[i] <> 0) Do Inc(i);
    If i <= N Then Dinh_Tu_Do := i;
  End;

Function Tim_Duong_Tang_Cap_Ghep(u : Byte; Var z : Byte) : Boolean;
  Var
    Left, Right : Integer;
    i, j : Byte;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    FillChar(UN, SizeOf(UN), 0);
    Left := 1;
    Right := 1;
    Queue[Left] := u;
    UN[u] := u;
    While Left <= Right Do
      Begin
        If u <= N Then
          Begin
            For j := 1 To N Do
              If (F[u]+F[j+N] = C[u, j])And(UN[j+N] = 0) Then
                Begin
                  Inc(Right);
                  Queue[Right] := j+N;
                  UN[j+N] := u;
                End;
          End
         Else If XetY[u-N] = 0 Then
          Begin
            Tim_Duong_Tang_Cap_Ghep := True;
            z := u;
            Exit;
          End
         Else
          Begin
            j := XetY[u-N];
            Inc(Right);
            Queue[Right] := j;
            UN[j] := u;
          End;
        Inc(Left);
        u := Queue[Left];
      End;
    Tim_Duong_Tang_Cap_Ghep := False;
    z := u;
  End;

Procedure Tang_Cap_Ghep(u, z : Byte);
  Var
    y, x : Byte;
    ThuocY : Boolean;
  Begin
    ThuocY := True;
    y := z;
    While y <> u Do
      Begin
        x := UN[y];
        If ThuocY Then
          Begin
            XetX[x] := y-N;
            XetY[y-N] := x;
          End;
        y := x;
        ThuocY := Not ThuocY;
      End;
  End;

Procedure Sua_Nhan;
  Var
    Min, D : Integer;
    i, j : Byte;
  Begin
    Min := $7FFF;
    For i := 1 To N Do
      If UN[i] > 0 Then
        For j := N+1 To N*2 Do
          If UN[j] = 0 Then
            Begin
              D := F[i]+F[N]-C[i, j-N];
              If D < Min Then Min := D;
            End;
    For i := 1 To N Do
      If UN[i] > 0 Then F[i] := F[i]-Min;
    For j := 1 To N Do
      If UN[j+N] > 0 Then F[j+N] := F[j+N]+Min;
  End;

Procedure Ghi_Ket_Qua;
  Var
    TenTepKQ : String;
    F : Text;
    i : Byte;
  Begin
    TenTepKQ := '';
{    Write('Nhap ten tep ghi ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do Write(F, XetX[i], ' ');
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    u, z : Byte;
  Begin
    Khoi_Tao;
    u := Dinh_Tu_Do;
    SoBuocLap := 0;
    While u > 0 Do
      Begin
        If Tim_Duong_Tang_Cap_Ghep(u, z) Then
          Begin
            Tang_cap_Ghep(u, z);
            u := Dinh_Tu_Do;
          End
         Else Sua_Nhan;
        Inc(SoBuocLap);
      End;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Time := MemL[0:1132];
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn;
  WriteLn('So buoc lap: ', SoBuocLap);
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-Time)/18.2:10:7, ' giay');
  Write('Nhan phim Enter de ket thuc chuong trinh ...');
  ReadLn;
END.