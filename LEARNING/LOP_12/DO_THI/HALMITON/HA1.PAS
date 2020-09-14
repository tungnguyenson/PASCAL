{$M 32768,0,0}
Uses CRT;

Const
  Max = 100;
  VoCung = 255;

Type
  Mang100 = Array[1..Max] Of Byte;
  Mang10000 = Array[1..Max*Max] Of Byte;
  Mang100x100 = Array[1..Max, 1..Max] Of Byte;

Var
  Stack, Bac : Mang100;
  Canh : Mang100x100;
  Dem_CT : LongInt;
  N, i : Byte;
  TepVao, TepRa : String;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TepVao);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Read(F, Canh[i, j]);
        ReadLn(F);
      End;
    For i := 1 To N Do Canh[i, i] := 0;
    Close(F);
  End;

Procedure Sinh_Du_Lieu;
  Var
    F : Text;
    j, k : Byte;
    i, MaxCanh, SoCanh : Word;
  Begin
    N := 100;
{    Write('Nhap so dinh cua do thi: ');
    ReadLn(N);{}
    Randomize;
    MaxCanh := N*(N-1) Div 2;
    SoCanh := Random(MaxCanh Div 2)+MaxCanh Div 2;
    Repeat
      Write('Nhap so canh cua do thi:');
      ReadLn(SoCanh);
    Until SoCanh <= MaxCanh;{}
    FillChar(Canh, SizeOf(Canh), 1);
    For i := 1 To N Do Bac[i] := N-1;
    i := N*(N-1) Div 2 - SoCanh;
    Repeat
      Dec(i);
      Repeat
        j := Random(N)+1;
        k := Random(N)+1;
      Until (Bac[j] > (N Div 2))And(Bac[k] > (N Div 2))And(j <> k)And(Canh[j, k] = 1);
      Canh[j, k] := 0;
      Canh[k, j] := 0;
      Dec(Bac[j]);
      Dec(Bac[k]);
    Until i = 0;
    Assign(F, TepVao);
    ReWrite(F);
    WriteLn(F, N);
    For i := 1 To N Do Canh[i, i] := 0;
    For i := 1 To N Do
      Begin
        For j := 1 To N-1 Do Write(F, Canh[i, j], ' ');
        WriteLn(F, Canh[i, j]);
      End;
    Close(F);
  End;

Procedure Xuat_Ket_Qua(i : Byte);
  Var
    j : Byte;
  Begin
{    WriteLn('Chu trinh tim duoc:');}
    For j := 1 To N Do Write(Stack[j], ' -> ');
    WriteLn(i);
  End;

Function Tim_Chu_Trinh_HAMILTON(i : Byte) : Boolean;
  Var
    Xet : Mang100;
    Top : Word;
    j, k : Byte;
    Found : Boolean;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    Top := 1;
    Stack[1] := i;
    Xet[i] := 1;
    Found := False;
    Repeat
      i := Stack[Top];
      Repeat
        j := 1;
        While ((Canh[i, j] <> 1)Or(Xet[j] > 0))And(j <= N) Do Inc(j);
        If j <= N Then
          Begin
            {Xoa canh va dinh}
            Xet[j] := 1;
            Canh[i, j] := VoCung;
            Canh[j, i] := VoCung;
            i := j;
            Stack[Top+1] := j;
            Inc(Top);
          End;
      Until j > N;
      {Khoi phuc dinh va cac canh da xoa}
      For j := 1 To N Do
        If (Canh[i, j] = VoCung)And(Xet[j] = 0) Then
          Begin
            Canh[i, j] := 1;
            Canh[j, i] := 1;
          End;
      Xet[i] := 0;
      If (Canh[i, Stack[1]] <> 0)And(Top = N) Then
        Begin
          Found := True;
          Inc(Dem_CT);
{          Xuat_Ket_Qua(Stack[1]);}
        End;
{      Stack[Top] := 0;}
      Dec(Top);  {BackTracking}
    Until {Found Or}(Top <= 0);
    Tim_Chu_Trinh_HAMILTON := Found;
  End;

Begin
  ClrScr;
  TepVao := 'h2.inp';
{  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TepVao);
{  Sinh_Du_Lieu;{}
  Doc_Du_Lieu;{}
  Time := MemL[$0000:$046C];
  If Tim_Chu_Trinh_HAMILTON(1) = False Then
    WriteLn('Khong ton tai chu trinh HAMILTON!');
  WriteLn('So chu trinh tim duoc: ', Dem_CT);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  ReadLn;
End.