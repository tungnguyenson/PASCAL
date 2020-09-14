Uses CRT, Graph;

Const
  TenTepTest = 'ROINHAU.OUT';
  Max = 100;

Type
  HinhChuNhat = Record
    x1, y1, x2, y2 : Integer;
  End;

Var
  HCN : Array[0..Max] Of HinhChuNhat;
  TT : Array[1..Max] Of Byte;
  F : Text;
  K : Byte;

Function Roi_Nhau(H1, H2 : HinhChuNhat) : Boolean;
  Begin
    Roi_Nhau := False;
    If (H1.X1 > H2.X2) Or (H1.X2 < H2.X1) Or
       (H1.Y1 > H2.Y2) Or (H1.Y2 < H2.Y1) Then Roi_Nhau := True;
  End;

Procedure ReadFile;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepTest);
    Reset(F);
    ReadLn(F, K);
    For i := 1 To K Do
      With HCN[i] Do
        ReadLn(F, TT[i], x1, y1, x2, y2);
    Close(F);
  End;

Procedure Test;
  Var
    i, j : Byte;
  Begin
    WriteLn(K);
    For i := 1 To K-1 Do
      For j := i+1 To K Do
        If Roi_Nhau(HCN[i], HCN[j]) = False Then
          Begin
            WriteLn('Error: ', TT[i], ',', TT[j]);
            ReadLn;
            Exit;
          End;
    WriteLn('OK!');
    ReadLn;
  End;

Procedure BieuDien;
  Var
    GD, GM, i : Integer;
  Begin
    GD := Detect;
    InitGraph(GD, GM, 'C:\TP\BGI');
    For i := 1 To K Do
      With HCN[i] Do
        Rectangle(x1, y1, x2, y2);
    ReadLn;
    CloseGraph;
  End;

BEGIN
  ClrScr;
  ReadFile;
  Test;
  BieuDien;
END.