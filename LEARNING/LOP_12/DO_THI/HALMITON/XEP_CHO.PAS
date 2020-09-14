{*--------------------------------------------------------------------------*}
{*Bai toan:                                                                  }
{   Co 17 nguoi gap nhau o 1 lop hoc. Ho cung nhau an toi trong suot thoi    }
{ gian hoc tai 1 nha hang co cac mon an rat hop khau vi cua ho. Biet trong   }
{ tat ca cac toi ho deu ngoi quanh 1 ban tron va moi cap chi ngoi canh nhau  }
{ dung mot lan.                                                              }
{   Tim xem dot hoc tap do keo dai nhat trong bao nhieu ngay va dua ra cach  }
{ xep cho ngoi cua ho trong nhung ngay do                                    }
{*--------------------------------------------------------------------------*}
{*Cach giai:                                                                 }
{   Coi moi nguoi la 1 dinh cua do thi, bai toan tro thanh bai toan tim chu  }
{ trinh Hamilton voi dieu kien: Xoa bo cac canh cua moi chu trinh tim duoc   }
{*--------------------------------------------------------------------------*}

Program Xep_Cho_Ngoi;

Uses CRT;

Const
  Max = 200;
  VoCung = 255;

Var
  Stack, Stack2, Xet : Array[1..Max] Of Byte;
  Canh : Array[1..Max, 1..Max] Of Byte;
  Dem_CT : LongInt;
  Top2, Top, N, i, j : Byte;
  TenTepDL : String;
  Time : LongInt;

Procedure Xuat_DL;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, 'hamilton.xep');
    ReWrite(F);
    WriteLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N-1 Do Write(F, Canh[i, j], ' ');
        WriteLn(F, Canh[i, N]);
      End;
    Close(F);
  End;

Procedure Xuat_Ket_Qua(i : Byte);
  Var
    j : Byte;
  Begin
    Write('Ngay thu ', Dem_CT, ': ');
    For j := 1 To N Do Write(Stack[j]:3);
    WriteLn(i:3);
  End;

Function TinhBac(i : Byte) : Word;
  Var
    j : Byte;
    B : Word;
  Begin
    B := 0;
    For j := 1 To N Do
      If (Canh[i, j] = 1)And(Xet[j] = 0) Then Inc(B);
    TinhBac := B;
  End;

Function Warnsdoff(i : Byte) : Boolean;
  Var
    DemCanh, Min : Word;
    j, k, b : Byte;
    Found, Finish : Boolean;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Stack2, SizeOf(Stack2), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    Top := 1;
    Top2 := 0;
    Stack[1] := i;
    Xet[i] := 1;
    Found := False;
    Finish := False;
    Repeat
      i := Stack[Top];
      Repeat
        Min := Max*Max;
        For j := 1 To N Do
          If (Canh[i, j] = 1)And(Xet[j] = 0)Then
            Begin
              b := TinhBac(j);
              If b < Min Then
                Begin
                  Min := b;
                  k := j;
                  DemCanh := 1;
                End
               Else If b = Min Then Inc(DemCanh);
            End;
        If Min <> Max*Max Then
          Begin
            {Xoa canh va dinh}
            Xet[k] := 1;
            Canh[i, k] := VoCung;
            Canh[k, i] := VoCung;
            i := k;
            If DemCanh > 1 Then
              Begin
                Stack2[Top2+1] := Top;
                Inc(Top2);
              End;
            Stack[Top+1] := k;
            Inc(Top);
          End;
      Until Min = Max*Max;
      {Kiem tra xem da tao thanh chu trinh chua}
      If (Canh[i, Stack[1]] <> 0)And(Top = N) Then
        Begin
          Inc(Dem_CT);
{          Xuat_Ket_Qua(Stack[1]);}
          For j := 1 To N-1 Do
            Begin
              Canh[Stack[j], Stack[j+1]] := 0;
              Canh[Stack[j+1], Stack[j]] := 0;
              For k := j+1 To N Do
                If Canh[j, k] = VoCung Then
                  Begin
                    Canh[j, k] := 1;
                    Canh[k, j] := 1;
                  End;
            End;
          Canh[Stack[1], Stack[Top]] := 0;
          Canh[Stack[Top], Stack[1]] := 0;
{          Xuat_DL;}
          For j := 2 To N Do Begin Xet[j] := 0;  Stack[j] := 0; End;
          Top := 1;
          Top2 := 0;
          FillChar(Stack2, SizeOf(Stack2), 0);
          Min := 0;
        End
       Else
      If Top2 > 0 Then
        Begin
          For k := Top DownTo Stack2[Top2]+1 Do
            Begin
              For j := 1 To N Do
                If (Canh[Stack[k], j] = VoCung)And(Xet[j] = 0) Then
                  Begin
                    Canh[Stack[k], j] := 1;
                    Canh[j, Stack[k]] := 1;
                  End;
              Xet[Stack[k]] := 0;
              Stack[k] := 0;
              Dec(Top);
            End;
          Dec(Top2);
        End
       Else Finish := True;
    Until Finish {Or Found};
  End;

{*----------------------------* Main Program *------------------------------*}
BEGIN
  ClrScr;
  Write('Nhap so nguoi can sap xep: ');
  ReadLn(N);
  For i := 1 To N Do
    For j := 1 To N Do
      Canh[i, j] := 1;
  For i := 1 To N Do Canh[i, i] := 0;
  Time := MemL[$0000:$046C];
  Warnsdoff(1);
  WriteLn('Dot hoc tap keo dai trong ', Dem_CT, ' ngay');
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  ReadLn;
END.                              ---oOo---