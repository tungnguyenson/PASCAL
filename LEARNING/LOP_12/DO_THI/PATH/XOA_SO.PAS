{*--------------------------------------------------------------------------*}
{ Problem:                                                                   }
{   Cho day N so nguyen X[1], X[2],..., X[N], trong do 1 < N < 1000 va       }
{ 1 < X[i] < 200 (i = 1, 2,..., N). Day so da cho duoc ghi trong 1 fil van   }
{ ban co ten la 'DATA4.INP'. Cac so duoc ghi cach nhau boi it nhat mot dau   }
{ cach hoac dau xuong dong. Nhap du lieu vao tu file, sau do tim cach xoa    }
{ bo it nhat 1 so cac phan tu cua day sao cho cac phan tu con lai (giu       }
{ nguyen thu tu cua chung trong day ban dau) tao thanh mot day con khong     }
{ giam. Dua ra man hinh tong so cac phan tu can xoa va chi so cua chung      }
{ trong day da cho.                                                          }
{*--------------------------------------------------------------------------*}

Program Xoa_So;

Uses CRT;

Const
  Max = 5000;

Var
  A, Nhan, Truoc : Array[0..Max+1] Of Word;
  N : Word;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    i : Word;
    TenTepDL : String;
    F : Text;
  Begin
{    TenTepDL := 'DATA4.TST';{}
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    FillChar(A, SizeOf(A), 0);
    Assign(F, TenTepDL);
    ReSet(F);
    i := 0;
    While Not EOF(F) Do
      Begin
        While Not EOLn(F) Do
          Begin
            Inc(i);
            Read(F, A[i]);
          End;
        ReadLn(F);
      End;
    N := i;
    If N < 100 Then
      Begin
        WriteLn('Day ban dau:');
        For i := 1 To N Do Write(A[i]:4);
      End;
    WriteLn;
    Close(F);
  End;

Procedure Sinh_Du_Lieu(N : Word; TenTepDL : String);
  Var
    F : Text;
    i, j : Word;
  Begin
    Randomize;
    If N < 1000 Then j := N
                Else j := 1000;
    For i := 1 To N Do A[i] := Random(j);
    Assign(F, TenTepDL);
    ReWrite(F);
    For i := 1 To N Do
      If (i Mod 10 <> 0)Or(i = N) Then Write(F, A[i]:4)
                                  Else WriteLn(F, A[i]:4);
    Close(F);
  End;

Procedure Xoa;
  Var
    i, j : Word;
  Begin
    FillChar(Nhan, SizeOf(Nhan), 0);
    FillChar(Truoc, SizeOf(Truoc), 0);
    A[0] := 65525;
    A[N+1] := A[N];
    For i := 1 To N Do
      Begin
        Inc(Nhan[i]);
        For j := i+1 To N+1 Do
          If A[i] <= A[j] Then
            If (Nhan[i] > Nhan[j])Or((A[i] < A[Truoc[j]])And
              (Nhan[i] = Nhan[j])) Then
              Begin
                Truoc[j] := i;
                Nhan[j] := Nhan[i];
              End;
      End;
  End;

Procedure Xuat_KQ;
  Var
    i, j, Max : Word;
  Begin
    Max := 0;
    For i := 1 To N Do
      If Max <= Nhan[i] Then
        Begin
          If ((Max = Nhan[i])And(A[j] > A[i]))Or(Max < Nhan[i]) Then j := i;
          Max := Nhan[i];
        End;
    FillChar(Nhan, SizeOf(Nhan), 0);
    i := j;
    While Truoc[i] <> 0 Do
      Begin
        Nhan[i] := 1;
        i := Truoc[i];
      End;
    Nhan[i] := 1;
    j := 0;
    For i := 1 To N Do
      If Nhan[i] <> 1 Then Inc(j);
    WriteLn('Tong so phan tu can xoa: ', j);
    WriteLn('Chi so cua cac phan tu bi xoa trong day:');
    For i := 1 To N Do
      If Nhan[i] <> 1 Then Write(i:8);
    WriteLn;
    WriteLn('Day con lai gom co ', N-j, ' phan tu:');
    For i := 1 To N Do
      If Nhan[i] = 1 Then Write(A[i]:8);
  End;

Begin
  ClrScr;
{  Sinh_Du_Lieu(Max, 'data4.tst');{}
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  Xoa;
  Xuat_KQ;
  WriteLn;
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  WriteLn('Nhan Enter de dung chuong trinh ...');
  ReadLn;
End.