Program Bai_Lam_1;

Uses CRT;

Const
  TenTepDL = 'DULICH.INP';
  MaxN = 100;
  VC = $7FFF;
  MaxTime : Word = 20;

Var
  ChiPhi : Array[1..MaxN, 1..MaxN] Of Word;
  HanhTrinh, HTMax, XetTP : Array[1..MaxN] Of Byte;
  DemHT, Max, N : Byte;
  k, CP : Word;
  F : Text;
  TimeStart : LongInt;

Procedure Doc_Du_Lieu;
  Var
    i, j : Byte;
    a, b : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        ChiPhi[i, j] := VC;
    While Not EOF(F) Do
      Begin
        ReadLn(F, i, j, a, b);
        If a = 0 Then a := VC;
        If b = 0 Then b := VC;
        If a > b Then a := b;
        ChiPHi[i, j] := a;
        ChiPHi[j, i] := a;
      End;
    Close(F);
{    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(ChiPhi[i, j]:5);
        WriteLn;
      End;{}
  End;

Procedure Duyet(i : Byte);
  Var
    j : Byte;
  Begin
    If (Max > N)Or((MemL[0:1132]-TimeStart)/18.2 > MaxTime) Then Exit;
    For j := 1 To N Do
      If (XetTP[j] = 0)And(ChiPhi[i, j] <= K) Then
        Begin
          XetTP[j] := 1;
          Dec(K, ChiPhi[i, j]);
          Inc(DemHT);
          HanhTrinh[DemHT] := j;
          ChiPhi[j, i] := VC+ChiPhi[j, i];
          If (DemHT > Max)And(j = 1) Then
            Begin
              Max := DemHT;
              HTMax := HanhTrinh;
              CP := K;
            End;
          If (DemHT <= N)And(k > 0) Then Duyet(j);
          Dec(DemHT);
          XetTP[j] := 0;
          ChiPhi[j, i] := ChiPhi[j, i]-VC;
          Inc(K, ChiPhi[i, j]);
        End;
  End;

Procedure Xuat_Ket_Qua(SoTPDiQua : Byte);
  Var
    i, j : Byte;
  Begin
    If SoTPDiQua = 0 Then WriteLn('KHONG DI DUOC')
     Else
      Begin
        WriteLn('So thanh pho di qua: ', SoTPDiQua-1);
        Write('Lo trinh bay: ');
        For i := 1 To SoTPDiQua Do
          Write(HTMax[i], ' ');
        WriteLn;
        WriteLn('Chi phi mua ve: ', K-CP);
      End;
  End;

Procedure Thuc_Hien;
  Var
    l : Word;
  Begin
    Repeat
      Write('So tien ban co: ');
      ReadLn(K);
    Until K >= 0;
    If K = 0 Then Xuat_Ket_Qua(0)
     Else
      Begin
        FillChar(XetTP, SizeOf(XetTP), 0);
        FillChar(HanhTrinh, SizeOf(HanhTrinh), 0);
        FillChar(HTMax, SizeOf(HTMax), 0);
        HanhTrinh[1] := 1;
        DemHT := 1;
        Max := 0;
        TimeStart := MemL[0:1132];
        If K > 10 Then
          Begin
            l := K;
            K := 10;
            Duyet(1);
            K := l;
            FillChar(XetTP, SizeOf(XetTP), 0);
            TimeStart := MemL[0:1132];
            MaxTime := 10;
          End;
        Duyet(1);
        Xuat_Ket_Qua(Max);
      End;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  WriteLn;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.