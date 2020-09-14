Program Bai_Lam_1;

Uses CRT;

Const
  TenTepDL = 'PT.INP';
  TenTepKQ = 'PT.OUT';
  MaxPT     = 100;
  MotNghiem   = 1.7e36;
  VoNghiem    = 1.7e37;
  VoSoNghiem  = 1.7e38;

Type
  PhuongTrinh = Record
    A, B, C : Real;
  End;

Var
  PT : Array[1..MaxPT] Of PhuongTrinh;
  KQ : Array[1..MaxPT, 1..2] Of Real;
  N : Byte;
  F : Text;

Procedure Doc_Du_Lieu;
  Var
    i : Byte;
    Test : Real;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, Test);
    If (Test <= 0)Or(Test > 100)Or(Frac(Test) <> 0) Then
      Begin
        WriteLn('Du lieu khong hop le!');
        Halt(0);
      End;
    N := Round(Test);
    For i := 1 To N Do
      Begin
        ReadLn(F, PT[i].A, PT[i].B, PT[i].C);
        PT[i].C := -PT[i].C;
      End;
    Close(F);
  End;

Procedure Giai_Phuong_Trinh;
  Var
    i : Byte;
    Delta : Real;
  Begin
    For i := 1 To N Do
      With PT[i] Do
        If (A = 0)And(B = 0)And(C = 0) Then KQ[i, 1] := VoSoNghiem
         Else If (A = 0)And(B = 0)And(C <> 0) Then KQ[i, 1] := VoNghiem
         Else If (A = 0)And(B <> 0) Then
           Begin
             KQ[i, 1] := MotNghiem;
             KQ[i, 2] := -C/B;
           End
         Else If A <> 0 Then
           Begin
             Delta := (B*B)-(4*A*C);
             If Delta < 0 Then KQ[i, 1] := VoNghiem
              Else If Delta = 0 Then
                Begin
                  KQ[i, 1] := MotNghiem;
                  KQ[i, 2] := -B/(2*A);
                End
              Else If Delta > 0 Then
                Begin
                  KQ[i, 1] := (-B+SQRT(Delta))/(2*A);
                  KQ[i, 2] := (-B-SQRT(Delta))/(2*A);
                End;
           End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do
      Begin
        If KQ[i, 1] = VoNghiem Then WriteLn(F, 'VO NGHIEM')
         Else If KQ[i, 1] = VoSoNghiem Then WriteLn(F)
         Else If KQ[i, 1] = MotNghiem Then WriteLn(F, KQ[i, 2]:10:2)
         Else
          Begin
            WriteLn(F, KQ[i, 1]:10:2, KQ[i, 2]:10:2);
          End;
      End;
    Close(F);
  End;

Begin
  Doc_Du_Lieu;
  Giai_Phuong_Trinh;
  Ghi_Ket_Qua;
End.