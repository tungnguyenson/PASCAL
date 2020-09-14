{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
Uses CRT;

Const
  MaxK = 7;
  MaxN = 1 Shl MaxK;

Var
  Luoi : Array[1..MaxN, 1..MaxN] Of Word;
  K : Byte;
  Px, Py, i, j, N, GT : Word;

Procedure Nhap_Du_Lieu;
  Begin
    Write('K = ');  ReadLn(K);
    If (K < 1)Or(K > MaxK) Then
      Begin
        WriteLn('K khong thoa man!');
        Halt;
      End;
    Write('X = ');  ReadLn(Px);
    Write('Y = ');  ReadLn(Py);
    N := 1 Shl K;
    If (Px < 1)Or(Px > N)Or(Py < 1)Or(Py > N) Then
      Begin
        WriteLn('Toa do khong thoa man!');
        Halt;
      End;
  End;

Procedure Dien(y, x, a, My, Mx : Word);
  Begin
    If Not((My >= y)And(My < y+a Div 2)And(Mx >= x)And(Mx < x+a Div 2)) Then
      Luoi[y+a Div 2-1, x+a Div 2-1] := GT;
    If Not((My >= y)And(My < y+a Div 2)And(Mx >= x+a Div 2)And(Mx < x+a)) Then
      Luoi[y+a Div 2-1, x+a Div 2] := GT;
    If Not((My >= y+a Div 2)And(My < y+a)And(Mx >= x)And(Mx < x+a Div 2)) Then
      Luoi[y+a Div 2, x+a Div 2-1] := GT;
    If Not((My >= y+a Div 2)And(My < y+a)And(Mx >= x+a Div 2)And(Mx < x+a)) Then
      Luoi[y+a Div 2, x+a Div 2] := GT;
    If a > 2 Then
      Begin
        Inc(GT);
        If (My >= y)And(My < y+a Div 2)And(Mx >= x)And(Mx < x+a Div 2) Then
          Dien(y, x, a Div 2, My, Mx)
         Else Dien(y, x, a Div 2, y+a Div 2-1, x+a Div 2-1);
        Inc(GT);
        If (My >= y)And(My < y+a Div 2)And(Mx >= x+a Div 2)And(Mx < x+a) Then
          Dien(y, x+a Div 2, a Div 2, My, Mx)
         Else Dien(y, x+a Div 2, a Div 2, y+a Div 2-1, x+a Div 2);
        Inc(GT);
        If (My >= y+a Div 2)And(My < y+a)And(Mx >= x)And(Mx < x+a Div 2) Then
          Dien(y+a Div 2, x, a Div 2, My, Mx)
         Else Dien(y+a Div 2, x, a Div 2, y+a Div 2, x+a Div 2-1);
        Inc(GT);
        If (My >= y+a Div 2)And(My < y+a)And(Mx >= x+a Div 2)And(Mx < x+a) Then
          Dien(y+a Div 2, x+a Div 2, a Div 2, My, Mx)
         Else Dien(y+a Div 2, x+a Div 2, a Div 2, y+a Div 2, x+a Div 2);
      End;
  End;

Procedure Xuat_Ket_Qua;
  Var
    i, j : Word;
    TenTepKQ : String;
    F : Text;
  Begin
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          If Luoi[i, j] <> 0 Then Write(F, Luoi[i, j]:5)
                             Else Write(F, '    x');
        WriteLn(F);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;{}
  GT := 1;
  Dien(1, 1, N, Py, Px);
  Xuat_Ket_Qua;
END.