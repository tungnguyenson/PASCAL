{Alg : HUNGARI}

Uses CRT;

Const
  TenTepDL = 'SHOP.IN1';
  TenTepKQ = '';
  MaxN = 100;

Var
  C : Array[1..MaxN, 1..MaxN] Of Word;
  M0 : Array[1..MaxN, 1..MaxN] Of Byte;
  CotT, HangT : Array[1..MaxN] Of Byte;
  Dem0 : Byte;
  N : Byte;

Procedure Show_Array;
  Var
    i, j : Byte;
  Begin
    ClrScr;
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(C[i, j]:3);
        WriteLn;
      End;
    For i := 1 To N Do
      For j := 1 To N Do
        If M0[i, j] = 1 Then
          Begin
            GoToXY(j*3+1, i);
            Write('*');
          End;
{    ReadLn;{}
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu(N : Byte);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, N);
    Randomize;
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(F, Random(9)+1, ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Rut_Gon;
  Var
    i, j : Byte;
    MH, MC : Array[1..MaxN] Of Word;
  Begin
    For i := 1 To N Do MH[i] := C[i, 1];
    For i := 1 To N Do
      For j := 1 To N Do
        If C[i, j] < MH[i] Then MH[i] := C[i, j];
    For i := 1 To N Do
      For j := 1 To N Do
        C[i, j] := C[i, j]-MH[i];
    For j := 1 To N Do MC[j] := C[1, j];
    For i := 1 To N Do
      For j := 1 To N Do
        If C[i, j] < MC[j] Then MC[j] := C[i, j];
    For i := 1 To N Do
      For j := 1 To N Do
        C[i, j] := C[i, j]-MC[j];
  End;

Procedure Mark_0;
  Var
    i, j : Byte;
    Xet0 : Array[1..MaxN] Of Byte;
  Begin
    FillChar(M0, SizeOf(M0), 0);
    FillChar(Xet0, SizeOf(Xet0), 0);
    Dem0 := 0;
    For i := 1 To N Do
      Begin
        j := 1;
        While (j <= N)And((C[i, j] <> 0)Or(Xet0[j] = 1)) Do Inc(j);
        If j <= N Then
          Begin
            M0[i, j] := 1;
            Xet0[j] := 1;
            Inc(Dem0);
          End;
      End;
  End;

Procedure Khoi_Tao;
  Var
    i : Byte;
  Begin
    Rut_Gon;
    Mark_0;
    Show_Array;
    FillChar(HangT, Sizeof(HangT), 0);
    FillChar(CotT, Sizeof(CotT), 0);
  End;

Procedure Tim(y, x : Byte);
  Var
    Queue : Array[1..MaxN, 1..2] Of Byte;
    Left, Right : Word;
    i, j : Byte;
  Begin
    Queue[1, 1] := y;
    Queue[1, 2] := x;
    Right := 1;
    Repeat
      If M0[Queue[Right, 1], Queue[Right, 2]] = 0 Then
        Begin
          i := 1;
          While (i <= N)And(M0[i, x] = 0) Do Inc(i);
          If i <= N Then
            Begin
              Inc(Right);
              Queue[Right, 1] := i;
              Queue[Right, 2] := x;
              y := i;
            End
           Else
            Begin
              For i := 1 To Right Do
                M0[Queue[i, 1], Queue[i, 2]] := 2-M0[Queue[i, 1], Queue[i, 2]];
            End;
        End
       Else
        Begin
          j := 1;
          While (j <= N)And((M0[y, j] = 1)Or(C[i, j] <> 0)) Do Inc(j);
          If j <= N Then
            Begin
              Inc(Right);
              Queue[Right, 1] := y;
              Queue[Right, 2] := j;
              x := j;
            End
           Else
            Begin
              CotT[x] := 1;
              Dec(Right, 2);
            End;
        End;
    Until False;
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, l : Byte;
  Begin
    Khoi_Tao;
    If Dem0 < N Then
      Begin
        k := 1;
        i := 0;
        While (k <> 0)And(i < N) Do
          Begin
            Inc(i);
            k := 0;
            For j := 1 To N Do
              If (C[i, j] = 0)And(M0[i, j] = 1)And(CotT[j] = 0) Then k := i;
          End;
        If k <> 0 Then
          Begin
            j := 1;
            While (C[i, j] <> 0)Do Inc(j);
            Tim(i, j);
          End;
      End;
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu(5);{}
  Doc_Du_Lieu;
  Thuc_Hien;
END.