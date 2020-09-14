{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  MaxCity = 10;
  MaxAnswer = 50;

Var
  CityName : Array[1..MaxCity] Of String[15];
  City, A, Xet : Array[1..MaxCity] Of Byte;
  Answer : Array[1..MaxAnswer, 1..MaxCity] Of Byte;
  Mark : Array[1..MaxAnswer] Of Byte;
  M, N, G, MarkCount : Byte;
  FO : Text;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    S, S0, TenTepDL : String;
    F : Text;
    i, j, k : Byte;
    Result : Integer;
  Begin
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To N Do
      ReadLn(F, CityName[i]);
    MarkCount := 0;
    For i := 1 To M Do
      Begin
        ReadLn(F, S);
        j := 0;
        While Pos(',', S) > 0 Do
          Begin
            Inc(j);
            S0 := Copy(S, 1, Pos(',', S)-1);
            Delete(S, 1, Pos(',', S));
            k := 1;
            While (k <= N)And(CityName[k] <> S0) Do Inc(k);
            If k > N Then ; {Error}
            Answer[i, j] := k;
          End;
        Val(S, Mark[i], Result);
        MarkCount := MarkCount+Mark[i];
      End;
    Close(F);
  End;

Function CheckAnswer : Boolean;
  Var
    i, j, k : Byte;
    ThoaMan : Boolean;
  Begin
    ThoaMan := True;
    i := 0;
    While (i < M) And ThoaMan Do
      Begin
        Inc(i);
        k := 0;
        For j := 1 To N Do
          If Answer[i, j] = A[j] Then Inc(k);
        If (k <> Mark[i])Or(k > MarkCount) Then ThoaMan := False;
      End;
    CheckAnswer := ThoaMan;
  End;

Procedure BTrack(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To N Do
      If Xet[j] = 0 Then
        Begin
          Xet[j] := 1;
          A[i] := j;
          If i < N Then BTrack(i+1)
           Else ;{

            If CheckAnswer Then
              Begin
                For G := 1 To N Do
                  If G < N Then Write(FO, CityName[A[G]], ',')
                           Else WriteLn(FO, CityName[A[G]]);
              End;}
          Xet[j] := 0;
        End;
  End;

Procedure Thuc_Hien;
  Var
    TenTepKQ : String;
  Begin
    Write('Nhap ten tep ket qua: ');
    ReadLn(TenTepKQ);
    Time := MemL[0:1132];
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    FillChar(A, SizeOf(A), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    BTrack(1);
    Close(FO);
  End;

BEGIN
  ClrScr;
{  Doc_Du_Lieu;}
  N := 20;
  Thuc_Hien;
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-Time)/18.2:10:5, ' giay');
END.