{ Cho bang cac so nguyen, thuc hien cac thao tac bien doi dau tren 1 dong
  hoac 1 cot de tong cac so tren moi hang va moi cot deu khong am }

Uses CRT;

Const
  Max = 100;
  TenTepDL = 'BD.INP';
  TenTepKQ = 'BD.OUT';

Var
  A : Array[1..Max, 1..Max] Of Integer;
  Dong, Cot : Array[1..Max] Of LongInt;
  M, N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To M Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu(M, N : Byte);
  Var
    F : Text;
    i, j, k : Integer;
  Begin
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, M, ' ', N);
    Randomize;
    k := 10;
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Write(F, Random(k)-k Div 2:5);
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Doi_Dau_Dong(i : Byte);
  Var
    j : Byte;
  Begin
    Dong[i] := -Dong[i];
    For j := 1 To N Do
      Begin
        Cot[j] := Cot[j]-LongInt(A[i, j])*2;
        A[i, j] := -A[i, j];
      End;
  End;

Procedure Doi_Dau_Cot(j : Byte);
  Var
    i : Byte;
  Begin
    Cot[j] := -Cot[j];
    For i := 1 To M Do
      Begin
        Dong[i] := Dong[i]-LongInt(A[i, j])*2;
        A[i, j] := -A[i, j];
      End;
  End;

Procedure Thuc_Hien;
  Var
    MinDong, MinCot : LongInt;
    i, j, d, c : Byte;
    FO : Text;
  Begin
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    FillChar(Dong, SizeOf(Dong), 0);
    FillChar(Cot, SizeOf(Cot), 0);
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          Inc(Dong[i], A[i, j]);
          Inc(Cot[j], A[i, j]);
        End;
    Repeat
      MinDong := 0;
      MinCot := 0;
      For i := 1 To M Do
        If Dong[i] < MinDong Then
          Begin
            MinDong := Dong[i];
            d := i;
          End;
      For j := 1 To N Do
        If Cot[j] < MinCot Then
          Begin
            MinCot := Cot[j];
            c := j;
          End;
      If (MinDong < 0)Or(MinCot < 0) Then
        If MinDong < MinCot Then
          Begin
            WriteLn(FO, 'D', d);
            Doi_Dau_Dong(d);
          End
         Else
          Begin
            WriteLn(FO, 'C', c);
            Doi_Dau_Cot(c);
          End
    Until (MinDong >= 0)And(MinCot >= 0);
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Write(FO, A[i, j]:5);
        WriteLn(FO);
      End;
    Close(FO);
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu(100, 100);{}
  Doc_Du_Lieu;
  Thuc_Hien;
END.