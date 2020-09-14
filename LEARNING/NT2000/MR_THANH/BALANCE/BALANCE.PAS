{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepDL = 'CAN.INP';
  TenTepKQ = 'CAN.OUT';
  MaxN = 100;

Var
  KL : Array[1..MaxN] Of Word;
  CS : Array[1..MaxN] Of Word;
  DaXet : Array[1..MaxN] Of Byte;
  Can, KQ_Can : Array[1..MaxN] Of ShortInt;
  MinTong, CountLeft, CountRight, TongKL, KLBanDau : LongInt;
  N, SLCan, SoQKL, SoQKR : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do Read(F, KL[i]);
    Close(F);
  End;

Procedure Tim(Tong : LongInt; i : Byte);
  Var
    j : ShortInt;
  Begin
    For j := -1 To 1 Do
      Begin
        Can[i] := j;
        Tong := Tong-KL[i]*j;
        If (i < N)And(MinTong <> 0) Then Tim(Tong, i+1)
         Else If (i = N)And(Abs(Tong) < Abs(MinTong)) Then
          Begin
            MinTong := Tong;
            KQ_Can := Can;
          End;
        Tong := Tong+KL[i]*j;
      End;
  End;

Function Kiem_Tra : Char;
  Var
    i, j, T1, T2 : Byte;
    Ch : Char;
  Begin
    CountLeft := 0;
    CountRight := 0;
    SoQKL := 0;
    SoQKR := 0;
    For i := 1 To N Do
      If KQ_Can[i] = -1 Then
        Begin
          CountLeft := CountLeft+KL[i];
          Inc(SoQKL);
        End
       Else If KQ_Can[i] = 1 Then
        Begin
          CountRight := CountRight+KL[i];
          Inc(SoQKR);
        End;
    WriteLn('Trong luong cac qua can dat tren dia co vat: ', CountLeft);
    WriteLn('Trong luong cac qua can dat tren dia khong co vat: ', CountRight);
    Write('Trang thai can: ');
    Repeat
      Ch := ReadKey;
    Until Ch In ['>', '<', '='];
    WriteLn(Ch);
    Kiem_Tra := Ch;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
    Left, Right, Mid : LongInt;
    KQ_KTra : Char;
    F : Text;
    Stop : Boolean;
  Begin
    Assign(F, 'CAN.TMP');
    Rewrite(F);
    SLCan := 0;
    TongKL := 0;
    For i := 1 To N Do
      TongKL := TongKL+KL[i];
    Left := 1;
    Right := TongKL;
    Stop := False;
    Repeat
      Inc(SLCan);
      Mid := (Left+Right) Div 2;
      If (Left+2 = Right)And(Right = TongKL) Then Mid := TongKL;
      Repeat
        MinTong := Mid;
        Tim(Mid, 1);
        If MinTong <> 0 Then Inc(Mid);
      Until (MinTong = 0)Or(Mid >= Right);
      If MinTong = 0 Then
        Begin
          KQ_KTra := Kiem_Tra;
          If KQ_KTra = '>' Then Left := Mid
           Else If KQ_KTra = '<' Then Right := Mid;
          If (Mid = TongKL)And(KQ_KTra = '<') Then
            Begin
              Mid := TongKL-1;
              Stop := True;
            End;
          Write(F, SoQKL);
          For i := 1 To N Do
            If KQ_Can[i] = -1 Then Write(F, ' ', i);
          WriteLn(F);
          Write(F, SoQKR);
          For i := 1 To N Do
            If KQ_Can[i] = 1 Then Write(F, ' ', i);
          WriteLn(F);
          WriteLn(F, KQ_KTra);
        End;
      If ((Left+2 = Right)And(Right < TongKL))Or(KQ_KTra = '=')Or(MinTong <> 0) Then
        Stop := True;
    Until Stop;
    KLBanDau := -1;
    If MinTong = 0 Then
      If KQ_KTra = '=' Then KLBanDau := Mid
                       Else KLBanDau := Left+1;
    If KLBanDau <> -1 Then
      Begin
        WriteLn('Trong luong cua vat la ', KLBanDau);
        WriteLn(F, KLBanDau);
      End;
    Close(F);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F1, F2 : Text;
    S : String;
    i, j, k, l : Word;
  Begin
    Assign(F1, 'CAN.TMP');
    Reset(F1);
    Assign(F2, TenTepKQ);
    Rewrite(F2);
    If KLBanDau = -1 Then WriteLn(F2, -1)
     Else
      Begin
        WriteLn(F2, SLCan);
        For l := 1 To SLCan Do
          Begin
            Read(F1, i);
            Write(F2, i);
            For j := 1 To i Do
              Begin
                Read(F1, k);
                Write(F2, ' ', k);
              End;
            WriteLn(F2);
            Read(F1, i);
            Write(F2, i);
            For j := 1 To i Do
              Begin
                Read(F1, k);
                Write(F2, ' ', k);
              End;
            WriteLn(F2);
            ReadLn(F1);
            ReadLn(F1, S);
            WriteLn(F2, S);
          End;
      End;
    ReadLn(F1, S);
    WriteLn(F2, S);
    Close(F2);
    Close(F1);
    Assign(F1, 'CAN.TMP');
    Erase(F1);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.