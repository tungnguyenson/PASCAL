Program Phan_Tich;

(*
     Phan tich 1 so cho truoc thanh tong cac so tu nhien nho hon no
     sao cho moi cach phan tich chi duoc tinh 1 lan.
 *)

Uses CRT;

Var
  A : Array[1..100] Of Byte;
  N, t, i, j : Byte;
  Time, Dem : LongInt;

Procedure Xuat(i : Byte);
  Var
    j : Byte;
  Begin
    Inc(Dem);
    Write(N, ' = ');
    For j := 1 To i-1 Do Write(A[j], '+');
    WriteLn(A[i]);
  End;

Begin
  ClrScr;
  ReadLn(N);
  Time := MemL[$0000:$046C];
  i := 1;
  t := N;
  A[1] := N;
  Dem := 0;
  Xuat(1);
  Repeat
    If A[i] > 1 Then
      Begin
        Dec(A[i]);
        Dec(t);
        While t < N Do
          Begin
            If A[i] < N-t Then A[i+1] := A[i]
                          Else A[i+1] := N-t;
            t := t+A[i+1];
            Inc(i);
          End;
        Xuat(i);{}
{        Inc(Dem);{}
      End
     Else
      Begin
        j := i;
        While A[i] = 1 Do Dec(i);
        t := t-(j-i);
      End;
  Until i <= 0;
  WriteLn('Co ', Dem, ' cach!');
  Write('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:5, ' giay');
  ReadLn;
End.