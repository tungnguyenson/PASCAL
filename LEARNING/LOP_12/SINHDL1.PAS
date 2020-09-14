Uses CRT;

Const
  MaxN = 20;

Var
  ChiPhi : Array[1..MaxN, 1..MaxN, 1..2] Of Word;
  TenTepDL : String;
  F : Text;
  N, i, j : Byte;
  a, b : Word;

BEGIN
  ClrScr;
  Write('Nhap ten tep du lieu: ');
  ReadLn(TenTepDL);
  Write('N = ');
  ReadLn(N);
  If N = 0 Then Halt;
  Randomize;
  For i := 1 To N-1 Do
    For j := i+1 To N Do
      Begin
        a := Random(2);
        b := Random(2);
        If a > 0 Then a := Random(5)+1;
        If b > 0 Then b := Random(5)+1;
        C> 0 Do
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
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-Time)/18.2:10