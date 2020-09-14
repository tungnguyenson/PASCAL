{*--------------------------------------------------------------------------*}
{*             CHUONG TRINH TIM CHU TRINH VA DUONG DI HAMILTON              *}
{*                       TRONG DON DO THI VO HUONG                          *}
{*                          ALGORITHM: WARNSDOFF                            *}
{*--------------------------------------------------------------------------*}

{
 Algorithm: Thuc hien bang tim kiem chieu sau.
          - Gia su dinh xuat phat ban dau la i.
 /---/--> - Buoc 1: + Trong so cac dinh chua xet noi voi i, chon dinh j co bac
 |   |                nho nhat.
 |   |              + Nap j vao Stack.
 |   |              + Neu co nhieu dinh co cung bac voi j thi nap j vao Stack2
 |   |                de con quay lui.
 |   |    - Buoc 2: Kiem tra xem da duyet het cac dinh chua:
 |   \--------------< + Neu chua thi gan i bang Stack[Top] roi quay lai Buoc 1.
 |                    + Neu da duyet het roi thi xuat ket qua roi sang Buoc 3.
 |        - Buoc 3: Kiem tra xem co dinh nao trong Stack2 khong:
 \------------------< + Neu co thi xoa cac canh tu sau dinh do roi quay ve
                        Buoc 1.
                      + Neu khong thi ket thuc.
}

{$R-,S-}
Program HAMILTON;

Uses WinCRT;

Const
  Max = 100;
  VoCung = 255;

Var
  Stack, Stack2, Xet : Array[1..Max] Of Byte;
  Canh : Array[1..Max, 1..Max] Of Byte;
  Dem_CT : LongInt;
  Top, Top2, N, i : Byte;
  TenTepDL : String;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
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

Procedure Xuat_Ket_Qua(i : Byte);
  Var
    j : Byte;
  Begin
    Write('Chu trinh thu ', Dem_CT, ': ');
    For j := 1 To N Do Write(Stack[j], ' -> ');
    WriteLn(i);
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

Procedure BFS(i, Mark : Byte);
  Var
    Left, Right, j : Byte;
  Begin
    Xet[i] := Mark;
    Left := 1;
    Right := 1;
    Stack[Left] := i;
    While Left <= Right Do
      Begin
        For j := 1 To N Do
          If (Canh[i, j] = 1)And(Xet[j] = 0) Then
            Begin
              Inc(Right);
              Stack[Right] := j;
              Xet[j] := Mark;
            End;
        Inc(Left);
        i := Stack[Left];
      End;
  End;

Function Kiem_Tra_Hamilton : Boolean;
  Var
    Mark, i, j : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    Mark := 0;
    For i := 1 To N Do
      If Xet[i] = 0 Then
        Begin
          Inc(Mark);
          BFS(i, Mark);
        End;
    FillChar(Xet, SizeOf(Xet), 0);
    i := 1;
    While (i <= N)And(TinhBac(i) >= 2) Do Inc(i);
    {Do thi la lien thong va khong co dinh nao co bac < 2}
    Kiem_Tra_Hamilton := (Mark = 1)And(i > N);
  End;

Function Warnsdoff(i : Byte) : Boolean;
  Var
    Min, DemCanh : Word;
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
        If Min < Max*Max Then
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
          Found := True;
          Inc(Dem_CT);
{          Xuat_Ket_Qua(Stack[1]);}
        End;
      {Khoi phuc dinh va cac canh da xoa}
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
    Until Finish{ Or Found};
    Warnsdoff := Found;
  End;

{*----------------------------* Main Program *------------------------------*}
BEGIN
  ClrScr;
  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TenTepDL);
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  If (Kiem_Tra_Hamilton = False)Or(Warnsdoff(1) = False) Then
    WriteLn('Do thi khong ton tai chu trinh HAMILTON!')
   Else
    Begin
      WriteLn('So chu trinh tim duoc: ', Dem_CT);
      WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
    End;
  ReadLn;
END.                              ---oOo---