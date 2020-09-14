{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Program May_Sinh_So;

Uses CRT;

Const
  TenTepDL = 'AUT.INP';
  TenTepKQ = 'AUT.OUT';
  MaxN = 200;

Var
  BangTT, BangRa : Array[0..MaxN-1, 0..9] Of Word;
  Xet_TT : Array[0..MaxN-1, 0..9] Of Byte;
  So, LuuTT : Array[1..MaxN*10] Of Byte;
  ViTriLap, Leng : Word;
  TT_KetThuc, TT_KhoiTao, GT_Vao : Word;
  N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 0 To N-1 Do
      For j := 0 To 19 Do
        If j < 10 Then Read(F, BangTT[i, j])
                  Else Read(F, BangRa[i, j-10]);
    ReadLn(F, TT_KhoiTao, TT_KetThuc, GT_Vao);
    Close(F);
  End;

Procedure Thuc_HIen;
  Var
    TT, GT : Word;
    i : Word;
    KT : Boolean;
  Begin
    FillChar(Xet_TT, SizeOf(Xet_TT), 0);
    GT := GT_Vao;
    TT := TT_KhoiTao;
    Xet_TT[TT, GT] := 1;
    ViTriLap := 0;
    KT := False;
    If TT <> TT_KetThuc Then
      Begin
        Repeat
          i := TT;
          TT := BangTT[TT, GT];
          GT := BangRa[i, GT];
          If Xet_TT[TT, GT] = 0 Then
            Begin
              Inc(Leng);
              So[Leng] := GT;
              LuuTT[Leng] := TT;
              Xet_TT[TT, GT] := 1;
            End
           Else KT := True;
        Until KT Or(TT = TT_KetThuc);
        If (Xet_TT[TT, GT] = 1)And(TT <> TT_KetThuc) Then
          Begin
            i := Leng-1;
            While (i > 0)And((LuuTT[i] <> TT)Or(So[i] <> GT)) Do Dec(i);
            ViTriLap := i;
          End;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If ViTriLap = 0 Then
      For i := 1 To Leng Do Write(F, So[i])
     Else
      Begin
        For i := 1 To ViTriLap-1 Do Write(F, So[i]);
        Write(F, '(');
        For i := ViTriLap To Leng Do Write(F, So[i]);
        Write(F, ')');
      End;
    Close(F);
  End;

BEGIN
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.