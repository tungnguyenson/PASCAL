{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  SoChuSoToiDa = 5000;

Type
  KieuSoLon = Record
                Sign : Boolean;
                SoChuSo : Word;
                ChuSo : Array[1..SoChuSoToiDa] Of Word;
              End;

Var
  So, So1, So2 : KieuSoLon;
  N, i, Max : Word;
  S : String;
  SoBuocLap, Time : LongInt;

Procedure GanGiaTri(Var So : KieuSoLon; GiaTri : String);
  Var
    i : Byte;
  Begin
    If GiaTri[1] = '-' Then
      Begin
        So.Sign := True;
        Delete(GiaTri, 1, 1);
      End
     Else So.Sign := False;
    With So Do
      Begin
        SoChuSo := Length(GiaTri);
        FillChar(ChuSo, SizeOf(ChuSo), 0);
        For i := 1 To SoChuSo Do
          ChuSo[SoChuSo-i+1] := Ord(GiaTri[i])-48;
      End;
  End;

Procedure GhiGiaTri(So : KieuSoLon);
  Var
    i : Word;
  Begin
    With So Do
      Begin
        If Sign = True Then Write('-');
        For i := SoChuSo DownTo 1 Do
          Write(ChuSo[i]);
      End;
    WriteLn;
  End;

Procedure Multi(A, B : KieuSoLon; Var C : KieuSoLon);
  Var
    i, j, k, Nho, L, H, M, N : Word;
  Begin
{    GanGiaTri(C, '0');{}
    Nho := 0;
    With C Do
      Begin
        M := A.SoChuSo;
        N := B.SoChuSo;
        Sign := A.Sign XOR B.Sign;
        For i := 1 To M+N-1 Do
          Begin
            ChuSo[i] := Nho;
            If i >= M Then H := M
                      Else H := i;
            L := (i+1)-H;
            If L >= N Then L := N;
            For j := L To H Do
              ChuSo[i] := ChuSo[i]+A.ChuSo[j]*B.ChuSo[i+1-j];
            Inc(SoBuocLap, H-L+1);
            If ChuSo[i] > Max Then Max := ChuSo[i];
            Nho := ChuSo[i] Div 10;
            ChuSo[i] := ChuSo[i] Mod 10;
          End;
        SoChuSo := M+N-1;
        While Nho <> 0 Do
          Begin
            Inc(SoChuSo);
            ChuSo[SoChuSo] := Nho Mod 10;
            Nho := Nho Div 10;
          End;
      End;
  End;

BEGIN
  ClrScr;
  Write('Nhap N = ');
  ReadLn(N);
  Time := MemL[$0000:$046C];
  Max := 0;
  SoBuocLap := 0;
  GanGiaTri(So, '1');
  For i := 1 To N Do
    Begin
      Str(i, S);
      GanGiaTri(So1, S);
      Multi(So, So1, So);
    End;
  Write(N, '! = ');
  GhiGiaTri(So);
  WriteLn('So chu so: ', So.SoChuSo);
  WriteLn('Elapsed time: ', (MemL[$0000:$046C]-Time)/18.2:10:5);
  WriteLn(Max);{}
  WriteLn(SoBuocLap);{}
  Write('Press Enter to exit...');
  ReadLn;
END.