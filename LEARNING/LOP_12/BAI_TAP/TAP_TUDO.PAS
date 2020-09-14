{ Problem:
      Tap E goi la 1 tap tu do neu voi moi x[i], x[j] thuoc E thi ta luon
    co x[i]+x[j] khong thuoc E (i, j = 1..N; i co the bang j).
      Nhap vao tu ban phim 1 so k, hay tim cach chia tap hop N so tu nhien
    lien tiep 1..N thanh k tap tu do voi N lon nhat co the duoc.
    Vi du: - k = 1: ta co tap (1) voi N = 1.
           - k = 2: ta co tap (1, 4) va (3, 2) voi N = 4.
           - k = 3: ta co tap (1, 4, 10, 13)
                              (2, 3, 11, 12)
                              (5, 6, 7, 8, 9)
                    voi N = 13.
}

{ Solution:
  - Ta xay dung cach chia k+1 tu cach chia k:
    + Goi x[1], x[2],.., x[k] la ki hieu tap hop thu 1, 2,..., k trong cach
      chia tap E thanh k tap con, voi E[i] = x[j] la ki hieu phan tu thu i
      cua tap E duoc xep vao tap x[j] (i = 1..N; j = 1..k).
    + Voi E(k) = (i1, i2,..., iN) la cach chia tap 1..N(k) thanh k tap con,
      ta co:
        E(k+1) = (i1, i2,..., iN, iN+1, iN+1,..., iN+1, i1, i2,..., iN)
                  \---- N -----/  \------ N+1 -------/  \---- N -----/
        Gom co N(k+1) = N(k)*3+1 phan tu.
  - Ta co the chung minh duoc N(k+1) la so lon nhat co the duoc va tap
    E(k+1) la ta thoa man yeu cau de bai.
}

Program Tap_Tu_Do;

Uses CRT;

Const
  MaxK = 20;
  BufferSize = 60000;
  TenTepKQ   = 'taptudo.out';
  TempFile1  = 'taptudo.tm1';
  TempFile2  = 'taptudo.tm2';

Var
  Buffer : Array[1..BufferSize] Of Byte;
  k : Byte;
  N : LongInt;

Procedure Init_File;
  Var
    F : Text;
  Begin
    Assign(F, TempFile1);
    ReWrite(F);
    Write(F, '1 ');
    Close(F);
  End;

Procedure Copy_Data(Source, Target : String; CopyType : Byte);
  Var
    FS, FT : File;
    NumberRead, NumberWrite : Word;
    Size : LongInt;
  Begin
    Assign(FS, Source);
    ReSet(FS, 1);
    Assign(FT, Target);
    If CopyType = 0 Then ReWrite(FT, 1)
     Else
      Begin
        ReSet(FT, 1);
        Size := FileSize(FS);
        Seek(FT, FileSize(FT));
      End;
    Repeat
      BlockRead(FS, Buffer, BufferSize, NumberRead);
      BlockWrite(FT, Buffer, NumberRead, NumberWrite);
    Until (NumberRead <> NumberWrite)Or(NumberRead = 0);
    Close(FS);
    Close(FT);
  End;

Procedure Delete_File;
  Var
    F : File;
  Begin
    Assign(F, TempFile1);
    Erase(F);
    Assign(F, TempFile2);
    Erase(F);
  End;

Procedure Large_Data;
  Var
    i, j : LongInt;
    F : Text;
    SoPTTapK : LongInt;
  Begin
    N := 1;
    For i := 1 To k-1 Do
      Begin
        Copy_Data(TempFile1, TempFile2, 0);
        Assign(F, TempFile1);
        Append(F);
        For j := 1 To N+1 Do Write(F, i+1, ' ');
        Close(F);{}
        Copy_Data(TempFile2, TempFile1, 1);
        N := N*3+1;
      End;
  End;

Procedure Xuat_Ket_Qua_1;
  Var
    i : Byte;
    j, Dem : LongInt;
    FI, FO : Text;
  Begin
    Assign(FO, TenTepKQ);
    ReWrite(FO);
    For i := 1 To k Do
      Begin
        WriteLn(FO, i, ':');
        Assign(FI, TempFile1);
        ReSet(FI);
        Dem := 0;
        Repeat
          Read(FI, j);
          Inc(Dem);
          If j = i Then Write(FO, Dem:8);
        Until EOF(FI);
        Close(FI);
        WriteLn(FO);
      End;
    Close(FO);
    WriteLn(' Completed');
    WriteLn('So phan tu: ', N);
    WriteLn('Ket qua duoc ghi ra tep ''', TenTepKQ, '''');
  End;

Procedure Small_Data;
  Var
    i, j : LongInt;
  Begin
    FillChar(Buffer, SizeOf(Buffer), 0);
    N := 1;
    Buffer[1] := 1;
    For i := 1 To k-1 Do
      Begin
        For j := 1 To N Do Buffer[N*2+1+j] := Buffer[j];
        For j := N+1 To N*2+1 Do Buffer[j] := i+1;
        N := N*3+1;
      End;
  End;

Procedure Xuat_Ket_Qua_2;
  Var
    i : Byte;
    j : LongInt;
  Begin
    For i := 1 To k Do
      Begin
        WriteLn(i:2, ': ');
        For j := 1 To N Do
          If Buffer[j] = i Then Write(j:8);
        WriteLn;
        WriteLn;
      End;
    WriteLn;
    WriteLn('So phan tu: ', N);
  End;

Begin
  ClrScr;
  Repeat
    Write('Nhap vao so tap hop: ');
    ReadLn(k);
  Until (k > 0)And(k <= MaxK);
  If k > 10 Then
    Begin
      Init_File;
      Write('Caculating ...');
      Large_Data;
      WriteLn(' Completed');
{      Write('Writing result to file ...');
      Xuat_Ket_Qua_1;
      Delete_File;}
    End
   Else
    Begin
      Small_Data;
      Xuat_Ket_Qua_2;
    End;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.