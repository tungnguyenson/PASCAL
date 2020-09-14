{*--------------------------------------------------------------------------*}
{*                    CHUONG TRINH TIM DUONG DI NGAN NHAT                   *}
{*                            ALGORITHM : GAN NHAN                          *}
{*--------------------------------------------------------------------------*}

{
 Algorithm:
     Buoc 1: Ket nap dinh nguon vao tap cac dinh da gan nhan va gan nhan cho
             no bang 0.
/--> Buoc 2: Tim dinh gan nhat voi cac dinh da gan nhan:
|          + Ket nap no vao tap cac dinh da gan nhan.
|          + Gan nhan cho no bang nhan cua dinh gan no nhat cong voi nhan cua
|            dinh ay.
|    Buoc 3: Kiem tra xem dinh vua gan nhan co phai la dinh cuoi hay khong:
\--------< + Neu khong thi quay ve buoc 2.
           + Neu dung thi ket thuc.
}

Program Tim_Duong_Di_Ngan_Nhat_Trong_Do_Thi;

Uses CRT;

Const
  Max = 100;

Var
  Truoc, DaXet : Array[1..Max] Of Byte;
  Nhan : Array[1..Max] Of Word;
  Canh : Array[1..Max, 1..Max] Of Byte;
  Stack : Array[1..Max*Max] Of Byte;
  Top, N, DinhDau, DinhCuoi : Byte;
  TepVao : String;

Procedure Doc_Du_Lieu(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do 
        Begin
          Read(F, Canh[i, j]);
          If Canh[i, j] = 0 Then Canh[i, j] := 255;
        End;
    For i := 1 To N Do Canh[i, i] := 255;
    Close(F);
  End;

Function Ton_Tai_Duong_Di(i, j : Byte) : Boolean;
  Var
    Left, Right, k : Byte;
  Begin
    DaXet[i] := 1;
    Right := 1;
    Left := 1;
    While (Left <= Right)And(DaXet[j] = 0) Do
      Begin
        For k := 1 To N Do
          If (Canh[i, k] <> 255)And(DaXet[k] = 0) Then
            Begin
              Inc(Right);
              Stack[Right] := k;
              DaXet[k] := 1;
            End;
        Inc(Left);
        i := Stack[Left];
      End;
    Ton_Tai_Duong_Di := DaXet[j] = 1;
  End;

Procedure Xuat_KQ;
  Var
    i : Byte;
  Begin
    WriteLn('Duong di ngan nhat tu ', DinhDau, ' den ', DinhCuoi, ' la:');
    i := DinhDau;
    Write(i);
    While i <> DinhCuoi Do
      Begin
        i := Truoc[i];
        Write(' -> ', i);
      End;
    WriteLn;
    Write('Do dai duong di: ', Nhan[DinhDau]);
  End;

Procedure Tim_Duong_Di_Ngan_Nhat(Dau, Cuoi : Byte);
  Var
    i, j, k, l : Byte;
    Min : Word;
  Begin
    FillChar(DaXet, SizeOf(DaXet), 0);
    FillChar(Nhan, SizeOf(Nhan), 0);
    Top := 1;
    DaXet[1] := Dau;
    Nhan[1] := 0;
    Repeat
      Min := 65535;
      k := 0;
      For i := 1 To Top Do
        For j := 1 To N Do
          If ((Nhan[DaXet[i]]+Canh[DaXet[i], j]) < Min)And(j <> Dau)
             And(Canh[DaXet[i], j] <> 255)And(Nhan[j] = 0)Then
            Begin
              Min := Nhan[DaXet[i]]+Canh[DaXet[i], j];
              k := DaXet[i];
              l := j;
            End;
      Truoc[l] := k;
      Nhan[l] := Min;
      Inc(Top);
      DaXet[Top] := l;
    Until (DaXet[Top] = Cuoi)Or(Top = N);
    If DaXet[Top] = Cuoi Then Xuat_KQ;
  End;

{*----------------------------- Main Program -------------------------------*}
BEGIN
  ClrScr;
  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TepVao);
  Doc_Du_Lieu(TepVao);
  Write('Nhap dinh dau: ');   ReadLn(DinhDau);
  Write('Nhap dinh cuoi: ');  ReadLn(DinhCuoi);
  If Ton_Tai_Duong_Di(DinhDau, DinhCuoi) Then
    {Dao nguoc dinh dau va cuoi de tranh dung mang phu khi xuat ket qua}
    Tim_Duong_Di_Ngan_Nhat(DinhCuoi, DinhDau)
   Else
    WriteLn('Khong ton tai duong di tu dinh ', DinhDau, ' den dinh ', DinhCuoi, '.');
  ReadLn;
END.                              ---oOo---