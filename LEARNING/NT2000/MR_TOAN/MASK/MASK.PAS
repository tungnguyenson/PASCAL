Uses CRT;

Const
  TenTepDL = 'MANA.IN2';
  TenTepKQ = 'MANA.OUT';
  MaxN = 100;

Type
  Mang = Array[1..MaxN, 1..MaxN] Of Char;

Var
  A, M, DaXet : Mang;
  SoKiTu : Word;
  N : Byte;
  Error : Boolean;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    FillChar(A, SizeOf(A), 0);
    FillChar(M, SizeOf(M), 0);
    For i := 1 To N Do
      Begin
        j := 0;
        While Not EOLn(F) Do
		    Begin
            Inc(j);
  			   Read(F, A[i, j]);
          End;
        ReadLn(F);
      End;
    For i := 1 To N Do
      Begin
        j := 0;
        While Not EOLn(F) Do
		    Begin
            Inc(j);
  			   Read(F, M[i, j]);
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do
      For j := 1 To N Do
        If A[i, j] = #0 Then A[i, j] := ' ';
  End;

Procedure Quay_90_Do;
  Var
    TG : ^Mang;
    i, j : Byte;
  Begin
    New(TG);
    For i := 1 To N Do
      For j := 1 To N Do
        TG^[j, N-i+1] := M[i, j];
    M := TG^;
    Dispose(TG);
  End;

Procedure Giai_Ma;
  Var
    F : Text;
    Q, i, j : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    SoKiTu := 0;
    Q := 0;
    Error := False;
    FilLChar(DaXet, SizeOf(DaXet), 0);
    While (Q <= 3)And(SoKiTu <> N*N)And(Error = False) Do
      Begin
        For i := 1 To N Do
          For j := 1 To N Do
            If M[i, j] = '1' Then
              Begin
                If DaXet[i, j] = '1' Then Error := True
                 Else
                  Begin
                    Inc(SoKiTu);
                    Write(F, A[i, j]);
                    DaXet[i, j] := '1';
                  End;
              End;
        Inc(Q);
        Quay_90_Do;
      End;
    If {(SoKiTu <> N*N)Or {}Error Then
      Begin
        Rewrite(F);
        Write(F, 0);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Giai_Ma;
END.