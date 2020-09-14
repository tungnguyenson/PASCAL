{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  N = 512;
  A = 3;
  MaxChuSo = 5000;

Type
  SoLon = Array[0..MaxChuSo] Of Word;

Var
  So, So0 : SoLon;
  SoBuocLap, Time : LongInt;

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
        Inc(SoBuocLap);
      End;
    If Nho > 0 Then
      Begin
        Inc(S1[0]);
        S1[MaxChuSo-S1[0]+1] := Nho;
      End;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Word;
  Begin
    FillChar(So, SizeOf(So), 0);
    So[0] := 1;
    So[MaxChuSo] := A;
    SoBuocLap := 0;
    For i := 1 To N-1 Do
      Begin
        So0 := So;
        For j := 1 To A-1 Do Cong(So, So0);
      End;
  End;

Procedure Xuat_Ket_Qua;
  Var
    i, j : Word;
  Begin
    i := 1;
    While So[i] = 0 Do Inc(i);
    For j := i To MaxChuSo Do Write(So[j]);
    WriteLn;
    WriteLn('So chu so: ', So[0]);
    WriteLn('So buoc lap: ', SoBuocLap);
  End;

BEGIN
  ClrScr;
  Thuc_Hien;
  Xuat_Ket_Qua;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.