Uses CRT;

Const
  TenTepDL = 'UNTWIST.INP';
  TenTepKQ = 'UNTWIST.OUT';
  Max = 255;

Var
  PlainCode, CipherCode : Array[0..Max] Of Integer;
  K : Integer;

Function TimNguyenTo(k : Integer) : Integer;
  Var
    i, j : Integer;
    NguyenTo : Boolean;
  Begin
    i := k;
    Repeat
      NguyenTo := True;
      Inc(i);
      For j := 2 To i Div 2 Do
        If i Mod j = 0 Then NguyenTo := False;
    Until NguyenTo;
    TimNguyenTo := i;
  End;

Procedure Tim_K;
  Var
    F : Text;
    S : String;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    K := 0;
    While Not EOF(F) Do
      Begin
        ReadLn(F, S);
        If Length(S) > K Then
          K := Length(S);
      End;
    Close(F);
  End;

Function Mode(x, y : Integer) : Integer;
  Begin
    x := x Mod y;
    If x < 0 Then x := x+y;
    Mode := x;
  End;

Procedure MaHoa(k : Integer; Var Txt : String);
  Var
    i, j, N: Integer;
  Begin
    N := Length(Txt);
    For i := 1 To N Do
      Case Txt[i] Of
        'a'..'z' : PlainCode[i-1] := Ord(Txt[i])-96;
        '_' : PlainCode[i-1] := 0;
        '.' : PlainCode[i-1] := 27;
      End;
    For i := 0 To N-1 Do
      CipherCode[i] := Mode(PlainCode[Mode(k*i, N)]-i, 28);
  End;

Procedure GiaiMa(k : Integer; Var Txt : String);
  Var
    i, N : Integer;
  Begin
    N := Length(Txt);
    For i := 1 To N Do
      Case Txt[i] Of
        'a'..'z' : CipherCode[i-1] := Ord(Txt[i])-96;
        '_' : CipherCode[i-1] := 0;
        '.' : CipherCode[i-1] := 27;
      End;
    For i := 0 To N-1 Do
      If (CipherCode[i]+i >= 0)And(CipherCode[i]+i <= 27) Then
          PlainCode[k*i Mod N] := CipherCode[i]+i
       Else PlainCode[k*i Mod N] := CipherCode[i]-28+i;
    For i := 1 To N Do
      Case PlainCode[i-1] Of
        1..26 : Txt[i] := Chr(PlainCode[i-1]+96);
        0 : Txt[i] := '_';
        27 : Txt[i] := '.';
      End;
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    S : String;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, S);
{        GiaiMa(K, S);{}
        MaHoa(K, S);{}
        WriteLn(FO, S);
      End;
    Close(FI);
    Close(FO);
  End;

BEGIN
  ClrScr;
  Tim_K;
  K := TimNguyenTo(K);
  Thuc_Hien;
END.