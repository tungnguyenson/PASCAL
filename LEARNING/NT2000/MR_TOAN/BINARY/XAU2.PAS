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
  k, S : LongInt;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If Not (N In [1..MaxN]) Then
        Write('Nhap sai! Nhap lai: ');
    Until N In [1..MaxN];
  End;

Procedure Tim;
  Var
    i, j : LongInt;
  Begin
    For i := 1 To N+1 Do Xau[i] := 1;
    Xet[0] := 1;
    Repeat
      S := 0;
      For k := i DownTo i-N+1 Do
		  If Xau[k] = 2 Then S := S+1 Shl (i-k);
      If Xet[S] = 0 Then
        Begin
          Xet[S] := 1;
          Inc(i);
          If i < 1 Shl N Then Xau[i] := 1
           Else
			   Begin
              Xau[i] := 2;
				  Luu := Xau;
            End;
        End
       Else
		  Begin
          While Xau[i] = 2 Do Dec(i);
          Inc(Xau[i]);
        End;
    Until i > 1 Shl N-1;
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
  Tim;
  Ghi_Ket_Qua;
END.