{$R-,S-}
Program Suy_Dien_Menh_De;

Uses CRT;

Const
  Max = 26;
  TenTepDL = 'lk6';
  TenTepKQ = 'con';

Var
  Suyra : Array['A'..'Z', 1..Max] Of Char;
  Stack : Array[1..Max] Of Char;
  Xet, SL : Array['A'..'Z'] Of Byte;
  F : Text;
  MDDau, MDCuoi : Char;
  Time, Dem : LongInt;

Procedure Doc_Du_Lieu;
  Var
    S : String;
    i, j, k, l : Byte;
    Ch : Char;
  Begin
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, S);
    FillChar(SuyRa, SizeOf(SuyRa), 0);
    FillChar(SL, SizeOf(SL), 0);
    MDDau := S[1];
    MDCuoi := S[2];
    Repeat
      ReadLn(F, S);
      For j := 2 To Length(S) Do
        If S[j] <> S[1] Then
          Begin
            l := 1;
            While (l <= SL[S[1]])And(SuyRa[S[1], l] <> S[j])Do Inc(l);
            If (SL[S[1]] = 0)Or(l > SL[S[1]]) Then
              Begin
                Inc(SL[S[1]]);
                SuyRa[S[1], SL[S[1]]] := S[j];
              End;
          End;
    Until EOF(F);
    WriteLn('Du lieu vao:');
    For Ch := 'A' To 'Z' Do
      If SL[Ch] <> 0 Then
        Begin
          Write(Ch);
          For i := 1 To SL[Ch] Do Write(SuyRa[Ch, i]);
          WriteLn;
        End;{}
    Close(F);
  End;

Procedure Xuat_KQ(Top : Byte);
  Var
    i : Byte;
  Begin
    Inc(Dem);
    If Dem = 1 Then WriteLn('Cac cach suy ra menh de ', MDCuoi,
                             ' tu menh de ', MDDau, ' la: ');
    For i := 1 To Top Do Write(F, Stack[i]);
    WriteLn(F);{}
  End;

Procedure Tim(i : Byte; MD : Char);
  Var
    j : Byte;
  Begin
    For j := 1 To SL[MD] Do
      If Xet[SuyRa[MD, j]] = 0 Then
        Begin
          Stack[i] := SuyRa[MD, j];
          Xet[Stack[i]] := 1;
          If Stack[i] = MDCuoi Then Xuat_KQ(i)
                               Else Tim(i+1, Stack[i]);
          Xet[Stack[i]] := 0;
          Stack[i] := #0;
        End;
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  FillChar(Stack, SizeOf(Stack), 0);
  FillChar(Xet, SizeOf(Xet), 0);
  Stack[1] := MDDau;
  Xet[MDDau] := 1;
  Assign(F, TenTepKQ);
  ReWrite(F);
  Tim(2, MDDau);
  Close(F);
  If Dem > 0 Then WriteLn('So cach suy ra la: ', Dem)
             Else WriteLn('Khong co cach suy ra nao!');
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.