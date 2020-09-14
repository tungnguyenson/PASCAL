{$R-}
Program N_Mino;

Uses CRT;

Const
  Max = 7;
  MaxMino = 200;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Type
  MinoType = Record
               y1, x1, y2, x2 : Byte;
               Mino : Array[-1..Max+2, 0..Max+2] Of Byte;
             End;

Var
  Mino1, Mino2 : Array[1..MaxMino] Of MinoType;
  Top1, Top2 : Byte;
  i, N, BuocLap, LastMax : Byte;
  Time : LongInt;

Procedure Initializes;
  Begin
    With Mino1[1] Do
      Begin
        x1 := 1;
        y1 := 1;
        x2 := 1;
        y2 := 1;
        Mino[1, 1] := 1;
      End;
    Top1 := 1;
  End;

Procedure Gon(Var MN : MinoType);
  Var
    i, j, k, l : Byte;
    MNNew : MinoType;
  Begin
    FillChar(MNNew, SizeOf(MNNew), 0);
    With MN Do
      Begin
        i := y2-y1+1;
        j := x2-x1+1;
      End;
    With MNNew Do
      Begin
        y1 := 1;
        x1 := 1;
        y2 := i;
        x2 := j;
      End;
    For k := MN.y1 To MN.y2 Do
      For l := MN.x1 To MN.x2 Do
        MNNew.Mino[k-MN.y1+1, l-MN.x1+1] := MN.Mino[k, l];
    MN := MNNew;
  End;

Function Giong_Nhau(M1, M2 : MinoType) : Boolean;
  Var
    i, j, k : Byte;
  Begin
    Giong_Nhau := True;
    For i := 1 To M1.y2-M1.y1+1 Do
      For j := 1 To M1.x2-M1.x1+1 Do
        If M1.Mino[M1.y1+i-1, M1.x1+j-1] <> M2.Mino[M2.y1+i-1, M2.x1+j-1] Then
          Begin
            Giong_Nhau := False;
            Exit;
          End;
  End;

Procedure Bien_Doi(Var MN : MinoType; Kieu : Byte);
  Var
    y, x : Byte;
    MNNew : MinoType;
  Begin
    FillChar(MNNew, SizeOf(MNNew), 0);
    Case Kieu Of
      1 : Begin
            For y := MN.y1 To MN.y2 Do
              For x := MN.x1 To MN.x2 Do
                If MN.Mino[y, x] = 1 Then
                  MNNew.Mino[x, MN.y2-y+1] := 1;
            MNNew.y1 := MN.x1;
            MNNew.x1 := 1;
            MNNew.y2 := MN.x2;
            MNNew.x2 := MN.y2-MN.y1+1;
          End;
      2 : Begin
            For y := MN.y1 To MN.y2 Do
              For x := MN.x1 To MN.x2 Do
                If MN.Mino[y, x] = 1 Then
                  MNNew.Mino[MN.y2-y+1, x] := 1;
            MNNew.y1 := 1;
            MNNew.x1 := MN.x1;
            MNNew.y2 := MN.y2-MN.y1+1;
            MNNew.x2 := MN.x2;
          End;
      3 : Begin
            For y := MN.y1 To MN.y2 Do
              For x := MN.x1 To MN.x2 Do
                If MN.Mino[y, x] = 1 Then
                  MNNew.Mino[y, MN.x2-x+1] := 1;
            MNNew.y1 := MN.y1;
            MNNew.x1 := 1;
            MNNew.y2 := MN.y2;
            MNNew.x2 := MN.x2-MN.x1+1;
          End;
    End;
    MN := MNNew;
  End;

Function Da_Ton_Tai(MN : MinoType) : Boolean;
  Var
    i, j, k : Byte;
    M : MinoType;
  Begin
    Da_Ton_Tai := False;
    For i := 1 To Top2 Do
      For k := 2 To 3 Do
        Begin
          For j := 1 To 4 Do
            Begin
              If Giong_Nhau(MN, Mino2[i]) Then
                Begin
                  Da_Ton_Tai := True;
                  Exit;
                End;
              Bien_Doi(MN, 1);
            End;
          Bien_Doi(MN, k);
        End;
  End;

Procedure Xay_Dung_MiNo;
  Var
    j, k, l, m : Byte;
    MN, Xet : MinoType;
  Begin
    FillChar(Mino2, SizeOf(Mino2), 0);
    Top2 := 0;
    For j := 1 To Top1 Do
      Begin
        With Mino1[j] Do
          Begin
            Xet := Mino1[j];
            For k := y1 To y2 Do
              For l := x1 To x2 Do
                If Mino[k, l] = 1 Then
                  For m := 1 To 4 Do
                  If Xet.Mino[k+Next[m, 1], l+Next[m, 2]] = 0 Then
                  Begin
                    MN := Mino1[j];
                    If k+Next[m, 1] < MN.y1 Then Dec(MN.y1);
                    If k+Next[m, 1] > MN.y2 Then Inc(MN.y2);
                    If l+Next[m, 2] < MN.x1 Then Dec(MN.x1);
                    If l+Next[m, 2] > MN.x2 Then Inc(MN.x2);
                    MN.Mino[k+Next[m, 1], l+Next[m, 2]] := 1;
                    Xet.Mino[k+Next[m, 1], l+Next[m, 2]] := 1;
                    If (Not Da_Ton_Tai(MN))Or(Top2 < 1) Then
                      Begin
                        Inc(Top2);
                        Gon(MN);
                        Mino2[Top2] := MN;
                      End;
                  End;
          End;{With}
      End;{For}
  End;

Procedure Xuat_Mino(MN : MinoType);
  Var
    i, j : Byte;
    x, y : Byte;
  Begin
    x := WhereX;
    y := WhereY;
    If LastMax < MN.y2-MN.y1+1 Then LastMax := MN.y2-MN.y1+1;
    With MN Do
      Begin
        For i := y1 To y2 Do
          Begin
            For j := x1 To x2 Do
              Begin
                If Mino[i, j] = 1 Then Write('зд')
                                  Else Write('  ');
              End;
            GoToXY(x, WhereY+1);
          End;
      End;
    If x+BuocLap*2 < 80 Then GoToXY(x+BuocLap*2, y)
      Else
        Begin
          If y+BuocLap >= 25 Then
            Begin
              For i := 1 To BuocLap+1 Do WriteLn;
              y := WhereY-BuocLap-1;
              GoToXY(1, y+2);
            End
           Else GoToXY(1, y+LastMax+1);
          LastMax := 0;
        End;
  End;

Procedure Xuat_Ket_Qua;
  Begin
    i := Wherey;
    GoToXY(WhereX, WhereY+LastMax-1);
    WriteLn;
    WriteLn;
    WriteLn('So Mino tim duoc: ', Top2);
    WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
    Write('Nhan phim Enter de ket thuc ...');
  End;

Procedure Xu_Ly;
  Begin
    BuocLap := 0;
    Repeat
      Inc(BuocLap);
      Xay_Dung_Mino;
      Mino1 := Mino2;
      Top1 := Top2;
    Until Buoclap = N-1;
    LastMax := N;
    For i := 1 To Top2 Do Xuat_Mino(Mino2[i]);
  End;

Begin
  TextAttr := 7;
  ClrScr;
  Repeat
    Write('N = ');
    ReadLn(N);
  Until (N <= Max)And(N > 0);
  Time := MemL[$0000:$046C];
  Initializes;
  If N = 1 Then Xuat_Mino(Mino1[1])
           Else Xu_Ly;
  Xuat_Ket_Qua;
  ReadLn;
End.