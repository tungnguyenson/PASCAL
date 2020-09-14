{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  MaxMN = 100;
  Next : Array[1..4, 1..2] Of ShortInt = ((0, 1), (-1, 0), (0, -1), (1, 0));
  TenHuong : Array[1..4] Of Char = ('D', 'B', 'T' ,'N');
  East  = 0;
  North = 1;
  West  = 2;
  South = 3;
  ChiPhiPha = MaxMN*MaxMN+1;
  VoCung = $7F7F7F7F;

Type
  Mang1Chieu = Array[1..MaxMN*MaxMN] Of Word;
  MangToaDo = Array[1..MaxMN*(MaxMN+2), 1..2] Of Byte;
  MangNhan = Array[1..MaxMN, 0..MaxMN+1] Of LongInt;

Var
  Xet, C : Array[0..MaxMN+1, 0..MaxMN+1] Of Byte;
  Nhan : ^MangNhan;
  Queue : MangToaDo;
  SoMien, Top : Word;
  M, N : Byte;
  F_Out : Text;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);
    Assign(F, TenTepDL);
    Reset(F);
    FillChar(C, SizeOf(C), 0);
    ReadLn(F, M ,N);
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          Read(F, C[i, j]);
        End;
    Close(F);
  End;

Function BFS(Var y, x : Byte; CheckRange : Boolean) : Word;
  Var
    i : Byte;
    Left, Right : Word;
    OutOfRange : Boolean;
  Begin
    Left := 1;
    Right := 1;
    Queue[1, 1] := y;
    Queue[1, 2] := x;
    Xet[y, x] := 2+1;
    OutOfRange := False;
    While (Left <= Right)And(Not OutOfRange) Do
      Begin
        If (x = N)And(C[y, x] And (1 Shl East) <> 0)And CheckRange Then
          OutOfRange := True
         Else
          Begin
            For i := East To South Do
              If (C[y, x] And (1 Shl i) <> 0)And(x+Next[i+1, 2] > 0)And
                 (Xet[y+Next[i+1, 1], x+Next[i+1, 2]] = 0) Then
                Begin
                  Inc(Right);
                  Queue[Right, 1] := y+Next[i+1, 1];
                  Queue[Right, 2] := x+Next[i+1, 2];
                  Xet[y+Next[i+1, 1], x+Next[i+1, 2]] := (i+2) Mod 4+1;
                End;
            Inc(Left);
            y := Queue[Left, 1];
            x := Queue[Left, 2];
          End;
      End;
    If (CheckRange) And (Not OutOfRange) Then BFS := M*M+1
     Else BFS := Right;
  End;

Function Phan_1 : Boolean;
  Var
    i, j, k, l : Byte;
    y, x, ys, ymin : Byte;
    Min, CP : Word;
    DuongDi : ^Mang1Chieu;
  Begin
    New(DuongDi);
    FillChar(DuongDi^, SizeOf(DuongDi^), 0);
    Min := M*N+1;
    For i := 1 To M Do
      If C[i, 1] And (1 Shl West) <> 0 Then
        Begin
          FillChar(Xet, SizeOf(Xet), 0);
          y := i;
          x := 1;
          CP := BFS(y, x, True);
          If CP <> M*N+1 Then
            Begin
              j := 0;
              ys := y;
              Repeat
                Inc(j);
                k := Xet[y, x]-1;
                y := y+Next[k+1, 1];
                x := x+Next[k+1, 2];
              Until x = 0;
              If j < Min Then
                Begin
                  x := N;
                  ymin := y;
                  Min := j;
                  For j := Min DownTo 1 Do
                    Begin
                      k := Xet[ys, x]-1;
                      DuongDi^[j] := (k+2) Mod 4;
                      ys := ys+Next[k+1, 1];
                      x := x+Next[k+1, 2];
                    End;
                End;
            End;
        End;
    Phan_1 := False;
    If Min <> M*N+1 Then
      Begin
        Phan_1 := True;
        WriteLn(F_Out, Min);
        Write(F_Out, ymin, ' ');
        For i := 1 To Min Do Write(F_Out, TenHuong[DuongDi^[i]+1]);
        Write(F_Out, 'D');
      End
     Else WriteLn(F_Out, 0);
    Dispose(DuongDi);
  End;

Procedure Tim_Duong_Di;
  Var
    j, k, y, x, ys, xs : Byte;
    Stack : ^MangToaDo;
    i, Top : Word;
    Min, CP : LongInt;
  Begin
    New(Stack);
    FillChar(Nhan^, SizeOf(Nhan^), $7F);
    FillChar(Stack^, Sizeof(Stack^), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    Top := 0;
    For i := 1 To M Do
      Begin
        Nhan^[i, 0] := 0;
        Xet[i, 0] := 9;
        Inc(Top);
        Stack^[Top, 1] := i;
      End;
    For i := 1 To M Do Xet[i, 0] := 9;
    Repeat
      Min := VoCung;
      For i := 1 To Top Do
        Begin
          y := Stack^[i, 1];
          x := Stack^[i, 2];
          For j := East To South Do
            If (y+Next[j+1, 1] > 0)And(y+Next[j+1, 1] <= M) And
               (x+Next[j+1, 2] >= 0)And(x+Next[j+1, 2] <= N) Then
              If  (Xet[y+Next[j+1, 1], x+Next[j+1, 2]] = 0) Then
              Begin
                CP := Nhan^[y, x];
                If C[y, x] And (1 Shl j) <> 0 Then CP := CP+1
                                              Else CP := CP+ChiPhiPha;
                If CP < Min Then
                  Begin
                    Min := CP;
                    ys := y+Next[j+1, 1];
                    xs := x+Next[j+1, 2];
                    k := j;
                  End;
              End;
        End;
      If Min <> VoCung Then
        Begin
          Inc(Top);
          Stack^[Top, 1] := ys;
          Stack^[Top, 2] := xs;
          Nhan^[ys, xs] := Min;
          Xet[ys, xs] := (k+2) Mod 4+1;
        End;
    Until Min = VoCung;
    Dispose(Stack);
  End;

Procedure Phan_2;
  Var
    i, j, k, y, ys, x : Byte;
    DuongDi : ^Mang1Chieu;
    Min : LongInt;
  Begin
    For i := 1 To M-1 Do
      Begin
        C[i, 0] := C[i, 0]+(1 Shl South);
        C[i+1, 0] := C[i+1, 0]+(1 Shl North);
        If C[i, 1] And (1 Shl West) <> 0 Then C[i, 0] := C[i, 0]+(1 Shl East);
      End;
    If C[M, 1] And (1 Shl West) <> 0 Then C[M, 0] := C[M, 0]+(1 Shl East);
    New(Nhan);
    Tim_Duong_Di;
    Min := VoCung;
    For i := 1 To M Do
      If C[i, N] And (1 Shl East) = 0 Then
        Nhan^[i, N] := Nhan^[i, N]+ChiPhiPha;
    For i := 1 To M Do
      If Min > Nhan^[i, N] Then
        Begin
          y := i;
          Min := Nhan^[i, N];
        End;
    x := N;
    ys := y;
    WriteLn(F_Out, Min Div ChiPhiPha);
    New(DuongDi);
    FillChar(DuongDi^, SizeOf(DuongDi^), 0);
    i := 0;
    Repeat
      Inc(i);
      j := Xet[y, x]-1;
      y := y+Next[j+1, 1];
      x := x+Next[j+1, 2];
    Until x < 1;
    x := N;
    For j := i DownTo 1 Do
      Begin
        k := Xet[ys, x]-1;
        DuongDi^[j] := (k+2) Mod 4;
        ys := ys+Next[k+1, 1];
        x := x+Next[k+1, 2];
      End;
    Write(F_Out, y, ' ');
    For j := 1 To i Do
      Write(F_Out, TenHuong[DuongDi^[j]+1]);{}
    Write(F_Out, 'D');
    Dispose(DuongDi);
    Dispose(Nhan);
  End;

Procedure Thuc_Hien;
  Var
    TenTepKQ : String;
    i, j : Byte;
  Begin
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);
    Assign(F_Out, TenTepKQ);
    Rewrite(F_Out);
    Time := MemL[0:1132];
    If Phan_1 = False Then Phan_2;{}
    Close(F_Out);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  WriteLn;
  WriteLn((MemL[0:1132]-Time)/18.2:10:5);
  ReadLn;
END.