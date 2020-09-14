{*--------------------------------------------------------------------------*}
{ Problem:                                                                   }
{   Cho mang may tinh gom N may tinh duoc danh so tu 1..N. Trong do co 1 may }
{ goi la may chu duoc danh so la 1. Co tat ca M kenh truyen tin duoc danh so }
{ tu 1..M. Du lieu ve noi mang duoc cho trong 1 file van ban:                }
{   - Dong dau chua 2 so: N va M                                             }
{   - M dong tiep theo, moi dong chua 2 so D[i] va C[i] la chi so cua kenh   }
{     truyen tin thu i.                                                      }
{   De kiem tra cac kenh truyen tin, nguoi ta gui 1 thong diep toi tat ca    }
{ cac may trong mang. Thong diep nay phai lan luot thong qua cac may trong   }
{ mang va truyen di qua tat ca cac kenh, moi kenh dung 1 lan roi quay ve may }
{ chu.                                                                       }
{   Lap trinh nhap du lieu tu 1 file va cho biet co cach truyen tin nhu vua  }
{ mo ta hay khong? Neu co hay dua ra trinh tu cac kenh trong mang ma thong   }
{ diep duoc truyen qua.                                                      }
{*--------------------------------------------------------------------------*}

Program Mang_May_Tinh;

Uses CRT;

Const
  Max = 100;

Var
  ChuTrinh, Stack : Array[1..Max*Max] Of Byte;
  Kenh : Array[1..Max, 1..Max] Of Byte;
  Xet  : Array[1..Max] Of Byte;
  N, M : Byte;
  Top, DemCanh : Word;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j, k : Byte;
  Begin
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, N, M);
    FillChar(Kenh, SizeOf(Kenh), 0);
    For i := 1 To M Do
      Begin
        ReadLn(F, j, k);
        Inc(Kenh[j, k]);
        Inc(Kenh[k, j]);
      End;
    For i := 1 To N Do Kenh[i, i] := 0;
    Close(F);
  End;

Procedure DFS(i, IDNum : Byte);
  Var
    j : Byte;
  Begin
    FillChar(Stack, SizeOf(Stack), 0);
    Stack[1] := i;
    Top := 1;
    Xet[i] := IDNum;
    Repeat
      j := 1;
      While ((Xet[j] <> 0)Or(Kenh[Stack[Top], j] <> 1))And(j <= N) Do Inc(j);
      If j <= N Then
        Begin
          Xet[j] := IDNum;
          Inc(Top);
          Stack[Top] := j;
        End
       Else Dec(Top);
    Until Top <= 0;
  End;

Function Kiem_Tra : Boolean;
  Var
    i, j, k, Bac, TPLT : Byte;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    TPLT := 0;
    For i := 1 To N Do
      If Xet[i] = 0 Then
        Begin
          Inc(TPLT);
          DFS(i, TPLT);
        End;
    k := 0;
    For i := 1 To N Do
      Begin
        Bac := 0;
        For j := 1 To N Do
          If Kenh[i, j] <> 0 Then Inc(Bac, Kenh[i, j]);
        If Bac Mod 2 <> 0 Then k := 1;
      End;
    Kiem_Tra := (k = 0)And(TPLT = 1);
  End;

Procedure Tim;
  Var
    i, j : Byte;
  Begin
    FillChar(ChuTrinh, SizeOf(ChuTrinh), 0);
    FillChar(Stack, SizeOf(Stack), 0);
    Top := 1;
    DemCanh := 0;
    Stack[Top] := 1;
    Repeat
      i := 1;
      While (Kenh[Stack[Top], i] = 0)And(i <= N) Do Inc(i);
      If i <= N Then
        Begin
          Dec(Kenh[i, Stack[Top]]);
          Dec(Kenh[Stack[Top], i]);
          Inc(Top);
          Stack[Top] := i;
        End
       Else
        Begin
          Inc(DemCanh);
          ChuTrinh[DemCanh] := Stack[Top];
          Dec(Top);
        End;
    Until DemCanh = M;
  End;

Procedure Xuat_KQ;
  Var
    i : Byte;
  Begin
    WriteLn('Ton tai cach truyen tin nhu sau:');
    For i := 1 To DemCanh Do
      Write(ChuTrinh[i], '->');
    WriteLn(ChuTrinh[1]);
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  If Kiem_Tra Then
    Begin
      Tim;
      Xuat_KQ;
    End
   Else WriteLn('Khong ton tai cach truyen tin!');
  ReadLn;
End.