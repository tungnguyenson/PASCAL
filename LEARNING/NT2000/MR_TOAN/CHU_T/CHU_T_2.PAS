{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepKQ = 'SAN.OUT';
  MaxN = 100;
  Brick : Array[0..3, 0..3] Of Byte = ((0, 1, 1, 1),
                                       (0, 0, 1, 2),
                                       (0, 3, 2, 2),
                                       (3, 3, 3, 2));
Var
  Ground : Array[1..MaxN, 1..MaxN] Of Word;
  N : Byte;

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
  Begin
    FillChar(Ground, SizeOf(Ground), 0);
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, l : Word;
  Begin
    If N Mod 4 = 0 Then
      Begin
        For i := 1 To N Div 4 Do
          For j := 1 To N Div 4 Do
            For k := 0 To 3 Do
              For l := 0 To 3 Do
                Ground[(i-1)*4+1+k, (j-1)*4+1+l] := Brick[k, l]+((i-1)*(N div 4)+j-1)*4+1;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If N Mod 4 = 0 Then
      For i := 1 To N Do
        Begin
          For j := 1 To N Do
			   Write(F, Ground[i, j]:5);
          WriteLn(F);
        End
      Else Write(F, 0);
    Close(F);
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.