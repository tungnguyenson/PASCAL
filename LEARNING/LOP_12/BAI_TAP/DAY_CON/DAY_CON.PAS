{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 4096,0,0}
Uses CRT;

Const
  Max = 10000;
  VC_Int = $7FFF;

Var
  So, Nhan, Last : Array[1..Max] Of Integer;
  N : Integer;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
  Begin
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    N := 0;
    While Not EOF(F) Do
      Begin
        While Not(EOLn(F)) Do
          Begin
            Inc(N);
            Read(F, So[N]);
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

{$R-}
{  Func : Gan nhan }
Procedure Thuc_Hien;
  Var
    i, j : Integer;
  Begin
    FillChar(Last, SizeOf(Last), 0);
    FillChar(Nhan, SizeOf(Nhan), 0);
    For i := 1 To N-1 Do
      Begin
        Inc(Nhan[i]);
        For j := i+1 To N Do
          If So[i] <= So[j] Then
            Begin
              If (Nhan[i] > Nhan[j])Or((Nhan[i] = Nhan[j])And
                 (So[i] < So[Last[j]])) Then
                Begin
                  Nhan[j] := Nhan[i];
                  Last[j] := i;
                End;
            End;
      End;
    Inc(Nhan[N]);
  End;

Procedure Xuat_Ket_Qua;
  Var
    Max, i, j : Integer;
  Begin
    Max := Nhan[1];
    For j := 1 To N Do
      If Nhan[j] > Max Then
        Begin
          If ((Max = Nhan[j])And(So[i] > So[j]))Or(Max < Nhan[j]) Then i := j;{}
          Max := Nhan[j];
        End;
    Nhan[i] := VC_Int;
    While Last[i] <> 0 Do
      Begin
        i := Last[i];
        Nhan[i] := VC_Int;
      End;
    For i := 1 To N Do
      If Nhan[i] = VC_Int Then Write(So[i]:8);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Time := MemL[0:1132];
  Thuc_Hien;
  Xuat_Ket_Qua;
  WriteLn;
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-Time)/18.2:10:7, ' giay');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.