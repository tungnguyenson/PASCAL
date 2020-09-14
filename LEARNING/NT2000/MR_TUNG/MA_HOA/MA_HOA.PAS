Uses CRT;

Const
  TenTepDL = 'CODE.INP';
  TenTepKQ = 'CODE.OUT';
  Max = 100;

Var
  Xau : Array[1..Max] Of String;
  MT : Array[#65..#90, #65..#90] Of Byte;
  ThuTu : Array[#32..#255] Of Byte;
  Xet : Array[1..Max] Of Byte;
  Dau, Cuoi : String;
  MaxThuTu : Byte;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
    Ch : Char;
  Begin
    FillChar(MT, Sizeof(MT), 0);
    Dau := Cuoi;
    For i := 1 To Length(Dau)-1 Do
      For j := i+1 To Length(Dau) Do
        If Ord(Dau[i]) > Ord(Dau[j]) Then
          Begin
            Ch := Dau[i];
            Dau[i] := Dau[j];
            Dau[j] := Ch;
          End;
  End;

Procedure Giai_Ma;
  Var
    i, j : Byte;
  Begin
    For i := 1 To Length(Dau) Do
      MT[Cuoi[i], Dau[i]] := 1;
  End;

Procedure Sort;
  Var
    i, j : Byte;
  Begin
  End;

Procedure Ghi_Ket_Qua(Var F : Text; VT : Byte);
  Begin
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    S : String;
    VT : Byte;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, Cuoi);
        ReadLn(FI, VT);
        Khoi_Tao;
        Giai_Ma;
      End;
    Close(FI);
  End;

BEGIN
  ClrScr;
  Thuc_Hien;
END.

BANANA
ANANAB
NANABA
ANABAN
NABANA
ABANAN

ABANAN
ANABAN
ANANAB
BANANA
NABANA
NANABA



COGUMELO
OGUMELOC
GUMELOCO
UMELOCOG
MELOCOGU
ELOCOGUM
LOCOGUME
OCOGUMEL


A1B2C3
1B2C3A
B2C3A1
2C3A1B
C3A1B2
3A1B2C
