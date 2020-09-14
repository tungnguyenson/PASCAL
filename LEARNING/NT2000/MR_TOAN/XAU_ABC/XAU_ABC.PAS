{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 65520,0,655360}

Uses CRT;

Const
  KiTu : Array[1..3] Of Char = ('A', 'C', 'B');
  MaxLeng = 100;

Var
  S, S0, SSave : String;
  u, v : Byte;
  F : Text;
  MinB, Dem, DemB : LongInt;

Function Kiem_Tra : Boolean;
  Var
    u, v : Byte;
  Begin
    Kiem_Tra := True;
    For v := 1 To Length(S) Div 2 Do
      For u := 1 To Length(S)-v*2+1 Do
        If Copy(S, u, v) = Copy(S, u+v, v) Then
      	 Begin
            Kiem_Tra := False;
            Exit;
          End;
  End;

Procedure Tim(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To 3 Do
      Begin
        S := S+KiTu[j];
        If Kiem_Tra Then
          If i < MaxLeng Then Tim(i+1)
           Else
			    Begin
               S0 := S;
               u := 0;
               While Pos('B', S0) <> 0 Do
                 Begin
                   Inc(u);
                   Delete(S0, Pos('B', S0), 1);
                 End;
               If u < MinB Then
                 Begin
                   MinB := u;
                   SSave := S;
                   WriteLn(F, S, ' ', MinB);
                   WriteLn(MinB);
                 End;
               Inc(Dem);
               If KeyPressed Then
					  Begin
					    Close(F);
                   Halt;
                 End;
             End;
        Delete(S, Length(S), 1);
      End;
  End;

BEGIN
  ClrScr;
  Assign(F, 'abc.o');
  Rewrite(F);
  S := 'ABACABCACBACABACBCABACABCACBCABACBCACBACABACBCABACABCACBACABACBCACBACA';
  WriteLn(Kiem_Tra);
  Dem := 0;
  MinB := 100;
  DemB := 0;
  Tim(50);
  Close(F);
END.