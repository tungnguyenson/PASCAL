Uses CRT;

Const
  TenTepDL = 'PV.IN1';
  MaxN = 100;
  MaxAnswer = 16;

Type
  St10 = String[10];
  St16 = String[16];

Var
  Answer : Array[1..MaxN] Of St16;
  Name : Array[1..MaxN] Of St10;
  N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    Ch : Char;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    N := 0;
    Repeat
      Inc(N);
      ReadLn(F, Name[N], Answer[N]);
    Until EOF(F);
    Close(F);
  End;

Procedure PHAN_1;
  Var
    i : Byte;
  Begin
    ClrScr;
    WriteLn('=========================================');
    WriteLn('*                PHAN 1:                *');
    WriteLn('=========================================');
    WriteLn;
    WriteLn(' STT    Ten           Cau tra loi');
    WriteLn('--------------------------------------');
    For i := 1 To N Do
      WriteLn(i:3, Name[i]:15, Answer[i]:20);
    WriteLn;
    Write('Nhan phim Enter de tiep tuc ...');
    ReadLn;
  End;

Procedure PHAN_2;
  Var
    i, j : Byte;
    Nhom : Array[1..MaxN] Of Byte;
    SoNhom : Byte;
  Begin
    WriteLn('=========================================');
    WriteLn('*                PHAN 2:                *');
    WriteLn('=========================================');
    WriteLn;
    FillChar(Nhom, SizeOf(Nhom), 0);
    SoNhom := 0;
    For i := 1 To N Do
      If Nhom[i] = 0 Then
        Begin
          Inc(SoNhom);
          Nhom[i] := SoNhom;
          For j := i+1 To N Do
            If Answer[i] = Answer[j] Then
              Nhom[j] := SoNhom;
        End;
    WriteLn('So nhom tim duoc: ', SoNhom);
    For i := 1 To SoNhom Do
      Begin
        WriteLn('Nhom ', i, ':');
        For j := 1 To N Do
          If Nhom[j] = i Then WriteLn(Name[j]:17);
      End;
    WriteLn;
    Write('Nhan phim Enter de tiep tuc ...');
    ReadLn;
  End;

Procedure PHAN_3;
  Var
    i, j, k, l : Byte;
    ThoaMan : Array[1..MaxN] Of Byte;
    SoNguoiThoaMan : Byte;
  Begin
    WriteLn('=========================================');
    WriteLn('*                PHAN 3:                *');
    WriteLn('=========================================');
    WriteLn;
    SoNguoiThoaMan := 0;
    For i := 1 To N Do
      Begin
        ThoaMan[i] := 1;
        For j := 1 To 16 Do
          If Answer[i, j] = '0' Then
            Begin
              l := 0;
              For k := 1 To N Do
                If Answer[k, j] = '1' Then Inc(l);
              If l <> 0 Then ThoaMan[i] := 0;
            End
           Else
            Begin
              l := 0;
              For k := 1 To N Do
                If (Answer[k, j] = '1')And(k <> i) Then Inc(l);
              If l = 0 Then ThoaMan[i] := 0;
            End;
        If ThoaMan[i] = 1 Then Inc(SoNguoiThoaMan);
      End;
    If SoNguoiThoaMan = 0 Then WriteLn('Khong co nguoi nao thoa man!')
     Else
      Begin
        WriteLn('So nguoi thoa man: ', SoNguoiThoaMan);
        For i := 1 To N Do
          If ThoaMan[i] = 1 Then WriteLn(Name[i]:10);
      End;
    WriteLn;
    Write('Nhan phim Enter de ket thuc ...');
    ReadLn;
  End;

BEGIN
  Doc_Du_Lieu;
  PHAN_1;
  PHAN_2;
  PHAN_3;
END.