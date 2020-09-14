Uses CRT;

Const
  Chieu_Doc = 8;
  Chieu_Ngang = 8;

Const
  Next : Array[1..8] Of ShortInt = (-25, -23, -14, -10, 10, 14, 23, 25);

Var
  BanCo : Array[1..Chieu_Doc+4, 1..Chieu_Ngang+4] Of Byte;
  Canh : Array[1..(Chieu_Doc+4)*(Chieu_Ngang+4), 1..(Chieu_Doc+4)*(Chieu_Ngang+4)] Of Byte;
  Dem, k : Byte;
  Time : LongInt;

Procedure Khoi_Tao;
  Var
    i, j, k : Byte;
  Begin
    FillChar(BanCo, SizeOf(BanCo), 255);
    FillChar(Canh, SizeOf(Canh), 0);
    For i := 3 To Chieu_Doc+2 Do
      For j := 3 To Chieu_Ngang+2 Do
        BanCo[i, j] := 0;
    For i := 3 To Chieu_Doc+2 Do
      For j := 3 To Chieu_Ngang+2 Do
        For k := 1 To 8 Do
          If BanCo[((i-1)*12+j+Next[k]) Div 12+1,
                   ((i-1)*12+j+Next[k]) Mod 12] = 0 Then
            Canh[(i-1)*12+j, (i-1)*12+j+Next[k]] := 1;
    Dem := 0;
  End;

Procedure Xuat;
  Var
    i, j : ShortInt;
  Begin
    ClrScr;
    For i := 3 To Chieu_Doc+2 Do
      For j := 3 To Chieu_Ngang+2 Do
        Begin
          GoToXY((j-3)*3+1, i-1);
          Write(BanCo[i, j]:2);
        End;
    GotoXY(1, i);  Write(Dem);
    GotoXY(1, i+1);  WriteLn((MemL[$0000:$046C]-Time)/18.2:10:5);
    ReadLn;{}
    Time := MemL[$0000:$046C];
  End;

Procedure Tim(ViTri, Last : ShortInt);
  Var
    j, y, x : ShortInt;
  Begin
    y := ViTri Div 12+1;
    x := ViTri Mod 12;
    For j := 1 To 8 Do
       If (BanCo[(ViTri+Next[j])Div 12+1, (ViTri+Next[j])Mod 12] = 0)
       And (Canh[ViTri, ViTri+Next[j]] = 1) Then
        Begin
          BanCo[y, x] := Dem+1;
          Canh[ViTri, ViTri+Next[j]] := 0;
          Canh[ViTri+Next[j], ViTri] := 0;
          For k := 1 To 8 Do
            If (k <> j)And(Last <> ViTri+Next[k])Then
              Begin
                Canh[ViTri, ViTri+Next[k]] := 0;
                Canh[ViTri, ViTri+Next[k]] := 0;
              End;
          Inc(Dem);
{          Xuat;{}
          If Dem > Chieu_Doc*Chieu_Ngang-2 Then Xuat
                      Else Tim(ViTri+Next[j], ViTri);
          BanCo[y, x] := 0;
          Canh[ViTri, ViTri+Next[j]] := 1;
          Canh[ViTri+Next[j], ViTri] := 1;
          For k := 1 To 8 Do
            If (k <> j)And(Last <> ViTri+Next[k])Then
              Begin
                Canh[ViTri, ViTri+Next[k]] := 1;
                Canh[ViTri, ViTri+Next[k]] := 1;
              End;
          Dec(Dem);
        End;
  End;

Begin
  Time := MemL[$0000:$046C];
  ClrScr;
  Khoi_Tao;
  Tim(27, 0);
  ReadLn;
End.