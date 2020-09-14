{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT, DOS;

Const
  Max = 1111111;

Var
  N : String;

Function IsPalindromicStr(S : String) : Boolean;
  Var
    i : Byte;
  Begin
    i := 1;
    While (i <= Length(S) Div 2)And(S[i] = S[Length(S)-i+1]) Do Inc(i);
    IsPalindromicStr := i > Length(S) Div 2;
  End;

Function IsPalindromicNumber(N : LongInt) : Boolean;
  Var
    i : Byte;
    S : String;
  Begin
    Str(N, S);
    IsPalindromicNumber := IsPalindromicStr(S);
  End;

Procedure Bien_Doi(S : String);
  Var
    i, j : Byte;
  Begin
    WriteLn('Bien doi:');
    j := 0;
    For i := 1 To Length(S) Div 2 Do
      If S[i] <> S[Length(S)-i+1] Then
        Begin
          Write('  Vi tri ', i, ': ''', S[Length(S)-i+1], ''' -> ''', S[i], '''');
          S[Length(S)-i+1] := S[i];
          WriteLn(' duoc xau: ''', S, '''');
          Inc(j);
        End;
    WriteLn('Xau moi: ', S);
    WriteLn('So phep bien doi: ', j);
  End;

Procedure Liet_Ke;
  Var
    i, j : LongInt;
  Begin
    j := 0;
    For i := 0 To Max Do
      If IsPalindromicNumber(i*9) Then
        Begin
          Write(i*9:8);
          Inc(j);
        End;
    WriteLn;
    WriteLn('So Palindromic tim duoc: ', j);
  End;

BEGIN
  ClrScr;
  Write('Nhap xau N: ');
  ReadLn(N);
  If IsPalindromicStr(N) Then WriteLn('Xau ''', N, ''' la 1 palindromic')
   Else
    Begin
      WriteLn('Xau ''', N, ''' khong la palindromic');
      Bien_Doi(N);
    End;
  Write('Nhan phim Enter de tiep tuc ...');
  ReadLn;
  ClrScr;
  WriteLn('Cac so tu nhien la Palindrom khong qua 7 chu so va chia het cho 9:');
  Liet_Ke;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.