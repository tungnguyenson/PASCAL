{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  Max = 200;

Type
  Luoi = Array[1..Max, 1..Max] Of Char;

Var
  A : ^Luoi;
  W : Array[1..3] Of String;
  L : String;
  N, i : Byte;

Function GiaiMa(M, N : Byte) : String;
  Var
    x, y : Byte;
    Tang : ShortInt;
    S : String;
  Begin
    Tang := 1;
    x := 1;
    S := '';
    For y := 1 To M Do
      Begin
        While (x >=1 )And(x <= N) Do
          Begin
            S := S+A^[y, x];
            Inc(x, Tang);
          End;
        Tang := -Tang;
        Inc(x, Tang);
      End;
    GiaiMa := S;
  End;

Procedure Xuat_Ma_Tran(Var Out : Text; M, N : Byte; S : String);
  Var
    i, j : Byte;
  Begin
    WriteLn(Out, M, ' ', N);
    For i := 1 To M Do
      Begin
        For j := 1 To N Do
          If j < N Then Write(Out, A^[i, j], ' ')
                   Else WriteLn(Out, A^[i, j]);
      End;
    WriteLn(Out, S);
    WriteLn(Out);
  End;

Procedure Xay_Dung_Mang(N : Byte);
  Var
    i, j : Byte;
    S, TenTepKQ : String;
    F : Text;
  Begin
    TenTepKQ := 'mh.out';
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To Length(L) Do
      If Length(L) Mod i = 0 Then
        Begin
          For j := 1 To Length(L) Do
            A^[(j-1) Mod i+1, (j-1) Div i+1] := L[j];
          S := GiaiMa(i, Length(L) Div i);
          j := 1;
          While (j <= N)And(Pos(W[j], S) = 0) Do Inc(j);
          If (j <= N)Or(N = 0) Then
            Begin
              Xuat_Ma_Tran(F, i, Length(L) Div i, S);
              Xuat_Ma_Tran(Output, i, Length(L) Div i, S);
            End;
        End;
    Close(F);
  End;

Procedure Phan_1;
  Begin
    Writeln('PHAN 1:');
    Write('Nhap xau ma hoa: ');
    ReadLn(L);
{    L := 'ViosiitnrteaaeytNlv-n--i-amUn-';{}
  End;

Procedure Phan_2;
  Begin
    Writeln('PHAN 2:');
    Xay_Dung_Mang(0);
  End;

Procedure Phan_3;
  Begin
    Writeln('PHAN 3:');
    Write('  N = ');
    ReadLn(N);
    For i := 1 To N Do
      Begin
        Write('  Nhap tu thu ', i,': ');
        ReadLn(W[i]);
      End;
    Xay_Dung_Mang(N);
  End;

BEGIN
  ClrScr;
  New(A);
  Phan_1;
  Phan_2;
  Phan_3;
  Dispose(A);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.