Program Xep_Hau;

{
* Problem:
    Xep N con hau len ban co N*N sao cho khong con nao khong che con nao.
    (Hau co the an ngang, doc, cheo).

* Solution:
    + Concept:
        - Tai moi vi tri dat hau, ta danh dau tat ca cac hang, cot bi no
          khong che.
        - Ta xep hau lan luot theo chieu tu tren xuong duoi nen khong can
          phai danh dau cac hang ngang.
        - Moi ban co gom 2*N-1 duong cheo chinh va 2*N-1 duong cheo phu,
          Tai cac duong cheo chinh thi hieu toa do cua no khong doi va
          tai cac duong cheo phu thi tong toa do cua no cung khong doi
          --> Ta dung 3 mang de danh dau:
                A[1..N*N] : Danh dau cac cot chieu ngang
                B[2..2*N] : Danh dau cac duong cheo phu
                C[1-N..N-1] : Danh dau cac duong cheo chinh
    + Algorithm: De qui quay lui
        -> Du lieu:
            Xep[1..N] : Mang lu tru vi tri con hau duoc xep
            i, j : Vi tri hang, cot cua con hau dang duoc xep,
                   voi i, j = 1..N.
            .Bat dau
               i = 1;
               j = 1;
       /-----> .While A[j] va B[i-j] va C[i+j] chua bi danh dau .Do j = j+1
       |       .Neu j <= N .Thi
       |         .Neu i < N .Thi i = i+1
       |         .Nguoc lai: Xuat ra ket qua
       |       .Nguoc lai:
       |         .Neu i > 1 .Thi
       |           i = i-1;
       \---------< j = j+1;
                 .Nguoc lai: Ket thuc
            .Ket thuc
}

Uses CRT;

Const
  NMax = 15;

Var
  Xep : Array[1..NMax] Of Byte;
  A : Array[1..NMax] Of Byte;
  B : Array[2..2*NMax] Of Byte;
  C : Array[1-NMax..NMax-1] Of Byte;
  N : Byte;
  Time, Dem : LongInt;
  i : Integer;

Procedure Xuat;
  Var
    i, j : Byte;
  Begin
    For j := 1 To N Do Write('----');
    WriteLn('-');
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          If Xep[i] = j Then Write('³', i:2, ' ')
                        Else Write('³   ');
        WriteLn('³');
        For j := 1 To N Do Write('----');
        WriteLn('-');
      End;
    WriteLn;
    Inc(Dem);
{    ReadLn;{}
  End;

Procedure XepHau(i : Byte);
  Var
    j, k : Byte;
  Begin
    For j := 1 To N Do
       If (A[j] = 0)And(B[i+j] = 0)And(C[i-j] = 0) Then
        Begin
          A[j] := 1;
          B[i+j] := 1;
          C[i-j] := 1;
          Xep[i] := j;
          If i = N Then {Inc(Dem)}Xuat
                   Else XepHau(i+1);
          Xep[i] := 0;
          A[j] := 0;
          B[i+j] := 0;
          C[i-j] := 0;
        End;
  End;

BEGIN
  ClrScr;
  Write('Nhap kich thuoc ban co: ');
  ReadLn(N);
  Time := MemL[$0000:$046C];
  FillChar(Xep, SizeOf(Xep), 0);
  For i := 1 to N do A[i] := 0;
  For i := 2 to 2*N do B[i] := 0;
  For i := 1-N to N-1 do C[i] := 0;
  XepHau(1);
  WriteLn('Co ', Dem,' cach xep!');
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:5);
  ReadLn;
END.