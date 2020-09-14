Program Hinh_Chu_Nhat_Roi_Nhau;

{$R-,S-}

Uses CRT;

Const
  TenTepDL = 'RN1';
  TenTepKQ = 'ROINHAU.OUT';
  Max = 100;
  WaitTime = 60;

Type
  HinhChuNhat = Record
    x1, y1, x2, y2 : Integer;
  End;

Var
  HCN : Array[0..Max] Of HinhChuNhat;
  HCN_Ke, RoiNhau : Array[0..Max, 1..Max] Of Byte;
  SoHCN_Ke : Array[0..Max] Of Byte;
  A, KQ, LuuVT, Xet, Deg : Array[1..Max] Of Byte;
  N, SoHCN_Max, Top : Byte;
  TimeStart : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      With HCN[i] Do
        ReadLn(F, x1, y1, x2, y2);
    Close(F);
  End;

Function Roi_Nhau(H1, H2 : HinhChuNhat) : Boolean;
  Begin
    Roi_Nhau := False;
    If (H1.X1 > H2.X2) Or (H1.X2 < H2.X1) Or
       (H1.Y1 > H2.Y2) Or (H1.Y2 < H2.Y1) Then Roi_Nhau := True;
  End;

Procedure SwapByte(Var So1, So2 : Byte);
  Var
    Temp : Byte;
  Begin
    Temp := So1;
    So1 := So2;
    So2 := Temp;
  End;

Procedure Sap_Xep_Bac_HCN;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do LuuVT[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Deg[i] > Deg[j] Then
          Begin
            RoiNhau[0] := RoiNhau[i];
            RoiNhau[i] := RoiNhau[j];
            RoiNhau[j] := RoiNhau[0];
            SwapByte(Deg[i], Deg[j]);
            SwapByte(LuuVT[i], LuuVT[j]);
          End;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Word;
  Begin
    FillChar(HCN_Ke, SizeOf(HCN_Ke), 0);
    FillChar(RoiNhau, SizeOf(RoiNhau), 1);
    FillChar(SoHCN_Ke, SizeOf(SoHCN_Ke), 0);
    FillChar(Deg, SizeOf(Deg), 0);
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Roi_Nhau(HCN[i], HCN[j]) = False Then
          Begin
            RoiNhau[j, i] := 0;
            RoiNhau[i, j] := 0;
            Inc(Deg[i]);
            Inc(Deg[j]);
          End;
    Sap_Xep_Bac_HCN;{}
    For i := 1 To N-1 Do
      Begin
        SoHCN_Ke[i] := 0;
        For j := i+1 To N Do
          If RoiNhau[i, j] = 1 Then
            Begin
              Inc(SoHCN_Ke[i]);
              HCN_Ke[i, SoHCN_Ke[i]] := j;
            End;
      End;{}
    For i := 1 To N Do
      Begin
        Write(i:3, '(', LuuVT[i], ')[', Deg[i], ']:');
        For j := 1 To SoHCN_Ke[i] Do Write(HCN_Ke[i, j]:3);
        WriteLn;
      End;{}
  End;

Procedure Duyet(i : Byte);
  Var
    j, k : Byte;
  Begin
    If ((MemL[0:1132]-TimeStart)/18.2 > WaitTime) Then Exit;{}
    For j := 1 To SoHCN_Ke[i] Do
      If Xet[HCN_Ke[i, j]] = 0 Then
        Begin
          k := 1;
          While (k <= Top)And(RoiNhau[A[k], HCN_Ke[i, j]] = 1) Do Inc(k);
          If k > Top Then
            Begin
              Inc(Top);
              A[Top] := HCN_Ke[i, j];
              If Top > SoHCN_Max Then
                Begin
                  SoHCN_Max := Top;
                  KQ := A;
                End;
              If Top < N Then Duyet(HCN_Ke[i, j]);
              Dec(Top);
            End;
        End;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
  Begin
    SoHCN_Max := 0;
    TimeStart := MemL[0:1132];
    FillChar(A, Sizeof(A), 0);
    For i := 1 To N Do
      Begin
        FillChar(Xet, Sizeof(Xet), 0);
        Xet[i] := 1;
        A[1] := i;
        Top := 1;
        Duyet(i);
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SoHCN_Max);
    For i := 1 To SoHCN_Max Do
      With HCN[KQ[i]] Do
        WriteLn(F, KQ[i], ' ', x1, ' ', y1, ' ', x2, ' ', y2);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-TimeStart)/18.2:10:5);
END.