{*--------------------------------------------------------------------------*}
{ Problem:                                                                   }
{   Ban do giao thong duoc cho boi N nut giao thong tu 1 -> N. He thong gom  }
{ M doan duong noi A[1] -> A[M], moi doan noi 2 trong N nut. Ban ®o la lien  }
{ thong don neu 2 nut bat ki co dung 1 duong di noi chung.                   }
{ Du lieu cho trong File van ban GT.DAT                                      }
{   - Dong dau chua cac nut N va M                                           }
{   - Moi dong i trong so M dong tiep theo chua  so hieu 2 nut duoc noi boi  }
{     doan A[i].                                                             }
{ Lap chuong trinh xem ban do co lien thong khong?                           }
{ Neu khong hay bo sung va loai bo 1 so doan  duong de ban do la lien thong  }
{ va so doan duong xay dung, bo sung la it nhat.                             }
{ Ket qua in ra man hinh.                                                    }
{*--------------------------------------------------------------------------*}

Program Ban_Do_Giao_Thong;

Uses CRT;

Const
  NMax = 100;

Var
  Dinh : Array[1..NMax] Of Byte;
  Canh : Array[1..NMax, 1..NMax] Of Byte;
  Queue : Array[1..NMax*NMax] Of Byte;
  N, i : Byte;
  M, SoLT : Word;

Procedure Khoi_Tao;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    FillChar(Dinh, SizeOf(Dinh), 0);
    SoLT := 0;
  End;

Procedure DocDL(TenTep : String);
  Var
    F : Text;
    i, j, k : Word;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N, M);
    For i := 1 To M Do
      Begin
        ReadLn(F, j, k);
        Canh[j, k] := 1;
        Canh[k, j] := 1;
      End;
    Close(F);
  End;

Function Breath_First_Search(i : Byte) : Word;
  Var
    j : Byte;
    Left, Right, DemSoDinh : Word;
  Begin
    Inc(SoLT);
    Dinh[i] := SoLT;
    Queue[1] := i;
    Left := 1;
    Right := 1;
    DemSoDinh := 1;
    While Left <= Right Do
      Begin
        For j := 1 To N Do
          If (Dinh[j] = 0)And(Canh[i, j] = 1) Then
            Begin
              Inc(Right);
              Queue[Right] := j;
              Dinh[j] := SoLT;
              Inc(DemSoDinh);
            End;
        Inc(Left);
        i := Queue[Left];
      End;
  End;

Function Lien_Thong(i, j : Byte) : Boolean;
  Begin
    Khoi_Tao;
    Breath_First_Search(i);
    Lien_Thong := Dinh[j] = 1;
  End;

Function La_Lien_Thong_Don : Boolean;
  Var
    i : Byte;
  Begin
    {Do thi la lien thong don neu no lien thong va
     la 1 cay(so canh = so dinh-1)}
    Khoi_Tao;
    For i := 1 To N Do
      If Dinh[i] = 0 Then Breath_First_Search(i);
    If (SoLT = 1)And(M = N-1)Then La_Lien_Thong_Don := True
                             Else La_Lien_Thong_Don := False;
  End;

Procedure Loai_Bo_1;
  Var
    i, j : Byte;
  Begin
    {Xoa bo cac canh khong can thiet}
    WriteLn('Cac canh bi loai bo:');
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Canh[i, j] = 1 Then
          Begin
            {Kiem tra xem canh co phai la cau hay khong?}
            Canh[i, j] := 0;
            Canh[j, i] := 0;
            If Lien_Thong(i, j) = False Then
              Begin
                {Khoi phuc lai canh vua xoa}
                Canh[i, j] := 1;
                Canh[j, i] := 1;
              End
             Else
              WriteLn('(', i, ',', j, ')');
          End;
  End;

Procedure Bo_Sung;
  Var
    Xet : Array[1..NMax] Of Byte;
    i, j : Byte;
  Begin
    {Bo sung them cac canh}
    WriteLn('Cac canh duoc bo sung:');
    Khoi_Tao;
    For i := 1 To N Do
      If Dinh[i] = 0 Then Breath_First_Search(i);
    FillChar(Xet, SizeOf(Xet), 0);
    For i := 1 To N-1 Do
      If Xet[Dinh[i]] = 0 Then
        For j := i+1 To N Do
          If Dinh[j] <> Dinh[i] Then
            {Kiem tra xem canh co the la cau hay khong?}
            If Lien_Thong(i, j) = False Then 
              Begin
                Xet[Dinh[i]] := 1;
                Canh[i, j] := 1;
                Canh[j, i] := 1;
                WriteLn('(', i, ',', j, ')');
              End;
  End;

Procedure Loai_Bo_2;
  Begin
    {Phuong phap:
       - Tim 1 chu trinh con(don)
       - Loai bo canh dau tien va canh cuoi cung
    }
  End;

{---------------------------------------------}
Begin
  ClrScr;
  DocDL('lthdon2.inp');
  WriteLn('So dinh: ', N);
  WriteLn('So canh: ', M);
  If La_Lien_Thong_Don = False Then
    Begin
      WriteLn('Ban do khong phai la lien thong don!');
      Loai_Bo_1;
      Bo_Sung;
    End
   Else
    WriteLn('Ban do la lien thong don!');
  ReadLn;
End.