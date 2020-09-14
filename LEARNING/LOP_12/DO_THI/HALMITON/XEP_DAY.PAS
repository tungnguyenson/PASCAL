{*--------------------------------------------------------------------------*}
{ Problem:                                                                   }
{   Tim cach viet 9 so 1, 9 so 2 va 9 so 3 thanh day A(1)A(2)A(3)...A(N) sao }
{ cho 27 so co 3 chu so: A(1)A(2)A(3), A(2)A(3)A(4),..., A(N-2)A(N-1)AN,     }
{ A(N-1)A(N)A(1), A(N)A(1)A(2) doi mot khac nhau.                            }
{*--------------------------------------------------------------------------*}

Program Xep_Thanh_Day;

Uses CRT;

Const
  N = 3;

Var
  Xep : Array[-1..N*N*N] Of Byte;
  Canh : Array[0..N, 0..N, 0..N] Of Byte;
  SoLuong : Array[1..N] Of Byte;
  Top : Byte;
  Found : Boolean;

Procedure Initializes;
  Var
    i : Byte;
  Begin
    FillChar(Xep, SizeOf(Xep), 0);
    FillChar(Canh, SizeOf(Canh), 0);
    For i := 1 To N Do SoLuong[i] := 6;
  End;

Procedure Sorting;
  Var
    i, j : Byte;
  Begin
    Top := 1;
    Xep[Top] := 0;
    Found := False;
    Repeat
      Inc(Xep[Top]);
      While ((Canh[Xep[Top-2], Xep[Top-1], Xep[Top]] <> 0 )
            Or (SoLuong[Xep[Top]] = 0)) And (Xep[Top] <= N) Do Inc(Xep[Top]);
      If Xep[Top] <= N Then
        Begin
          Canh[Xep[Top-2], Xep[Top-1], Xep[Top]] := 1;
          Dec(SoLuong[Xep[Top]]);
          Inc(Top);
          Xep[Top] := 0;
        End
       Else
        Begin
          If (Top > 27)Or((SoLuong[1] = 0)And(SoLuong[2] = 0)And(SoLuong[3] = 0)) Then
            Begin
              Found := True;
              If Top > 27 Then
                Begin
                  For i := 1 To Top-1 Do Write(Xep[i],' ');
                  WriteLn;
                End
               Else WriteLn('Khong tim duoc cach xep nao!');
            End;
          Xep[Top] := 0;
          Dec(Top);
          Canh[Xep[Top-2], Xep[Top-1], Xep[Top]] := 0;
          Inc(SoLuong[Xep[Top]]);
        End;
    Until (Top <= 0) Or Found;
  End;

Begin
  ClrScr;
  Initializes;
  Sorting;
  If Not Found Then WriteLn('Khong tim duoc cach xep nao!');
  Write('Nhan Enter de ket thuc!');
  ReadLn;
End.