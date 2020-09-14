{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,0}
Program Bieu_Thuc_So_Hoc;

Uses CRT;

Const
  MaxN      = 100;
  MaxGiaTri = 100;

  SCS = 3;
  VoCung = 1.7e38;

  TenTepDL = 'ae2';
  TenTepKQ = 'con';

  Dau : Array[1..5] Of Char = ('+', '-', '*', '/', '^');

Var
  GiaTri : Array[1..MaxGiaTri] Of Real;
  KetQua : Array[1..MaxN] Of Real;
  BieuThuc : String;
  N, SoBien, SoGiaTri : Byte;
  SoBTHopLe : Byte;
  BTError : Boolean;
  F : Text;

Procedure Format_Str(Var St : String);
  Begin
    If St <> '' Then
      Begin
        While St[1] = ' ' Do Delete(St, 1, 1);
        While St[Length(St)] = ' ' Do Delete(St, Length(St), 1);
        While Pos('  ', St) <> 0 Do Delete(St, Pos('  ', St), 1);
      End;
  End;

Procedure Bieu_Thuc_Khong_Ngoac(Var BT : String);
  Var
    i, j, k : Byte;
    So1, So2, Kq : Real;
    S1, S2 : String;
    Error : Integer;
  Begin
    For i := 5 DownTo 1 Do
      While Pos(Dau[i], BT) <> 0 Do
        Begin
          j := Pos(Dau[i], BT);
          S1 := Copy(BT, j-SCS, SCS);
          S2 := Copy(BT, j+1, SCS);
          Val(S1, k, Error);
          So1 := GiaTri[k];
          Val(S2, k, Error);
          So2 := GiaTri[k];
          Case Dau[i] Of
            '+' : Kq := So1+So2;
            '-' : Kq := So1-So2;
            '*' : Kq := So1*So2;
            '/' : If So2 = 0 Then BTError := True
                             Else Kq := So1/So2;
            '^' : If So1 <= 0 Then Kq := 1/Exp(So2*Ln(-So1))
                              Else Kq := Exp(So2*Ln(So1));
          End;
          Delete(BT, j, SCS+1);
          Val(S1, k, Error);
          GiaTri[k] := Kq;
        End;
  End;

Procedure Tinh_Gia_Tri(Var BT : String);
  Var
    Dau, Cuoi : Byte;
    S : String;
  Begin
    BT := '('+BT+')';
    Repeat
      Dau := Length(BT);
      While (BT[Dau] <> '(')And(Dau > 0) Do Dec(Dau);
      If Dau > 0 Then
        Begin
          Cuoi := Dau;
          While (BT[Cuoi] <> ')')And(Cuoi <= Length(BT)) Do Inc(Cuoi);
          If Cuoi <= Length(BT) Then
            Begin
              S := Copy(BT, Dau+1, Cuoi-Dau-1);
              Bieu_Thuc_Khong_Ngoac(S);
              Delete(BT, Dau, Cuoi-Dau+1);
              Insert(S, BT, Dau);
            End
           Else BTError := True;
        End;
    Until (Dau = 0)Or(BTError);
    If Pos(')', BT) <> 0 Then BTError := True;
  End;

Procedure Xu_Li_Du_lieu(Var BT : String);
  Type
    SignType = (Rong, Ngoac, ChuSo, SoThuc, PhepTinh);
  Var
    Xet : Array['A'..'Z'] Of Byte;
    i, j : Byte;
    S, S0 : String;
    So : Real;
    Error : Integer;
    Ch : Char;
    Sign : SignType;
  Begin
    Format_Str(BT);
    For i := 1 To Length(BT) Do
      If BT[i] In ['a'..'z'] Then BT[i] := Upcase(BT[i]);
    While Pos('**', BT) <> 0 Do
      Begin
        j := Pos('**', BT);
        Delete(BT, j, 1);
        BT[j] := '^';
      End;
    FillChar(Xet, SizeOf(Xet), 0);
    For i := 1 To Length(BT) Do
      If (BT[i] In ['A'..'Z'])And(Xet[BT[i]] = 0) Then Xet[BT[i]] := 1;
    j := 0;
    For Ch := 'A' To 'Z' Do
      If Xet[Ch] <> 0 Then
        Begin
          Inc(j);
          Xet[Ch] := j;
        End;
    If j > SoBien Then BTError := True;
    S := BT;
    BT := '';
    i := 1;
    Sign := Rong;
    While (S <> '')And(BTError = False) Do
      Begin
        Case S[1] Of
          '(', ')', '+', '-', '*', '/', '^' :
            Begin
              BT := BT+S[1];
              If S[1] In ['(', ')'] Then Sign := Ngoac
               Else
                Begin
                  If Sign = PhepTinh Then BTError := True;
                  Sign := PhepTinh;
                End;
              Delete(S, 1, 1);
            End;
          'A'..'Z' :
            Begin
              Str(Xet[S[1]], S0);
              While Length(S0) < SCS Do S0 := '0'+S0;
              BT := BT+S0;
              Delete(S, 1, 1);
              Sign := ChuSo;
            End;
          '0'..'9' :
            Begin
              i := 1;
              While (S[i] In ['0'..'9', '.'])And(i <= Length(S)) Do Inc(i);
              S0 := Copy(S, 1, i-1);
              Val(S0, So, Error);
              If Error <> 0 Then BTError := True
               Else
                Begin
                  Delete(S, 1, i-1);
                  Inc(SoGiaTri);
                  GiaTri[SoGiaTri] := So;
                  Str(SoGiaTri, S0);
                  While Length(S0) < SCS Do S0 := '0'+S0;
                  BT := BT+S0;
                  Sign := SoThuc;
                End;
            End;
          Else BTError := True;
        End;
      End;
  End;

Procedure Doc_Du_Lieu;
  Var
    i, j : Byte;
    BT, S, S0 : String;
    Error : Integer;
  Begin
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, N);
    SoBTHopLe := 0;
    For i := 1 To N Do
      Begin
        ReadLn(F, BieuThuc);
        FillChar(GiaTri, SizeOf(GiaTri), 0);
        SoBien := 0;
        Repeat
          ReadLn(F, S);
          Format_Str(S);
          If S <> '' Then
            Begin
              S0 := S+' ';
              Repeat
                j := Pos(' ', S0);
                Inc(SoBien);
                Val(Copy(S0, 1, j-1), GiaTri[SoBien], Error);
                Delete(S0, 1, j);
              Until S0 = '';
            End;
        Until (S = '')Or(EOF(F));
        BTError := False;
        SoGiaTri := SoBien;
        Xu_Li_Du_Lieu(BieuThuc);
        If BTError = False Then
          Tinh_Gia_Tri(BieuThuc);
        If BTError = False Then
          Begin
            Inc(SoBTHopLe);
            Val(BieuThuc, j, Error);
            KetQua[i] := GiaTri[j];
          End
         Else KetQua[i] := VoCung;
      End;
    Close(F);
  End;

Procedure Ghi_Ket_Qua;
  Var
    i : Byte;
    S : String;
  Begin
    Assign(F, TenTepKQ);
    ReWrite(F);
    WriteLn(F, SoBTHopLe);
    For i := 1 To N Do
      If KetQua[i] <> VoCung Then
        Begin
          Str(KetQua[i]:20:11, S);
          While S[1] = ' ' Do Delete(S, 1, 1);
          If Pos('.', S) <> 0 Then
            While S[Length(S)] In ['0'] Do Delete(S, Length(S), 1);
          If S[Length(S)] = '.' Then Delete(S, Length(S), 1);
          WriteLn(F, i, ' ', S);
        End;
    Close(F);
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  Ghi_Ket_Qua;
End.