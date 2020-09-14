{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 65520,0,655360}

Uses CRT;

Const
  MaxN = 14;
  TenTepKQ = 'TEMP.';

Var
  Luu, Xau : Array[1..1 Shl MaxN] Of Byte;
  Xet : Array[0..1 Shl MaxN] Of Byte;
  N : Byte;
  k, S : Word;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If Not (N In [1..MaxN]) Then
        Write('Nhap sai! Nhap lai: ');
    Until N In [1..MaxN];
  End;

Procedure Khoi_Tao;
  Var
    i : Byte;
  Begin
    FillChar(Xau, SizeOf(Xau), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    For i := 1 To N Do Xau[i] := 1;
    Xet[0] := 1;
  End;

Procedure Tim(i : Word);
  Var
    j : Byte;
  Begin
    For j := 1 To 2 Do
      Begin
        Xau[i] := j;
        S := 0;
 		  For k := i DownTo i-N+1 Do
		    If Xau[k] = 2 Then S := S+1 Shl (i-k);
        If Xet[S] = 0 Then
          Begin
            Xet[S] := 1;
            WriteLn(i);
            If i < 1 Shl N-1 Then Tim(i+1)
             Else
              Begin
                Xau[1 Shl N] := 2;
                Luu := Xau;
              End;
          End;
        Xau[i] := 0;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To 1 Shl N Do Write(F, Luu[i]-1);
    Close(F);
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  Khoi_Tao;
  Tim(N+1);
  Ghi_Ket_Qua;
END.