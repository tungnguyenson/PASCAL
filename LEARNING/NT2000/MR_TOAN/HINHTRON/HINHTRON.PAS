{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  Max = 100;
  TenTepDL = 'BL3.IN2';
  TenTepKQ = 'BL3.OU2';

Type
  HinhTron = Record
    x, y, r : Real;
  End;
  Layer = Array[1..Max] Of Byte;

Var
  HT : Array[1..Max] Of HinhTron;
  Trong : Array[1..Max, 1..Max] Of Byte;
  TT, Deg : Array[1..Max] Of Byte;
  Lop1, Lop2, LopMin : Layer;
  SoPTLop : Array[1..Max] Of Word;
  N, SoLopMin : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
    x, y, R : Real;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        ReadLn(F, x, y, R);
        HT[i].x := Round(x);
        HT[i].y := Round(y);
        HT[i].R := Round(R);
      End;
    Close(F);
  End;

Function KhoangCach(x1, y1, x2, y2 : Real) : Real;
  Begin
    KhoangCach := Sqrt(Sqr(x1-x2)+Sqr(y1-y2));
  End;

Function NamTrong(h1, h2 : Byte) : Boolean;
  Var
    i : Byte;
    KC : Real;
  Begin
    If HT[h1].r > HT[h2].r Then
      Begin
        i := h1;
        h1 := h2;
        h2 := i;
      End;
    NamTrong := KhoangCach(HT[h1].x, HT[h1].y, HT[h2].x, HT[h2].y)+HT[h1].r <= HT[h2].R;
  End;

Procedure SwapByte(Var So1, So2 : Byte);
  Var
    Temp : Byte;
  Begin
    Temp := So1;
    So1 := So2;
    So2 := Temp;
  End;

Procedure Khoi_Tao;
  Var
    i, j, k : Word;
  Begin
    FillChar(Trong, SizeOf(Trong), 0);
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If NamTrong(i, j) Then
          Begin
            Trong[i, j] := 1;
            Trong[j, i] := 1;
          End;
  End;

Procedure Sort_1;
  Var
    HT0 : HinhTron;
    i, j, k : Word;
  Begin
    For i := 1 To N Do TT[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If HT[i].r < HT[j].r Then
          Begin
            SwapByte(TT[i], TT[j]);
            HT0 := HT[i];
            HT[i] := HT[j];
            HT[j] := HT0;
          End;
  End;

Procedure Sort_2;
  Var
    HT0 : HinhTron;
    i, j, k : Word;
  Begin
    For i := 1 To N Do TT[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Deg[i] < Deg[j] Then
          Begin
            SwapByte(Deg[i], Deg[j]);
            SwapByte(TT[i], TT[j]);
            HT0 := HT[i];
            HT[i] := HT[j];
            HT[j] := HT0;
          End;
  End;

Procedure Tham_Lam(Var Lop : Layer);
  Var
    i, j, k, l : Word;
  Begin
    FillChar(Lop, SizeOf(Lop), 0);
    i := 0;
    Repeat
      Inc(i);
      k := 1;
      While (k <= N)And(Lop[TT[k]] <> 0) Do Inc(k);
      If k <= N Then
        Begin
          Lop[TT[k]] := i;
          For j := k+1 To N Do
            If Lop[TT[j]] = 0 Then
              Begin
                l := 1;
                While (l <= N)And((Trong[TT[j], TT[l]] = 0)Or(Lop[TT[l]] <> i)) Do Inc(l);
                If l > N Then Lop[TT[j]] := i;
              End;
        End;
    Until k > N;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j, k : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    SoLopMin := 0;
    For i := 1 To N Do
      If SoLopMin < LopMin[i] Then SoLopMin := LopMin[i];
    WriteLn(F, SoLopMin);
    For i := 1 To SoLopMin Do
      Begin
        k := 0;
        For j := 1 To N Do
          If LopMin[j] = i Then Inc(k);
        Write(F, k);
        For j := 1 To N Do
          If LopMin[j] = i Then Write(F, ' ', j);
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j, k : Word;
  Begin
    FillChar(LopMin, SizeOf(LopMin), 0);
    Sort_1;
    Tham_Lam(Lop1);
    Sort_2;
    Tham_Lam(Lop2);
    j := 0;
    For i := 1 To N Do
      If Lop1[i] > j Then j := Lop1[i];
    k := 0;
    For i := 1 To N Do
      If Lop2[i] > k Then k := Lop2[i];
    If j < k Then
      Begin
        SoLopMin := j;
        LopMin := Lop1;
      End
     Else
      Begin
        SoLopMin := k;
        LopMin := Lop2;
      End
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.