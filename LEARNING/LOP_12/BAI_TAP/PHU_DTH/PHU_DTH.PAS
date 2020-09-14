{$M 16384, 0, 655360}

Program Phu_Doan_Thang;

Uses CRT;

Const
  Max_PQ = 5000;
  TenTepDL : String = 'phu5.';
  TenTepKQ : String = '';

Type
  Doan_Thang = Record
    Index : LongInt;
    Leng  : Word;
  End;
  Mang_DoanThang = Array[0..Max_PQ] Of Doan_Thang;

Var
  DoanThang : ^Mang_DoanThang;
  KetQua : Array[1..Max_PQ+1] Of LongInt;
  P, Q, SoDoanCanPhu : Word;
  N, RutGon : LongInt;
  TimeStart, TimeFinish : LongInt;

Procedure Doc_Du_Lieu;
  Var
    Index, L, R : LongInt;
    i, j : Word;
    F : Text;
  Begin
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    TimeStart := MemL[$0000:$046C];
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N, L, R);
    P := 0;
    RutGon := L;
    Q := R-RutGon;
    FillChar(DoanThang^, SizeOf(DoanThang^), 0);
    Index := 0;
    Repeat
      ReadLn(F, L, R);
      L := L-RutGon;
      R := R-RutGon;
      If L < P Then L := P;
      If R > Q Then R := Q;
      Inc(Index);
      If (L < Q) And (R > P) Then
        If DoanThang^[L].Leng < (R-L) Then
          Begin
            DoanThang^[L].Index := Index;
            DoanThang^[L].Leng  := (R-L);
          End;
    Until EOF(F) Or (Index = N);
    Close(F);
{    For i := P To Q Do
      If DoanThang^[i].Index <> 0 Then
        WriteLn(DoanThang^[i].Index, ' ', i+RutGon, ' ', i+RutGon+DoanThang^[i].Leng);
    WriteLn;
    For i := P To Q Do
      If DoanThang^[i].Index <> 0 Then
        WriteLn(DoanThang^[i].Index, ' ', i, ' ', DoanThang^[i].Leng);{}
  End;

Function Phu : Boolean;
  Var
    i, j, k, d, Max : Word;
  Begin
    i := 0;
    j := 0;
    Repeat
      Max := 0;
      For k := j To i Do
        If DoanThang^[k].Index <> 0 Then
          If k+DoanThang^[k].Leng > i Then
            If k+DoanThang^[k].Leng > Max Then
              Begin
                Max := k+DoanThang^[k].Leng;
                d := k;
              End;
      If Max <> 0 Then
        Begin
          Inc(SoDoanCanPhu);
          KetQua[SoDoanCanPhu] := DoanThang^[d].Index;
          DoanThang^[d].Index := 0;
          i := i+DoanThang^[d].Leng-(i-d);
          j := d+1;
        End;
    Until (i = Q) Or (Max = 0);
    Phu := i = Q;
  End;

Procedure Ghi_Ket_Qua(TonTaiNghiem : Boolean);
  Var
    i, j : Word;
    F : Text;
  Begin
    TimeFinish := MemL[$0000:$046C];
{    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);{}
    Assign(F, TenTepKQ);
    Rewrite(F);
    If Not TonTaiNghiem Then WriteLn(F, 0)
     Else
      Begin
        WriteLn(F, SoDoanCanPhu);
        For i := 1 To SoDoanCanPhu Do
          WriteLn(F, KetQua[i]);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  If MemAvail >= SizeOf(DoanThang) Then
    Begin
      New(DoanThang);
      Doc_Du_lieu;
      SoDoanCanPhu := 0;
      Ghi_Ket_Qua(Phu);
      Dispose(DoanThang);
      WriteLn('----------------------------------------');
      WriteLn('Thoi gian chay: ', (TimeFinish-TimeStart)/18.2:8:4, ' giay');
    End
   Else WriteLn('Khong du bo nho de thuc hien chuong trinh!');
  Write('Nhan phim Enter de ket thuc chuong trinh ...');
  ReadLn;{}
END.