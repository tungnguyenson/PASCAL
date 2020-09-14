Uses CRT;

Var
  N : Word;
  T : LongInt;

Function TongCS(N : Word) : Word;
  Var
    i, j : Word;
  Begin
    i := 0;
    Repeat
      j := N Mod 10;
      i := i+j;
      N := (N-j) Div 10;
    Until N < 1;
    TongCS := i;
  End;

Procedure Tinh_Tong_CS;
  Var
    i : Word;
  Begin
    T := 0;
    For i := 1 To N Do
      T := T+TongCS(i);
  End;

Function La_So_CP : Boolean;
  Var
    S : String;
    i, j : Integer;
  Begin
    La_So_CP := True;
    If N < 10 Then
      Begin
        T := 0;
        For i := 1 To N Do T := T*10+i;
        If Trunc(Trunc(Sqrt(T))*Trunc(Sqrt(T))) <> T Then La_So_CP := False
         Else
			 Begin
			   La_So_CP := True;
            WriteLn(Trunc(Sqrt(T)), 'ý');
          End;
      End
     Else
      Begin
        Tinh_Tong_CS;
        If (T Mod 3 = 2) Then La_So_CP := False Else
        If (T Mod 3 = 0)And(T Mod 9 <> 0) Then La_So_CP := False Else
        Str(N, S);
        If Length(S) < 2 Then S := '0'+S;
        Val(Copy(S, Length(S)-1, 2), i, j);
        If (i Mod 5 = 0)And(i Mod 25 <> 0) Then La_So_CP := False Else
        If (i Mod 2 = 0)And(i Mod 4 <> 0) Then La_So_CP := False Else
         La_So_CP := False;
      End;
  End;

BEGIN
  ClrScr;
  Write('Nhan so N: ');
  ReadLn(N);
  If La_So_CP = False Then
    Begin
	   WriteLn('Day so 1..', N, ' khong phai la so chinh phuong!')
    End
   Else
    WriteLn('Day so 1..', N, ' la so chinh phuong!');
  ReadLn;
END.