Program Bai_Lam_2;

Uses CRT;

Const
  TenTepDL = 'TAXI.INP';
  MaxN = 50;
  VC = 100;

Var
  KC : Array[1..MaxN, 1..MaxN] Of Byte;
  Taxi : Array[0..MaxN, 1..4] Of Byte;
  YeuCau : Array[0..MaxN, 1..4] Of Byte;
  Last, Xet : Array[1..MaxN] Of Byte;
  N, K, SoYC : Byte;

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
        Read(F, KC[i, j]);
    For i := 1 To N Do KC[i, i] := 0;
    ReadLn(F, K);
    For i := 1 To K Do
      For j := 1 To 4 Do
        Read(F, Taxi[i, j]);
    Close(F);
  End;

Procedure Sap_Xep;
  Var
    i, j : Byte;
  Begin
    For i := 1 To SoYC-1 Do
      For j := i+1 To SoYC Do
        If (YeuCau[i, 2] < YeuCau[j, 2])Or((YeuCau[i, 2] = YeuCau[j, 2])
           And(YeuCau[i, 1] > YeuCau[j, 1])) Then
          Begin
            YeuCau[0] := YeuCau[i];
            YeuCau[i] := YeuCau[j];
            YeuCau[j] := YeuCau[0];
          End;
    For i := 1 To K-1 Do
      For j := i+1 To K Do
        If Taxi[i, 1] > Taxi[j, 1] Then
          Begin
            Taxi[0] := Taxi[i];
            Taxi[i] := Taxi[j];
            Taxi[j] := Taxi[0];
          End;
  End;

Procedure Nhap_Yeu_Cau;
  Var
    i : Byte;
    F : Text;
  Begin
    FillChar(YeuCau, SizeOf(YeuCau), 0);
    Write('Nhap so luong yeu cau: ');
    ReadLn(SoYC);
    For i := 1 To SoYC Do
      Begin
        WriteLn('Yeu cau thu ', i, ':');
        Write('   So hieu cum   : ');  ReadLn(YeuCau[i, 1]);
        Write('   So luong nguoi: ');  ReadLn(YeuCau[i, 2]);
      End;{}
    For i := 1 To SoYC Do YeuCau[i, 3] := i;
  End;

Procedure Phuc_Vu;
  Var
    i, j, CumYC, SLKhach, MinKC, SoXe : Byte;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    For i := 1 To SoYC Do
      Begin
        CumYC := YeuCau[i, 1];
        SLKhach := YeuCau[i, 2];
        MinKC := VC;
        For j := 1 To K Do
          If (Taxi[j, 3] = 0)And(KC[Taxi[j, 2], CumYC] < MinKC)
             And(Taxi[j, 4] >= SLKhach)And(Xet[j] = 0) Then
            Begin
              MinKC := KC[Taxi[j, 2], CumYC];
              SoXe := j;
            End;
        If MinKC < VC Then
          Begin
            Xet[SoXe] := 1;
            YeuCau[i, 4] := SoXe;
          End;
      End;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    Nhap_Yeu_Cau;
    Sap_Xep;
    ClrScr;
    WriteLn(SoYC);
    For i := 1 To SoYC Do
      WriteLn(YeuCau[i, 1], ' ', YeuCau[i, 2]);
    Phuc_Vu;
    WriteLn('PHUONG AN:');
    For i := 1 To SoYC Do
      Begin
        j := 1;
        While YeuCau[j, 3] <> i Do Inc(j);
        If YeuCau[j, 4] <> 0 Then
          WriteLn(Taxi[YeuCau[j, 4], 1], ' ', Taxi[YeuCau[j, 4], 2], ' ',
                  YeuCau[j, 1], ' ', KC[Taxi[YeuCau[j, 4], 2], YeuCau[j, 1]])
         Else WriteLn('0 0 ', YeuCau[j, 1]);
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