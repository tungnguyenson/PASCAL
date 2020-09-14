{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  MaxN = 99;
  MaxBall = MaxN*MaxN-1;

Var
  Ball : Array[1..MaxBall, 1..2] Of Byte;
  KC : Array[1..MaxBall] Of Word;
  X0, y0 : Byte;
  Time, Energy : LongInt;
  N : Byte;
  K : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    TenTepDL : String;
    i : Word;
  Begin
    TenTepDL := 'push.in3';
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    ReadLn(F, K);
    For i := 1 To K Do
      ReadLn(F, Ball[i, 1], Ball[i, 2]);
    Close(F);
  End;

Function KhoangCach(y, x : Byte) : Byte;
  Begin
    KhoangCach := Abs(y-y0)+Abs(x-x0);
  End;

Procedure SwapByte(Var i, j : Byte);
  Var
    k : Byte;
  Begin
    k := i;
    i := j;
    j := k;
  End;

Procedure SwapWord(Var i, j : Word);
  Var
    k : Word;
  Begin
    k := i;
    i := j;
    j := k;
  End;

Procedure Sort(Left, Right : Word);
  Var
    L, R, V : Word;
  Begin
    L := Left;
    R := Right;
    V := KC[(L+R) Div 2];
    While L <= R Do
      Begin
        While KC[L] < V Do Inc(L);
        While KC[R] > V Do Dec(R);
        If L <= R Then
          Begin
            SwapWord(KC[L], KC[R]);
            SwapByte(Ball[L, 1], Ball[R, 1]);
            SwapByte(Ball[L, 2], Ball[R, 2]);
            Inc(L);
            Dec(R);
          End;
      End;
    If Left < R then Sort(Left, R);
    If L < Right then Sort(L, Right);
  End;

Procedure Khoi_Tao;
  Var
    i, j : Word;
  Begin
    y0 := (N+1) Div 2;
    x0 := (N+1) Div 2;
    For i := 1 To K Do
      KC[i] := KhoangCach(Ball[i, 1], Ball[i, 2]);
    Sort(1, K);
    Energy := 0;
  End;

Procedure Push(Var F : Text; x, y : Byte);
  Var
    i : Byte;
    IncX, IncY : ShortInt;
    E : Word;
  Begin
    If y < y0 Then IncY := 1
              Else IncY := -1;
    If x < x0 Then IncX := 1
              Else IncX := -1;
    If (y <> y0)And(x <> x0) Then
      Begin
        Write(F, x, ' ', y, ' ');
        i := 0;
        While (y <> y0)And(x <> x0) Do
          Begin
            Inc(i);
            y := y+IncY;
            x := x+IncX;
          End;
        Energy := Energy+i*15;
        WriteLn(F, x, ' ', y, ' ', Energy);
      End;
    If (y = y0)XOr(x = x0) Then
      Begin
        If y = y0 Then E := Abs(x-x0)*10
         Else E := Abs(y-y0)*10;
        Energy := Energy+E;
        WriteLn(F, x, ' ', y, ' ', x0, ' ', y0, ' ', Energy);
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    TenTepKQ : String;
    i : Word;
  Begin
    TenTepKQ := 'push.out';
{    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To K Do Push(F, Ball[i, 1], Ball[i, 2]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Time := MemL[0:1132];
  Doc_Du_Lieu;
  Khoi_Tao;
  Ghi_Ket_Qua;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);{}
END.