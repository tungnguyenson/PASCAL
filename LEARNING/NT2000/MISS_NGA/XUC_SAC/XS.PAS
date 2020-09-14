Uses CRT;

Const
  TenTepDL = 'BL4.IN2';
  SoMat = 6;

Var
  Khac : Array[1..SoMat, 1..SoMat] Of Byte;
  Xet, Bac : Array[1..SoMat] Of Byte;
  DemNghiem, SoLanGieo : Word;
  Mat : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Word;
    Mat1, Mat2, Mat3 : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, SoLanGieo);
    FillChar(Khac, SizeOf(Khac), 0);
    For i := 1 To SoLanGieo Do
      Begin
        ReadLn(F, Mat1, Mat2, Mat3);
        Khac[Mat1, Mat2] := 1;
        Khac[Mat2, Mat1] := 1;
        Khac[Mat2, Mat3] := 1;
        Khac[Mat3, Mat2] := 1;
        Khac[Mat1, Mat3] := 1;
        Khac[Mat3, Mat1] := 1;
      End;
    Close(F);
    FillChar(Bac, SizeOf(Bac), 0);
    For i := 1 To SoMat-1 Do
      For j := i+1 To SoMat Do
        If Khac[i, j] = 0 Then
          Begin
            Inc(Bac[i]);
            Inc(Bac[j]);
          End;
  End;

Procedure Xuat;
  Var
    i, j : Byte;
  Begin
    For i := 1 To 3 Do
      Begin
        For j := 1 To SoMat Do
	  If Xet[j] = i Then Write(j:2);
        WriteLn;
      End;
    WriteLn;
    Inc(DemNghiem);
  End;

Procedure Tim(Mat : Byte);
  Var
    i, j, k, l, B : Byte;
  Begin
    B := SoMat;
    For j := 1 To SoMat Do
      If (Bac[j] < B)And(Xet[j] = 0) Then
        Begin
	  B := Bac[j];
          k := j;
        End;
    If (B < SoMat)And(B > 0) Then
        Begin
          For j := 1 To SoMat Do
            If (Xet[j] = 0)And(Khac[j, k] = 0)And(j <> k) Then
              Begin
                Xet[k] := Mat;
                Xet[j] := Mat;
                For i := 1 To SoMat Do
                  If (Khac[i, j] = 1)Or(Khac[i, k] = 1) Then Inc(Bac[i]);
                If Mat < 3 Then Tim(Mat+1)
                 Else Xuat;
                Xet[k] := 0;
                Xet[j] := 0;
                For i := 1 To SoMat Do
                  If (Khac[i, j] = 1)Or(Khac[i, k] = 1) Then Dec(Bac[i]);
              End;
        End;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  FillChar(Xet, SizeOf(Xet), 0);
  Mat := 0;
  DemNghiem := 0;
  WriteLn('Cac nghiem thoa man: ');
  Tim(1);
  If DemNghiem > 0 Then WriteLn('So nghiem tim duoc: ', DemNghiem)
                   Else WriteLn('Khong tim duoc!');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.