{*--------------------------------------------------------------------------*}
{*                    CHUONG TRINH TIM DUONG DI NGAN NHAT                   *}
{*                            ALGORITHM : DIJKSTRA                           *}
{*--------------------------------------------------------------------------*}

{
 Algorithm:
          - Buoc 1: Gan nhan cho tat ca cac dinh cua do thi bang vo cung va
                    dinh dau bang 0.
 /------> - Buoc 2: Tim dinh i co nhan nho nhat trong so cac dinh cua do thi
 |                  chua duoc xet va i tro thanh dinh da xet.
 |        - Buoc 3: Sua doi nhan cua tap hop cac dinh j noi voi i thoa man:
 |                    Nhan[j] > Nhan[i]+Khoang cach [i, j]
 |                  bang:
 |                    Nhan[i]+Khoang cach [i, j]
 |        - Buoc 4: Ghi nho dinh truoc dinh j (trong truong hop nay la i).
 |        - Buoc 5: Kiem tra: Neu dinh cuoi duoc xet hay chua:
 \------------------< + Neu chua duoc xet thi quay ve buoc 2.
                      + Neu da duoc xet thi ket thuc va in ra duong di.
}

Program Tim_Duong_Di_Ngan_Nhat_Trong_Do_Thi;

Uses CRT;

Const
  Max = 100;
  VoCung = 65535;

Var
  Truoc, Xet : Array[1..Max] Of Byte;
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
    Xet[i] := 1;
    Right := 1;
    Left := 1;
    While (Left <= Right)And(Xet[j] = 0) Do
      Begin
        For k := 1 To N Do
          If (Canh[i, k] <> 255)And(Xet[k] = 0) Then
            Begin
              Inc(Right);
              Stack[Right] := k;
              Xet[k] := 1;
            End;
        Inc(Left);
        i := Stack[Left];
      End;
    Ton_Tai_Duong_Di := Xet[j] = 1;
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

Procedure Dijkstra(Dau, Cuoi : Byte);
  Var
    i, j, k, l : Byte;
    Min : Word;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    For i := 1 To N Do Nhan[i] := VoCung;
    Nhan[Dau] := 0;
    Repeat
      Min := VoCung;
      For j := 1 To N Do
        If (Xet[j] = 0)And(Nhan[j] < Min) Then
          Begin
            i := j;
            Min := Nhan[j];
          End;
      Xet[i] := 1;
      For j := 1 To N Do
        If (Nhan[i]+Canh[i, j] < Nhan[j])And(Canh[i, j] <> 255)And(Xet[j] = 0) Then
          Begin
            Nhan[j] := Nhan[i]+Canh[i, j];
            Truoc[j] := i;
          End;
    Until (Xet[Cuoi] = 1);
    Xuat_KQ;
  End;

{*----------------------------- Main Program -------------------------------*}
BEGIN
  ClrScr;
  TepVao := 'dd.i2';
  DinhDau := 6;
  DinhCuoi := 1;
{  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TepVao);}
  Doc_Du_Lieu(TepVao);
{  Write('Nhap dinh dau: ');   ReadLn(DinhDau);
  Write('Nhap dinh cuoi: ');  ReadLn(DinhCuoi);}
  If Ton_Tai_Duong_Di(DinhDau, DinhCuoi) Then
    {Dao nguoc dinh dau va cuoi de tranh dung mang phu khi xuat ket qua}
    Dijkstra(DinhCuoi, DinhDau)
   Else
    WriteLn('Khong ton tai duong di tu dinh ', DinhDau, ' den dinh ', DinhCuoi, '.');
  ReadLn;
END.                              ---oOo---