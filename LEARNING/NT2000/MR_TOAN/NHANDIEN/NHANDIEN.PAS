{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program Nhan_Dien_Hinh;

Uses CRT;

Const
  MaxN = 100;
  Next : Array[1..4, 1..2] Of ShortInt = ((0, 1), (-1, 0), (0, -1), (1, 0));
  Conv : Array[0..3] Of Byte = (3, 12, 6, 9);

Var
  Xet, A : Array[0..MaxN+1, 0..MaxN+1] Of Byte;
  Queue : Array[1..MaxN*MaxN, 1..2] Of Byte;
  GT : Array[1..MaxN*MaxN] Of Byte;
  Left, Right, SoMien : Word;
  N : Byte;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    TenTepDL : String;
    i, j, k : Byte;
  Begin
    TenTepDL := 'nd.in1';
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    FillChar(A, SizeOf(A), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    Close(F);
  End;

Function La_Tam_Giac : Boolean;
  Begin
    La_Tam_Giac := False;
    If ((GT[1] = 0)And(GT[2] = 2)) Or ((GT[1] = 1)And(GT[2] = 2)) Or
       ((GT[1] = 3)And(GT[2] = 1)) Or ((GT[1] = 3)And(GT[2] = 0)) Then
         La_Tam_Giac := True;
  End;

Function La_Hinh_Vuong(y, x : Byte) : Boolean;
  Begin
    La_Hinh_Vuong := False;
    If (A[y, x] = 3)And(A[y, x+1] = 1)And(A[y+1, x] = 0)And(A[y+1, x+1] = 2)
      Then La_Hinh_Vuong := True
  End;

Function La_Hinh_Thang : Boolean;
  Var
    i, j, Dem1, Dem2, Dem3 : Byte;
  Begin
    Dem1 := 0;
    Dem2 := 0;
    Dem3 := 0;
    For i := 1 To Right Do
      Begin
	     If GT[i] = GT[1] Then Inc(Dem1)
        Else If GT[i] =GT[2] Then Inc(Dem2)
        Else Inc(Dem3);
      End;
    La_Hinh_Thang := False;
    If (Dem3 = 0)And(Dem1 <> Dem2) Then La_Hinh_Thang := True;
  End;

Function La_Hinh_Binh_Hanh : Boolean;
  Var
    i, j, Dem1, Dem2, Dem3 : Byte;
  Begin
    Dem1 := 0;
    Dem2 := 0;
    Dem3 := 0;
    For i := 1 To Right Do
      Begin
	     If GT[i] = GT[1] Then Inc(Dem1)
        Else If GT[i] =GT[2] Then Inc(Dem2)
        Else Inc(Dem3);
      End;
    La_Hinh_Binh_Hanh := False;
    If (Dem3 = 0)And(Dem1 = Dem2) Then La_Hinh_Binh_Hanh := True;
  End;

Function Explore(y, x : Byte; Mark : Word) : Byte;
  Var
    i, j, u, v : Byte;
  Begin
{    FillChar(Queue, SizeOf(Queue), 0);{}
    Left := 1;
    Right := 1;
    Queue[Right, 1] := y;
    Queue[Right, 2] := x;
    Xet[y, x] := Mark;
    Repeat
      For i := 0 To 3 Do
        Begin
          u := y+Next[i+1, 1];
          v := x+Next[i+1, 2];
          If (Xet[u, v] = 0)And(u >= 1)And(u <= N)And(v >= 1)And(v <= N) Then
	    If (Conv[A[y, x]] And (1 Shl i) <> 0) And
               (Conv[A[u, v]] And (1 Shl ((i+2) Mod 4)) <> 0) Then
              Begin
                Inc(Right);
                Queue[Right, 1] := u;
                Queue[Right, 2] := v;
                Xet[u, v] := Mark;
              End;
        End;
      Inc(Left);
      y := Queue[Left, 1];
      x := Queue[Left, 2];
    Until Left > Right;
    For i := 1 To Right Do GT[i] := A[Queue[i, 1], Queue[i, 2]];
    If (Right = 1)Or((Right = 2) And La_Tam_Giac) Then Explore := 1
     Else If (Right = 4)And(La_Hinh_Vuong(Queue[1, 1], Queue[1, 2])) Then Explore := 2
     Else If La_Hinh_Thang Then Explore := 3
     Else If La_Hinh_Binh_Hanh Then Explore := 4
     Else Explore := 5;
  End;

Procedure Ghi_Ket_Qua(Var F : Text; KieuHinh : Byte);
  Var
    i : Word;
  Begin
    WriteLn(F, Right);
    For i := 1 To Right Do
      WriteLn(F, Queue[i, 1], ' ', Queue[i, 2]);
    WriteLn(F, KieuHinh);
    WriteLn(F);
  End;

Procedure Thuc_Hien;
  Var
    F : Text;
    TenTepKQ : String;
    i, j : Byte;
    DT : Word;
  Begin
    TenTepKQ := 'nd.o';
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);{}
    Time := MemL[0:1132];
    Assign(F, TenTepKQ);
    Rewrite(F);
    FillChar(Xet, SizeOf(Xet), 0);
    SoMien := 0;
    For i := 1 To N Do
      For j := 1 To N Do
        If Xet[i, j] = 0 Then
          Begin
            Inc(SoMien);
            Ghi_Ket_Qua(F, Explore(i, j, 1));
          End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.