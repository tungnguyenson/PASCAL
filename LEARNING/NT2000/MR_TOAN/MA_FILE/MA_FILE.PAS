Uses CRT;

Const
  TepVanBan = 'MA_FILE.PAS';
  TepKetQua = 'KETQUA.DAT';
  TepChiSo  = 'INDEX.TXT';
  TepBangMa = 'CODE.DAT';
  MaxSize = 32767;

Var
  BangMa : Array['A'..'Z'] Of Char;
  VB : Array[1..32767] Of Char;
  KTra : Boolean;

Procedure Khoi_Tao_Bang_Ma;
  Var
    F1, F2 : Text;
    i, j : Byte;
    S : String;
  Begin
    KTra := True;
    FillChar(BangMa, SizeOf(BangMa), 0);
    Assign(F1, TepChiSo);
    Reset(F1);
    Assign(F2, TepBangMa);
    Reset(F2);
    ReadLn(F2, S);
    Close(F2);
    For i := 1 To 26 Do
      Begin
        Read(F1, j);
        If BangMa[S[1]] <> #0 Then KTra := False;
        BangMa[S[1]] := Chr(j+64);
        Delete(S, 1, 2);
      End;
    Close(F1);
  End;

Procedure Giai_Ma;
  Var
    FI, FO : File;
    i, NumberRead : Word;
  Begin
    Assign(FI, TepVanBan);
    Reset(FI, 1);
    Assign(FO, TepKetQua);
    Rewrite(FO, 1);
    Repeat
      BlockRead(FI, VB, MaxSize, NumberRead);
      For i := 1 To NumberRead Do
        If VB[i] In ['A'..'Z'] Then VB[i] := BangMa[VB[i]]
         Else If Ord(VB[i]) > 32 Then VB[i] := ' ';
      BlockWrite(FO, VB, NumberRead);
    Until NumberRead = 0;
    Close(FO);
    Close(FI);
  End;

BEGIN
  ClrScr;
  Khoi_Tao_Bang_Ma;
  Giai_Ma;
  WriteLn('Ket qua duoc ghi ra tep ''', TepKetQua, '''');
  If KTra Then WriteLn('Quy tac giai ma la dung dan!')
          Else WriteLn('Quy tac giai ma khong la dung dan!');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.