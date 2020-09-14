{$R-,S-}

Program Tim_Xau_Con_Chung_Max;

Uses CRT;

Const
  VoCung = 255;

Var
  ThuTu, Nhan, Nhom, Truoc : Array[1..10000] Of Byte;
  Xau1, Xau2, XauChung : String;
  N : Word;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i : Byte;
  Begin
    TenTepDL := 'xc.inp';
{    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, Xau1);
    ReadLn(F, Xau2);
    Close(F);
  End;

Function Xau_Chung_2_Xau(S1, S2 : String) : String;
  Var
    S : String;
    MaxTT : Word;
    SoNhom, NhanMax, M, i, j, k, l : Byte;
  Begin
    FillChar(ThuTu, Sizeof(ThuTu), 0);
    FillChar(Nhom, Sizeof(Nhom), 0);
    MaxTT := 0;
    SoNhom := 0;
    For i := 1 To Length(S2) Do
      Begin
        Inc(SoNhom);
        For j := 1 To Length(S1) Do
          If S2[i] = S1[j] Then
            Begin
              Inc(MaxTT);
              ThuTu[MaxTT] := j;
              Nhom[MaxTT] := SoNhom;
            End;
      End;
    {  Tro ve bai toan tim day con khong giam dai nhat }
    FillChar(Truoc, SizeOf(Truoc), 0);
    FillChar(Nhan, SizeOf(Nhan), 0);
    i := 1;
    While i <= MaxTT-1 Do
      Begin
        k := i;
        M := VoCung;
        While (k <= MaxTT)And(Nhom[k] = Nhom[i]) Do
          Begin
            Inc(Nhan[k]);
            Inc(k);
          End;
        If k <= MaxTT Then
          For l := i To k-1 Do
            For j := i To MaxTT Do
              If ThuTu[l] < ThuTu[j] Then
                Begin
                  If (Nhan[l] > Nhan[j])Or((Nhan[l] = Nhan[j])And
                     (ThuTu[l] < ThuTu[Truoc[j]])) Then
                    Begin
                      Nhan[j] := Nhan[l];
                      Truoc[j] := l;
                    End;
                End;
        i := k;
      End;
    Inc(Nhan[MaxTT]);
    {  Ket qua }
    NhanMax := Nhan[1];
    For j := 1 To MaxTT Do
      If Nhan[j] > NhanMax Then
        Begin
          NhanMax := Nhan[j];
          i := j;
        End;
    Nhan[j] := VoCung;
    While Truoc[i] <> 0 Do
      Begin
        i := Truoc[i];
        Nhan[i] := VoCung;
      End;
    S := '';
    For i := 1 To MaxTT Do
      If Nhan[i] = VoCung Then
        S := S+S1[ThuTu[i]];
    Xau_Chung_2_Xau := S;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
  Begin
    XauChung := Xau_Chung_2_Xau(Xau1, Xau2);
    WriteLn('Xau con chung cua 2 xau la: ');
    WriteLn(XauChung);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Write('Nhan phim Enter de ket thuc chuong trinh ...');
  ReadLn;
END.