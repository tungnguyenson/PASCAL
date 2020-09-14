{$M 4096,0,655360}
Uses CRT;

Const
  Max = 100;
  Direct : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Type
  LOV = Array[0..Max+1, 0..Max+1] Of Byte;
  QueueType = Array[1..Max*Max, 1..2] Of Byte;
  HCN = Record
    y1, x1, y2, x2 : Byte;
  End;

Var
  L : LOV;
  Xet : Array[1..Max, 1..Max] Of Byte;
  Kq : Array[1..Max*Max Div 16] Of HCN;
  M, N : Byte;
  SoMien, DemKQ : Word;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    TenTepDL := 'KHUNG2.INP';
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    FillChar(L, SizeOf(L), 0);
    For i := 1 To M Do
      For  j := 1 To N Do
        Read(F, L[i, j]);
    Close(F);
  End;

Function Explore(y, x : Byte; O, I : HCN; KTra : Boolean) : Boolean;
  Var
    Queue : ^QueueType;
    Left, Right : Word;
    d, xn, yn : Byte;
  Begin
{    Inc(SoMien);}
    Explore := True;
    New(Queue);
    FillChar(Queue^, Sizeof(Queue^), 0);
    Left := 1;
    Right := 1;
    Queue^[Right, 1] := y;
    Queue^[Right, 2] := x;
    L[y, x] := SoMien;
    While (Left <= Right) Do
      Begin
        For d := 1 To 4 Do
          Begin
            yn := y+Direct[d, 1];
            xn := x+Direct[d, 2];
            If KTra Then
              Begin
                If (yn >= O.y1)And(yn <= O.y2)And(xn >= O.x1)And(xn <= O.x2)And
                   ((yn < I.y1)Or(yn > I.y2)Or(xn < I.x1)Or(xn > I.x2)) Then
                  If L[yn, xn] = 1 Then
                    Begin
                      L[yn, xn] := SoMien;
                      Inc(Right);
                      Queue^[Right, 1] := yn;
                      Queue^[Right, 2] := xn;
                    End
                   Else If L[yn, xn] = 0 Then
                      Begin
                        Explore := False;
                        Dispose(Queue);
                        Exit;
                      End;
              End
             Else
              If (yn >= 1)And(yn <= M)And(xn >= 1)And(xn <= N) And
                 (L[yn, xn] = 1) Then
                Begin
                  L[yn, xn] := SoMien;
                  Inc(Right);
                  Queue^[Right, 1] := yn;
                  Queue^[Right, 2] := xn;
                End;
          End;
        Inc(Left);
        y := Queue^[Left, 1];
        x := Queue^[Left, 2];
      End;
    Dispose(Queue);
  End;

Function Kiem_Tra_Vien(Trong, Ngoai : HCN) : Boolean;
  Var
    i : Byte;
  Begin
    Kiem_Tra_Vien := True;
    For i := Ngoai.x1 To Ngoai.x2 Do
      If ((L[Ngoai.y1-1, i] = 1)And(Ngoai.y1 > 1))
        Or((L[Ngoai.y2+1, i] = 1)And(Ngoai.y2 < M))Then
        Begin
          Kiem_Tra_Vien := False;
          Exit;
        End;
    For i := Ngoai.y1 To Ngoai.y2 Do
      If ((L[i, Ngoai.x1-1] = 1)And(Ngoai.x1 > 1))
        Or((L[i, Ngoai.x2+1] = 1)And(Ngoai.x2 < N))Then
        Begin
          Kiem_Tra_Vien := False;
          Exit;
        End;
    For i := Trong.x1 To Trong.x2 Do
      If (L[Trong.y1, i] = 1)Or(L[Trong.y2, i] = 1) Then
        Begin
          Kiem_Tra_Vien := False;
          Exit;
        End;
    For i := Trong.y1 To Trong.y2 Do
      If (L[i, Trong.x1] = 1)Or(L[i, Trong.x2] = 1) Then
        Begin
          Kiem_Tra_Vien := False;
          Exit;
        End;
  End;

Procedure Thuc_Hien;
  Var
    i, j, a, b : Byte;
    Trong, Ngoai : HCN;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    DemKQ := 0;
    SoMien := 9;
    For i := 1 To M Do
      For j := 1 To N Do
        If L[i, j] = 1 Then
          Begin
            Ngoai.y1 := i;
            Ngoai.x1 := j;
            Ngoai.y2 := Ngoai.y1;
            Ngoai.x2 := Ngoai.x1;
            While (Ngoai.y2 < M)And(L[Ngoai.y2+1, Ngoai.x1] = 1) Do Inc(Ngoai.y2);
            While (Ngoai.x2 < N)And(L[Ngoai.y1, Ngoai.x2+1] = 1) Do Inc(Ngoai.x2);
            If (Ngoai.y2-Ngoai.y1 >= 2)And(Ngoai.x2-Ngoai.x1 >= 2) Then
              Begin
                Trong.y1 := Ngoai.y1;
                Trong.x1 := Ngoai.x1;
                While (Trong.y1 < Ngoai.y2)And(L[Trong.y1, Trong.x1] = 1) Do
                  Begin
                    Inc(Trong.y1);
                    Trong.x1 := Ngoai.x1;
                    While (Trong.x1 < Ngoai.x2)And
                          (L[Trong.y1, Trong.x1] = 1) Do Inc(Trong.x1);
                  End;
                Trong.x2 := Trong.x1;
                Trong.y2 := Trong.y1;
                While (Trong.y2 < Ngoai.y2)And(L[Trong.y2+1, Trong.x1] = 0) Do Inc(Trong.y2);
                While (Trong.x2 < Ngoai.x2)And(L[Trong.y1, Trong.x2+1] = 0) Do Inc(Trong.x2);
                If (Trong.y1 <= Trong.y2)And(Trong.x1 <= Trong.x2)And
                  Kiem_Tra_Vien(Trong, Ngoai) Then
                  Begin
                    If Explore(Ngoai.y1, Ngoai.x1, Ngoai, Trong, True) Then
                      Begin
                        Inc(DemKQ);
                        KQ[DemKQ] := Ngoai;
                      End;
                  End Else Explore(Ngoai.y1, Ngoai.x1, Ngoai, Trong, False);
              End  Else Explore(Ngoai.y1, Ngoai.x1, Ngoai, Trong, False);
          End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    TenTepKQ : String;
    F : Text;
    i : Word;
  Begin
    TenTepKQ := '';
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, DemKQ);
    For i := 1 To DemKQ Do
      WriteLn(F, KQ[i].y1, ' ', KQ[i].x1, ' ', KQ[i].y2, ' ', KQ[i].x2);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.