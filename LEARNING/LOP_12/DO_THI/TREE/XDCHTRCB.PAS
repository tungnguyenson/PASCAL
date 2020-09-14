Program Xay_Dung_Tap_Hop_Cac_Chu_Trinh_Co_Ban_Cua_Do_Thi;

Uses CRT;

Const
  Max = 100;
  ChuaXet = 0;
  DaXet   = 1;
  Xoa = 255;

Var
  Canh  : Array[1..Max, 1..Max] Of Byte;
  Stack : Array[1..Max*Max] Of Byte;
  Xet   : Array[1..Max] Of Byte;
  N : Byte;
  Top, DemSoCT : Word;
  F : Text;
  TenTepDL, TenTepKQ : String;

Procedure Doc_Du_lieu;
  Var
    i, j : Byte;
  Begin
    TenTepDL := 'tree1.i2';
{    Write('Nhan ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, Canh[i, j]);
    For i := 1 To N Do Canh[i, i] := 0;
    Close(F);
  End;

Procedure Xuat_Chu_Trinh;
  Var
    i : Byte;
  Begin
    Inc(DemSoCT);
    Write('Chu trinh ', DemSoCT, ': ');
    For i := 1 To Top Do Write(Stack[i], '->');
    Write(Stack[1]);
    WriteLn;
  End;

Procedure Xay_Dung;
  Var
    i, j : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    DemSoCT := 0;
    Top := 1;
    Stack[Top] := 1;
    Xet[Stack[Top]] := DaXet;
    Repeat
      i := Stack[Top];
      Repeat
        j := 1;
        While (j <= N)And((Canh[i, j] <> 1)Or(Xet[j] = DaXet)) Do Inc(j);
        If j <= N Then
          Begin
            Xet[j] := DaXet;
            Canh[i, j] := Xoa;
            Canh[j, i] := Xoa;
            Inc(Top);
            Stack[Top] := j;
            If Canh[Stack[1], j] = 1 Then
              Xuat_Chu_Trinh;
            i := j;
          End;
      Until j > N;
      For j := 1 To N Do
        If (Xet[j] = ChuaXet)And(Canh[i, j] = Xoa) Then
          Begin
            Canh[i, j] := 1;
            Canh[j, i] := 1;
          End;
      Xet[i] := 0;
      Stack[Top] := 0;
      Dec(Top);
    Until Top <= 0;
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  Xay_Dung;
  WriteLn('Tong so chu trinh tim duoc: ', DemSoCT);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.