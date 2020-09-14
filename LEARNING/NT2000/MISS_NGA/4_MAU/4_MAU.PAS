Uses CRT;

Const
  TenTepDL = 'BL1.IN4';
  TenTepKQ = 'BL1.OUT';
  MaxMN = 20;
  MaxHinh = MaxMN*MaxMN*4;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1),(1, 0));

Type
  Hinh = Record
    y, x, ys, xs, ye, xe : Byte;
    Nhom, DienTich : Word;
  End;
  Hinh2 = Record
    Height, Width : Byte;
    Ar : Array[1..MaxMN, 1..MaxMN] Of Word;
  End;
  ToaDo = Array[1..MaxMN*MaxMN, 1..2] Of Byte;

Var
  Bang : Array[0..MaxMN+1, 0..MaxMN+1] Of Char;
  Mien : Array[0..MaxMN+1, 0..MaxMN+1] Of Word;
  H : Array[1..MaxHinh] Of Hinh;
  Queue : ToaDo;
  SoMien, SoNhom : Word;
  M, N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    FillChar(Bang, SizeOf(Bang), #0);
    For i := 1 To M Do
      For j := 1 To N Do
        If j < N Then Read(F, Bang[i, j])
                 Else ReadLn(F, Bang[i, j]);
    Close(F);
  End;

Procedure BFS(i : Word);
  Var
    j, u, v  : Byte;
    Left, Right : Word;
  Begin
    Left := 1;
    Right := 1;
    H[i].ys := H[i].y;
    H[i].xs := H[i].x;
    H[i].ye := H[i].ys;
    H[i].xe := H[i].xs;
    Queue[Right, 1] := H[i].y;
    Queue[Right, 2] := H[i].x;
    Mien[H[i].y, H[i].x] := i;
    While Left <= Right Do
      Begin
        For j := 1 To 4 Do
          Begin
            u := Queue[Left, 1]+Next[j, 1];
            v := Queue[Left, 2]+Next[j, 2];
            If (Mien[u, v] = 0)And(Bang[u, v] = Bang[H[i].y, H[i].x]) Then
              Begin
                Inc(Right);
                Queue[Right, 1] := u;
                Queue[Right, 2] := v;
                Mien[u, v] := i;
                If u < H[i].ys Then H[i].ys := u;
                If u > H[i].ye Then H[i].ye := u;
                If v < H[i].xs Then H[i].xs := v;
                If v > H[i].xe Then H[i].xe := v;
              End;
          End;
        Inc(Left);
      End;
    H[i].DienTich := Right;
  End;

Procedure Quay_90_Do(H1 : Hinh2; Var H2 : Hinh2);
  Var
    i, j : Byte;
  Begin
    H2.Height := H1.Width;
    H2.Width := H1.Height;
    For i := 1 To H1.Height Do
      For j := 1 To H1.Width Do
        H2.Ar[j, H1.Height-i+1] := H1.Ar[i, j];
  End;

Procedure Conv(H1 : Hinh; Var H2 : Hinh2);
  Var
    i, j : Byte;
  Begin
    H2.Height := H1.ye-H1.ys+1;
    H2.Width := H1.xe-H1.xs+1;
    For i := H1.ys To H1.ye Do
      For j := H1.xs To H1.xe Do
        With H1 Do
          If Mien[i, j] = Mien[y, x] Then H2.Ar[i-ys+1, j-xs+1] := 1
           Else H2.Ar[i-ys+1, j-xs+1] := 0;
  End;

Function Compare(H1, H2 : Word) : Boolean;
  Var
    A : Array[1..4] Of Hinh2;
    B : Hinh2;
    i, j, k : Byte;
    Equal : Boolean;
  Begin
    If H[H1].DienTich = H[H2].DienTich Then
      Begin
        Conv(H[H1], A[1]);
        Quay_90_Do(A[1], A[2]);
        Quay_90_Do(A[2], A[3]);
        Quay_90_Do(A[3], A[4]);
        Conv(H[H2], B);
        Compare := False;
        For i := 1 To 4 Do
          If (A[i].Height = B.Height)And(A[i].Width = B.Width) Then
            Begin
              Equal := True;
              For j := 1 To A[i].Height Do
                For k := 1 To A[i].Width Do
                  If A[i].Ar[j, k] XOR B.Ar[j, k] <> 0 Then
                    Equal := False;
              If Equal = True Then Compare := True;
            End;
      End
     Else Compare := False;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Word;
  Begin
    FillChar(Mien, SizeOf(Mien), 0);
    SoMien := 0;
    For i := 1 To M Do
      For j := 1 To N Do
        If Mien[i, j] = 0 Then
          Begin
            Inc(SoMien);
            H[SoMien].y := i;
            H[SoMien].x := j;
            BFS(SoMien);
          End;
    For i := 1 To SoMien Do H[i].Nhom := 0;
    SoNhom := 0;
    For i := 1 To SoMien Do
      If H[i].Nhom = 0 Then
      Begin
        Inc(SoNhom);
        H[i].Nhom := SoNhom;
        If i < SoMien Then
          For j := i+1 To SoMien Do
            If Compare(i, j) Then H[j].Nhom := SoNhom;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j : Byte;
    k : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SoMien);
    For i := 1 To M Do
      For j := 1 To N Do
        If j < N Then Write(F, Mien[i, j]:4)
                 Else WriteLn(F, Mien[i, j]:4);
    WriteLn(F, SoNhom);
    For i := 1 To M Do
      For j := 1 To N Do
        If j < N Then Write(F, H[Mien[i, j]].Nhom:4)
                 Else WriteLn(F, H[Mien[i, j]].Nhom:4);
    For k := 1 To SoMien Do
      WriteLn(F, H[k].DienTich);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.