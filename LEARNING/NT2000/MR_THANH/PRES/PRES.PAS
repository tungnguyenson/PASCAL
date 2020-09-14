Uses CRT;

Const
  TenTepDL = 'PRES.INP';
  TenTepKQ = '';
  MaxCongTy = 100;
  MaxKhach  = 200;

Var
  DU : Array[1..MaxKhach, 1..MaxCongTy] Of Byte;
  CT : Array[1..MaxCongTy] Of String[10];
  Khach : Array[1..MaxKhach] Of String[10];
  SoTuyen : Array[1..MaxCongTy] Of Byte;
  SoKhach, SoCTy : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
    S : String;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, SoCTy);
    For i := 1 To SoCTy Do
      Begin
        Read(F, SoTuyen[i]);
        ReadLn(F, CT[i]);
        Delete(CT[i], 1, 1);
      End;
    ReadLn(F, SoKhach);
    For i := 1 To SoKhach Do
      ReadLn(F, Khach[i]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j, k, l : Byte;
  Begin
    FillChar(DU, SizeOf(DU), 0);
    For i := 1 To SoKhach Do
      For j := 1 To SoCTy Do
        Begin
          k := 0;
          For l := 1 To Length(Khach[i]) Do
            If Pos(Khach[i, l], CT[j]) <> 0 Then Inc(k);
          If k = Length(CT[j]) Then DU[i, j] := 1;
          If k = Length(CT[j]) Then WriteLn(i, ', ', j);
        End;
  End;

Procedure Tim_Duong_Tang_Cap_Ghep;
  Begin
  End;

Procedure Tang_Cap_Ghep;
  Begin
  End;

Procedure Sua_Nhan;
  Begin
  End;

Procedure Thuc_Hien;
  Begin
  End;

BEGIN
  Clrscr;
  Doc_Du_Lieu;
  Khoi_Tao;
END.