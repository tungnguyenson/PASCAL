{*--------------------------------------------------------------------------*}
{ Problem: Xep phong                                                        }
{   Co N nguoi khach (N <= 100) mang so hieu tu 1 den N, duoc moi den du mot }
{ hoi nghi. Giua ho co 1 so nguoi quen biet nhau. Du lieu ve quan he nay     }
{ duoc cho boi File van ban KHACH.DAT.                                       }
{   - Dong dau ghi so luong khach moi                                        }
{   - Dong thu i trong N dong tiep theo chua so hieu cua nguoi quen khach i  }
{ Cac so hieu duoc ghi cach nhau boi 1 dau cach.                             }
{ Nguoi ta muon xep cac khach nay vao cac phong hop sao cho 2 khach cung     }
{ phong hoac la quen biet nhau truc tiep, hoac la quen biet nhau thong qua   }
{ nhung nguoi quen cua ho.                                                   }
{ Viet chuong trinh nhap du lieu tu file van ban. Tim cach phan khach vao    }
{ cac phong sao cho so phong la it nhat. Ket qua dua vao file van ban:       }
{   - Dong dau chua so phong can su dung K                                   }
{   - Dong i trong so K phong ghi so hieu khach xep vao phong i.             }
{*--------------------------------------------------------------------------*}

Program Xep_Phong;

Uses CRT;

Const
  Max = 100;

Var
  Quen : Array[1..Max, 0..Max] Of Byte;
  N, SoPhong, i : Word;
  Queue : Array[1..Max*Max] Of Byte;
  Xet : Array[1..Max] Of Byte;
  TepVao, TepRa : String;

Procedure Sinh_Du_Lieu(Ten_Tep : String);
  Var
    i, j : Byte;
    F : Text;
  Begin
    Repeat
      Write('Nhap vao so nguoi khach: ');
      ReadLn(N);
      If N > Max Then WriteLn('Error! N <= ', Max);
    Until N <= Max;
    Randomize;
    FillChar(Quen, SizeOf(Quen), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        If Random(2) = 1 Then
          Begin
            Quen[i, j] := 1;
            Quen[j, i] := 1;
          End;
    Assign(F, Ten_Tep);
    ReWrite(F);
    WriteLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          If (Quen[i, j] = 1)And(i <> j) Then
            Begin
              Quen[i, j] := 0;
              Write(F, j, ' ');
            End;
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
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        j := 0;
        While Not EOLn(F) Do
          Begin
            Inc(j);
            Read(F, Quen[i, j]);
          End;
        Quen[i, 0] := j;
        ReadLn(F);
      End;
    Close(F);
  End;

Procedure Tim(i : Byte);
  Var
    j, k : Byte;
    Left, Right : Word;
  Begin
    Inc(SoPhong);
    Xet[i] := SoPhong;
    Queue[1] := i;
    Left := 1;
    Right := 1;
    While Left <= Right Do
      Begin
        For j := 1 To Quen[i, 0] Do
          If Xet[Quen[i, j]] = 0 Then
            Begin
              Inc(Right);
              Queue[Right] := Quen[i, j];
              Xet[Quen[i, j]] := SoPhong;
            End;
        Inc(Left);
        i := Queue[Left];
      End;
  End;

Procedure XuatKQ(TenTep : String);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTep);
    ReWrite(F);
    WriteLn(F, SoPhong);
    For i := 1 To SoPhong Do
      Begin
        For j := 1 To N Do
          If Xet[j] = i Then Write(F, j, ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Begin
  ClrScr;
  Write('Nhap ten tep du lieu: ');  ReadLn(TepVao);
  Sinh_Du_Lieu(TepVao);
{  Write('Nhap ten tep ket qua: ');  ReadLn(TepRa);
  DocDL(TepVao);
  FillChar(Xet, SizeOf(Xet), 0);
  SoPhong := 0;
  For i := 1 To N Do
    If Xet[i] = 0 Then Tim(i);
  XuatKQ(TepRa);}
End.