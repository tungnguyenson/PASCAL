{*--------------------------------------------------------------------------*}
{*               CHUONG TRINH TIM DUONG DI VA CHU TRINH EULER               *}
{*                          ALGORITHM : FLEURY                              *}
{*--------------------------------------------------------------------------*}

Program EULER;

Uses CRT;

Const
  Max = 100;

Var
  Xet, Bac : Array[1..Max] Of Byte;
  Canh : Array[1..Max, 1..Max] Of Byte;
  Stack : Array[1..Max*Max] Of Byte;
  Dem : Word;
  N, i : Byte;
  TenTepDL : String;

Procedure Doc_Du_Lieu(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Read(F, Canh[i, j]);
        ReadLn(F);
      End;
    For i := 1 To N Do Canh[i, i] := 0;
    Close(F);
  End;

Procedure Tinh_Bac;
  Var
    i, j : Byte;
  Begin
    FillChar(Bac, SizeOf(Bac), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        If (Canh[i, j] <> 0)And(i <> j) Then Inc(Bac[i]);
  End;

{*---------------------------------------------------------------------*}
{ Thu tuc kiem tra tinh lien thong cua do thi bang phuong phap tim kiem }
{ chieu sau khong de qui.                                               }
{*---------------------------------------------------------------------*}
Function Kiem_Tra_Lien_Thong : Boolean;
  Var
    Top, DemSoDinh : Word;
    i, j : Byte;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(Stack, SizeOf(Stack), 0);
    i := 1;
    DemSoDinh := 1;
    Stack[1] := 1;
    Xet[1] := 1;
    Top := 1;
    Repeat
      i := Stack[Top];
      Repeat
        j := 1;
        While (j <= N)And((Canh[i, j] = 0)Or(Xet[j] <> 0)) Do Inc(j);
        If j <= N Then
          Begin
            Inc(Top);
            Stack[Top] := j;
            Xet[j] := 1;
            Inc(DemSoDinh);
            i := j;
          End;
        Until j > N;
      Dec(Top);
    Until Top <= 0;
    Kiem_Tra_Lien_Thong := DemSoDinh = N;
  End;

{*--------------------------------------------------------------------*}
{ 1 do thi ton tai chu trinh Euler khi va chi khi:                     }
{   - Do thi la lien thong                                             }
{   - Do thi khong co dinh nao bac le                                  }
{ 1 do thi ton tai nua chu trinh Euler(duong di Euler) khi va chi khi: }
{   - Do thi la lien thong                                             }
{   - Do thi co duy nhat 2 dinh bac le                                 }
{*--------------------------------------------------------------------*}
Function Kiem_Tra_CT_Euler : Byte;
  Var
    i, SoDinhBacLe : Byte;
  Begin
    SoDinhBacLe := 0;
    For i := 1 To N Do
      If Bac[i] Mod 2 = 1 Then Inc(SoDinhBacLe);
    If Kiem_Tra_Lien_Thong = True Then
      Begin
        If SoDinhBacLe = 0 Then Kiem_Tra_CT_Euler := 1    {Co chu trinh Euler}
         Else
          If SoDinhBacLe = 2 Then Kiem_Tra_CT_Euler := 2  {Co duong di Euler}
         Else Kiem_Tra_CT_Euler := 0;
      End
     Else Kiem_Tra_CT_Euler := 0;
  End;

{*-------------------------------------------------------------------------*}
{ Thu tuc tim chu trinh Euler xuat phat tu 1 dinh cho truoc dua tren thuat  }
{ toan Fleury: Ta chon lan luot cac canh, moi canh mot lan sao cho chi qua  }
{ cau khi khong con cach lua chon nao khac.                                 }
{ Phuong phap: ta cung chon lan luot cac canh, moi canh dung mot lan va khi }
{ gap dinh khong con canh nao noi voi no nua thi chung to do la cau va ta   }
{ nap dinh do vao chu trinh.                                                }
{*-------------------------------------------------------------------------*}
Procedure Fleury(i : Byte);
  Var
    Top : Word;
    j : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    Top := 1;
    Stack[1] := i;
    Repeat
      i := Stack[Top];
      While Bac[i] <> 0 Do
        Begin
          j := 1;
          While ((j <= N)And(Canh[i, j] = 0))Or(i = j) Do Inc(j);
          Canh[i, j] := 0;
          Canh[j, i] := 0;
          Dec(Bac[i]);
          Dec(Bac[j]);
          Inc(Top);
          Stack[Top] := j;
          i := j;
        End;
      Inc(Dem);
      Stack[Dem] := i;
      Dec(Top);
    Until Top <= 0;
  End;

{*---------------------------* MAIN PROGRAM *-------------------------------*}
Begin
  ClrScr;
  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TenTepDL);
  Doc_Du_Lieu(TenTepDL);
  Tinh_Bac;
  Case Kiem_Tra_CT_Euler Of
    1 : Begin
          WriteLn('Do thi ton tai chu trinh Euler:');
          Fleury(1);
          For i := 1 To Dem-1 Do Write(Stack[i], ' -> ');
          WriteLn(Stack[Dem]);
        End;
    2 : Begin
          WriteLn('Do thi ton tai duong di Euler:');
          {Tim 2 dinh bac le}
          i := 1;
          While Bac[i] Mod 2 = 0 Do Inc(i);
          Fleury(i);
          For i := 1 To Dem-1 Do Write(Stack[i], ' -> ');
          WriteLn(Stack[Dem]);
        End;
    Else
      WriteLn('Do thi khong ton tai chu trinh va duong di EULER!');
  End;
  ReadLn;
End.