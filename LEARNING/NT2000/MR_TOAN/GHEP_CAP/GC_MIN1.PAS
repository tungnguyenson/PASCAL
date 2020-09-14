{ Doi trong so }
Program Ghep_Cap_Min_Day_Du;

Uses CRT;

Const
  MaxSize = 100;
  TenTepDL = 'gc.in3';
  TenTepKQ = 'gc.out';

Var
  C, Luu : Array[1..MaxSize, 1..MaxSize] Of Integer;
  F, Queue, Q : Array[1..2*MaxSize] Of Word;
  PX, PY : Array[1..MaxSize] Of Byte;
  N, u, z : Byte;
  ThoaMan : Boolean;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    Readln(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    Close(F);
  End;

Procedure Doi_Trong_So;
  Var
    i, j : Byte;
    MinHang, MinCot : Array[1..MaxSize] Of Integer;
  Begin
    For i := 1 To N Do
      For j := 1 To N Do
        C[i, j] := -C[i, j];
    For i := 1 To N Do
      Begin
        MinHang[i] := MaxInt;
        For j := 1 To N Do
          If MinHang[i] > C[i, j] Then MinHang[i] := C[i, j];
      End;
    For i := 1 To N Do
      Begin
        MinCot[i] := MaxInt;
        For j := 1 To N Do
          If MinCot[i] > C[i, j] Then MinCot[i] := C[i, j];
      End;
    For i := 1 To N Do
      For j := 1 To N Do
        C[i, j] := C[i, j]-MinHang[i];
    For i := 1 To N Do
      For j := 1 To N Do
        C[i, j] := C[i, j]-MinCot[i];
  End;

Procedure Khoi_Tao;
  Var
    i, j, k : Word;
  Begin
    Luu := C;
    Doi_Trong_So;
    Fillchar(F, SizeOf(F), 0);
    Fillchar(PX, SizeOf(PX), 0);
    Fillchar(PY, SizeOf(PY), 0);
    For i := 1 To N Do
      Begin
        k := C[i, 1];
        For j := 2 To N Do
          If k < C[i, j] Then k := C[i, j];
        F[i] := k;
      End;
  End;

Function Tim_Dinh_Tu_Do : Word;
  Var
    i : Byte;
  Begin
    Tim_Dinh_Tu_Do := 0;
    i := 1;
    While (i <= N)And(PX[i] <> 0) Do Inc(i);
    If i <= N Then Tim_Dinh_Tu_Do := i;
  End;

Procedure Tim_Duong_Tang_Cap_Ghep;
  Var
    Left, Right : Word;
    w, v : Byte;
  Begin
    Fillchar(Q, SizeOf(Q), 0);
    Left := 0;
    Right := 1;
    Queue[1] := u;
    Q[u] := u;
    While Left < Right Do
      Begin
        Inc(Left);
        v := Queue[Left];
        If v <= n Then
          Begin
            For w := N+1 To 2*N Do
              If (F[v]+F[w] = C[v, w-N]) And (Q[w] = 0) Then
                Begin
                  Inc(Right);
                  Queue[Right] := w;
                  Q[w] := v;
                End;
          End
         Else
          If PY[v-n] = 0 Then
            Begin
              ThoaMan := True;
              z := v;
              Exit;
            End
           Else
            Begin
              w := PY[v-n];
              Inc(Right);
              Queue[Right] := w;
              Q[w] := v;
            End;
      End;
    ThoaMan := False;
    z := v;
  End;

Procedure Tang_Cap_Ghep;
  Var
    i, j : Byte;
    ThuocY : Boolean;
  Begin
    i := z;
    ThuocY := True;
    While i <> u Do
      Begin
        j := Q[i];
        If ThuocY Then
          Begin
            PX[j] := i-n;
            PY[i-n] := j;
          End;
        i := j;
        ThuocY := Not ThuocY;
      End;
  End;

Procedure Sua_Nhan;
  Var
    Min, D : Word;
    i, j : Byte;
  Begin
    Min := MaxInt;
    For i := 1 To N Do
      If Q[i]>0 Then
        For j := N+1 To 2*N Do
          If Q[j] = 0 Then
            Begin
              D := F[i]+F[j]-C[i, j-N];
              If D < Min Then Min := D;
            End;
    For i := 1 To N Do
      If Q[i] > 0 Then F[i] := F[i]-Min;
    For j := N+1 To 2*N Do
      If Q[j] > 0 Then F[j] := F[j]+Min;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    TongHQ : LongInt;
    i : Byte;
  Begin
    TongHQ := 0;
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do
      Begin
        TongHQ := TongHQ+Luu[i, PX[i]];
        Write(F, PX[i], ' ');
      End;
    WriteLn(F);
    WriteLn(F, TongHQ);{}
    Close(F);
  End;

Procedure Thuc_Hien;
  Begin
    u := Tim_Dinh_Tu_Do;
    While u <> 0 Do
      Begin
        Tim_Duong_Tang_Cap_Ghep;
        If ThoaMan Then
          Begin
            Tang_Cap_Ghep;
            u := Tim_Dinh_Tu_Do;
          End
        Else Sua_Nhan;
      End;
  End;

Begin
  Doc_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
End.