Uses CRT;

Const
  MaxN = 100;
  MaxChuSo = 5000;

Type
  SoLon = Array[0..MaxChuSo] Of Word;

Var
  i, j, N : Word;
  F1, F2, F, KQ : SoLon;

Procedure Cong(Var S1 : SoLon; S2 : SoLon);
  Var
    Leng, i : Word;
    Nho, Tong : Byte;
  Begin
    If S1[0] < S2[0] Then Leng := S2[0]
                     Else Leng := S1[0];
    Nho := 0;
    For i := MaxChuSo DownTo MaxChuSo-Leng+1 Do
      Begin
        Tong := S1[i]+S2[i]+Nho;
        Nho := Tong Div 10;
        S1[i] := Tong Mod 10;
      End;
    If Nho > 0 Then
      Begin
        Inc(S1[0]);
        S1[MaxChuSo-S1[0]+1] := Nho;
      End;
  End;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N nam trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If (N > MaxN)Or(N <= 0) Then Write('Nhap sai! Nhap lai: ');
    Until (N <= MaxN)And(N > 0);
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  KQ[0] := 1;
  If N = 1 Then KQ[MaxChuSo] := 2 Else
  If N = 2 Then KQ[MaxChuSo] := 3 Else
    Begin
      F1[0] := 1;
      F1[MaxChuSo] := 2;
      F2[0] := 1;
      F2[MaxChuSo] := 3;
      For i := 3 To N Do
        Begin
          F := F2;
          Cong(F2, F1);
          F1 := F;
        End;
      KQ := F2;
    End;
  Write('So xau nhi phan thoa man: ');
  i := 1;
  While KQ[i] = 0 Do Inc(i);
  For j := i To MaxChuSo Do Write(KQ[j]);
  WriteLn;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.