Uses CRT;

Const
  Chieu_Doc = 8;
  Chieu_Ngang = 8;

Type
  Vi_Tri = Record
             y, x : ShortInt;
           End;
{Const
  NuocDi : Array[1..8] Of ShortInt = (-25, -23, -14, -10, 10, 14, 23, 25);}

Var
  BanCo : Array[-1..Chieu_Doc+2, -1..Chieu_Ngang+2] Of Byte;
  NuocDi : Array[1..Chieu_Doc, 1..Chieu_Ngang] Of Byte;
  TiepTheo : Array[1..8] Of Vi_Tri;
  Dem, k : Byte;

Procedure Khoi_Tao;
  Var
    i, j, k : Byte;
  Begin
    FillChar(BanCo, SizeOf(BanCo), 255);
    FillChar(NuocDi, SizeOf(NuocDi), 0);
    For i := 1 To Chieu_Doc Do
      For j := 1 To Chieu_Ngang Do
        BanCo[i, j] := 0;
    TiepTheo[1].y := -2;  TiepTheo[1].x := -1;
    TiepTheo[2].y := -2;  TiepTheo[2].x :=  1;
    TiepTheo[3].y := -1;  TiepTheo[3].x := -2;
    TiepTheo[4].y := -1;  TiepTheo[4].x :=  2;
    TiepTheo[5].y :=  1;  TiepTheo[5].x := -2;
    TiepTheo[6].y :=  1;  TiepTheo[6].x :=  2;
    TiepTheo[7].y :=  2;  TiepTheo[7].x := -1;
    TiepTheo[8].y :=  2;  TiepTheo[8].x :=  1;
    For i := 1 To Chieu_Doc Do
      For j := 1 To Chieu_Ngang Do
        For k := 1 To 8 Do
          If BanCo[i+TiepTheo[k].y, j+TiepTheo[k].x] = 0 Then
            NuocDi[i, j]
    Dem := 1;
  End;

Procedure Xuat;
  Var
    i, j : ShortInt;
  Begin
    ClrScr;
    For i := 1 To Chieu_Doc Do
      For j := 1 To Chieu_Ngang Do
        Begin
          GoToXY((j-1)*3+1, i+1);
          Write(BanCo[i, j]:2);
        End;
    GotoXY(1, i+2);
    Write(Dem);
{    ReadLn;{}
  End;

Procedure Tim(y, x, yL, xl : ShortInt);
  Var
    j : Byte;
  Begin
    For j := 1 To 8 Do
      If BanCo[y+TiepTheo[j].y, x+TiepTheo[j].x] = 0 Then
        Begin
          BanCo[y, x] := Dem;
          If xl <> 0 Then
            For k := 1 To 8 Do
              If BanCo[yl+TiepTheo[k].y, xl+TiepTheo[k].x] = 0 Then
                BanCo[yl+TiepTheo[k].y, xl+TiepTheo[k].x] := Dem-1;
          Inc(Dem);
{          Xuat;{}
          If Dem > Chieu_Doc*Chieu_Ngang-34 Then Xuat
                      Else Tim(y+TiepTheo[j].y, x+TiepTheo[j].x, y, x);
          BanCo[y, x] := 0;
          Dec(Dem);
          For k := 1 To 8 Do
            If BanCo[yl+TiepTheo[k].y, xl+TiepTheo[k].x] = Dem-1 Then
              BanCo[yl+TiepTheo[k].y, xl+TiepTheo[k].x] := 0;
        End;
  End;

Begin
  ClrScr;
  Khoi_Tao;
  Tim(1, 1, 0, 0);
  ReadLn;
End.