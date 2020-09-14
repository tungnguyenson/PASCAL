{*--------------------------------------------------------------------------*}
{ Problem:                                                                   }
{   Cho bang o vuong gom N*M o,  trong do N la chi so dong,  M la chi so cot }
{ Tai moi o thu (i, j) viet mot so 0 hoac 1 (i = 1..N, j = 1..M).            }
{ Hay viet chuong trinh dem  so mien con toan  0 cua bang va  chi ra mien    }
{ con co dien tich lon nhat.                                                 }
{ Du lieu vao co dang:                                                       }
{ - Dong dau ghi 2 sè N, M cach nhau.                                        }
{ - N dong tiep theo,  moi dong ghi M so 0 hoac  1 cach nhau it nhat mot     }
{   dau trang.                                                               }
{ Ket qua duoc ghi ra man hinh.                                              }
{*--------------------------------------------------------------------------*}

{$M 32768, 0, 0}

Program Mien_Con_0;

Uses CRT;

Type
  ViTri = Record
            y, x : ShortInt;
          End;

Const
  NMax = 100;
  MMax = 100;
  LanCan : Array[1..4] Of ViTri = ((y:-1; x:0), (y:0; x:-1),
                                   (y:0; x:1), (y:1; x:0));

Var
  Xet, A : Array[1..NMax, 1..MMax] Of Byte;
  N, M : Byte;
  TepVao : String;
  SoMienCon, S, SMax : Word;
  i, j, xs, ys : Byte;

Procedure SinhDL(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    WriteLn('Nhap kich thuoc cua mang:');
    Write('  N = ');  ReadLn(N);
    Write('  M = ');  ReadLn(M);
    Assign(F, TenTep);
    ReWrite(F);
    Randomize;
    WriteLn(F, N, ' ', M);
    For i := 1 To N Do
      Begin
        For j := 1 To M Do Write(F, Random(2), ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure DocDL(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N, M);
    For i := 1 To N Do
      For j := 1 To M Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Tim(y, x : Byte; SoMC : Word; Var S : Word);
  Var
    Queue : Array[1..NMax*MMax]  Of ViTri;
    i, j, k : Word;
    Left, Right : Word;
    VT : ViTri;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    Left := 1;
    Right := 1;
    Queue[1].y := y;
    Queue[1].x := x;
    Xet[y, x] := 1;
    Repeat
      For i := 1 To 4 Do
        If (Xet[y+LanCan[i].y, x+LanCan[i].x] = 0)And
           (A[y+LanCan[i].y, x+LanCan[i].x] = 0) Then
          If (y+LanCan[i].y in [1..N])And(x+LanCan[i].x in [1..M]) Then
            Begin
              Xet[y+LanCan[i].y, x+LanCan[i].x] := 1;
              Inc(Right);
              Queue[Right].y := y+LanCan[i].y;
              Queue[Right].x := x+LanCan[i].x;
            End;
      Inc(Left);
      y := Queue[Left].y;
      x := Queue[Left].x;
    Until Left > Right;
    S := Right;
  End;

Begin
  ClrScr;
  Write('Nhap tep du lieu: ');  ReadLn(TepVao);
{  SinhDL(TepVao);{}
  DocDL(TepVao);
  SoMienCon := 0;
  SMax := 0;
  FillChar(Xet, SizeOf(Xet), 0);
  For i := 1 To N Do
    For j := 1 To M Do
      If (Xet[i, j] = 0)And(A[i, j] = 0) Then
        Begin
          Inc(SoMienCon);
          Tim(i, j, SoMienCon, S);
          If SMax < S Then
            Begin
              SMax := S;
              ys := i;
              xs := j;
            End;
        End;
  WriteLn('So mien con toan 0 la: ', SoMienCon);
  WriteLn('Mien con co dien tich lon nhat la: ', SMax);
  ReadLn;
End.