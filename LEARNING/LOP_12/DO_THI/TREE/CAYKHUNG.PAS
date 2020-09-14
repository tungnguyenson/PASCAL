{
  Thuat toan xay dung cay khung cua do thi:
  - Chon 1 dinh lam goc va ket nap vao Stack.
  - Tu cac dinh trong Stack, tim cac dinh khac chua xet ke voi no cho den
    khi cac dinh da duoc xt het.
}

Program Xay_Dung_Cay_Khung_Cua_Do_Thi;

Uses CRT;

Const
  Max = 100;
  ChuaXet = 0;
  DaXet   = 1;
  ThuocCay = 9;

Var
  Canh  : Array[1..Max, 1..Max] Of Byte;
  Stack : Array[1..Max*Max] Of Byte;
  Xet   : Array[1..Max] Of Byte;
  N : Byte;
  F : Text;
  TenTepDL, TenTepKQ : String;

Procedure Doc_Du_lieu;
  Var
    i, j : Byte;
  Begin
    TenTepDL := 'tree1.i1';
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

Procedure Xuat_Ket_Qua;
  Var
    i, j : Word;
  Begin
    TenTepKQ := 'con';
{    Write('Nhan ten tep ghi ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    ReWrite(F);
    WriteLn(F, N-1);
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Canh[i, j] = ThuocCay Then
          WriteLn(F, i, ' ', j);
    Close(F);
    WriteLn('Ket qua duoc ghi vao tep ''', TenTepKQ, '''');
  End;

Procedure Depth_First_Search(Root : Byte);
  Var
    Top : Word;
    i, j, Dem : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    Top := 1;
    Stack[Top] := Root;
    Xet[Root] := DaXet;
    Top := 2;
    Dem := 1;
    Repeat
      Dec(Top);
      i := Stack[Top];
      Repeat
        j := 1;
        While (j <= N)And((Canh[i, j] <> 1)Or(Xet[j] = DaXet)) Do Inc(j);
        If j <= N Then
          Begin
            Inc(Dem);
            Xet[j] := DaXet;
            Canh[i, j] := ThuocCay;
            Canh[j, i] := ThuocCay;
            Inc(Top);
            Stack[Top] := j;
            i := j;
          End;
      Until j > N;
    Until (Top <= 0)Or(Dem = N);
    If Top > 0 Then Xuat_Ket_Qua
               Else WriteLn('Do thi khong lien thong!');
  End;

Procedure Breadth_First_Search(Root : Byte);
  Var
    Left, Right : Word;
    i, j : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    Left := 1;
    Right := 1;
    Stack[Left] := Root;
    Xet[Root] := DaXet;
    i := Root;
    While Left <= Right Do
      Begin
        j := 1;
        While (j <= N)And((Canh[i, j] <> 1)Or(Xet[j] = DaXet)) Do Inc(j);
        If j <= N Then
          Begin
            Xet[j] := DaXet;
            Canh[i, j] := ThuocCay;
            Canh[j, i] := ThuocCay;
            Inc(Right);
            Stack[Right] := j;
          End
         Else
          Begin
            Inc(Left);
            i := Stack[Left];
          End;
      End;
    If Right >= N Then Xuat_Ket_Qua
                  Else WriteLn('Do thi khong lien thong!');
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  Breadth_First_Search(1);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.