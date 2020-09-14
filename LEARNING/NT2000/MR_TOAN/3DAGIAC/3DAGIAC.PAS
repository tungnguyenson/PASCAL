{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  TenTepDL = 'BAI2.IN4';
  MaxPoint = 100;
  SoDaGiac = 3;

Type
  RealPoint = Record
    x, y : Real;
  End;
  RealLine = Record
    x1, y1, x2, y2 : Real;
    A, B, C : Real;
  End;

Var
  DaGiac : Array[1..SoDaGiac+1, 1..(MaxPoint+1)] Of RealPoint;
  DT : Array[1..SoDaGiac+1, 1..(MaxPoint)] Of RealLine;
  SoDiem : Array[1..SoDaGiac+1] Of Word;
  Thuoc : Array[1..MaxPoint*10] Of Word;
  P0, VC_Point : RealPoint;
  SoDCMax : Word;
  DienTich : Real;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, SoDiem[1], SoDiem[2], SoDiem[3]);
    For i := 1 To SoDaGiac Do
      For j := 1 To SoDiem[i] Do
        ReadLn(F, DaGiac[i, j].x, DaGiac[i, j].y);
    Close(F);
  End;

Procedure LapPTDT(Var DT : RealLine);
  Begin
    With DT Do
      Begin
        A := y2-y1;
        B := x1-x2;
        C := x2*y1-x1*y2;
      End;
  End;

Function NamGiua(x, x1, x2 : Real) : Boolean;
  Begin
    If ((x >= x1)And(x <= x2)) Or ((x <= x1)And(x >= x2)) Then
      NamGiua := True
     Else
      NamGiua := False;
  End;

Function CatDoan(L1, L2 : RealLine; Var X, Y : Real) : Boolean;
  Var
    D, DX, DY : Real;
  Begin
    D := L1.A*L2.B-L1.B*L2.A;
    DX := L1.B*L2.C-L1.C*L2.B;
    DY := L1.C*L2.A-L1.A*L2.C;
    CatDoan := True;
    If D <> 0 Then
      Begin
        X := DX/D;
        Y := DY/D;
        If Not (NamGiua(x, L1.x1, L1.x2) And NamGiua(y, L1.y1, L1.y2) And
                NamGiua(x, L2.x1, L2.x2) And NamGiua(y, L2.y1, L2.y2)) Then
             CatDoan := False;
      End
     Else CatDoan := False;
  End;

Function Theta(p1, p2 : RealPoint) : Real;
  Var
    dx, dy, ax, ay, T : Real;
  Begin
    dx := p2.x-p1.x;
    dy := p2.y-p1.y;
    ax := Abs(dx);
    ay := Abs(dy);
    If (dx = 0)And(dy = 0)Then T := 0
                          Else T := dy/(ax+ay);
    If dx < 0 Then T := 2-T
     Else If dy < 0 Then T := 4+T;
    Theta := T*90.0;
  End;

Procedure Sort;
  Var
    i, j : Byte;
    Goc : Array[1..MaxPoint*10] Of Real;
    R : Real;
    PR : RealPoint;
  Begin
    j := 1;
    For i := 1 To SoDiem[SoDaGiac+1] Do
      If DaGiac[SoDaGiac+1, i].y < DaGiac[SoDaGiac+1, i].y Then
        j := i;
    For i := 1 To SoDiem[SoDaGiac+1] Do
      Goc[i] := Theta(DaGiac[SoDaGiac+1, j], DaGiac[SoDaGiac+1, i]);
    For i := 2 To SoDiem[SoDaGiac+1]-1 Do
      For j := i+1 To SoDiem[SoDaGiac+1] Do
        If Goc[i] > Goc[j] Then
          Begin
            R := Goc[i];
            Goc[i] := Goc[j];
            Goc[j] := R;
            PR := DaGiac[SoDaGiac+1, i];
            DaGiac[SoDaGiac+1, i] := DaGiac[SoDaGiac+1, j];
            DaGiac[SoDaGiac+1, j] := PR;
          End;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Word;
  Begin
    For i := 1 To SoDaGiac Do
      DaGiac[i, SoDiem[i]+1] := DaGiac[i, 1];
    VC_Point := DaGiac[1, 1];
    Randomize;
    For i := 1 To SoDaGiac Do
      For j := 1 To SoDiem[i] Do
        Begin
          DT[i, j].x1 := DaGiac[i, j].x;
          DT[i, j].y1 := DaGiac[i, j].y;
          DT[i, j].x2 := DaGiac[i, j+1].x;
          DT[i, j].y2 := DaGiac[i, j+1].y;
          LapPTDT(DT[i, j]);
          If DaGiac[i, j].x > VC_Point.x Then VC_Point.x := DaGiac[i, j].x;
          If DaGiac[i, j].y > VC_Point.y Then VC_Point.y := DaGiac[i, j].y;
          VC_Point.x := VC_Point.x+Random(100)+1;
          VC_Point.y := VC_Point.y+Random(100)+1;
        End;
    SoDCMax := 0;
    For i := 1 To 3 Do
      If SoDCMax < SoDiem[i] Then
        SoDCMax := SoDiem[i]
  End;

Function Diem_Thuoc_Da_Giac(P0 : RealPoint; DG : Byte) : Boolean;
  Var
    L0 : RealLine;
    i, SoDC : Word;
    x, y : Real;
  Begin
    L0.x1 := P0.x;
    L0.y1 := P0.y;
    L0.x2 := VC_Point.x;
    L0.y2 := VC_Point.y;
    LapPTDT(L0);
    SoDC := 0;
    Diem_Thuoc_Da_Giac := False;
    For i := 1 To SoDiem[DG] Do
      If (DT[DG, i].A*P0.X+DT[DG, i].B*P0.Y+DT[DG, i].C = 0) Then
        If NamGiua(P0.x, DT[DG, i].x1, DT[DG, i].x2) And
           NamGiua(P0.y, DT[DG, i].y1, DT[DG, i].y2) Then
          Diem_Thuoc_Da_Giac := True;
    For i := 1 To SoDiem[DG] Do
      If CatDoan(L0, DT[DG, i], x, y) Then
        Begin
          Inc(SoDC);
          If (x = DT[DG, i].x1)And(y = DT[DG, i].y1) Or
             (x = DT[DG, i].x2)And(y = DT[DG, i].y2) Then
               Diem_Thuoc_Da_Giac := True;
        End;
    If SoDC Mod 2 = 1 Then Diem_Thuoc_Da_Giac := True;
  End;

Procedure Diem_Chung_2DG(DG1, DG2 : Byte);
  Var
    DiemChung : Array[1..MaxPoint*10] Of RealPoint;
    i, j, SoDC : Word;
    x, y : Real;
  Begin
    FillChar(DiemChung, SizeOf(DiemChung), 0);
    SoDC := 0;
    For i := 1 To SoDiem[DG1] Do
      If Diem_Thuoc_Da_Giac(DaGiac[DG1, i], DG2) Then
        Begin
          Inc(SoDC);
          DiemChung[SoDC].x := DaGiac[DG1, i].x;
          DiemChung[SoDC].y := DaGiac[DG1, i].y;
        End;
    For i := 1 To SoDiem[DG2] Do
      If Diem_Thuoc_Da_Giac(DaGiac[DG2, i], DG1) Then
        Begin
          Inc(SoDC);
          DiemChung[SoDC].x := DaGiac[DG2, i].x;
          DiemChung[SoDC].y := DaGiac[DG2, i].y;
        End;{}
    For i := 1 To SoDiem[DG1] Do
      For j := 1 To SoDiem[DG2] Do
        If CatDoan(DT[DG1, i], DT[DG2, j], x, y) Then
          Begin
            Inc(SoDC);
            DiemChung[SoDC].x := x;
            DiemChung[SoDC].y := y;
          End;
    For i := 1 To SoDC Do
      DaGiac[SoDaGiac+1, i] := DiemChung[i];
    DaGiac[SoDaGiac+1, SoDC+1] := DiemChung[1];
    SoDiem[SoDaGiac+1] := SoDC;
    Sort;
    For i := 1 To SoDC Do
      Begin
        DT[SoDaGiac+1, i].x1 := DaGiac[SoDaGiac+1, i].x;
        DT[SoDaGiac+1, i].y1 := DaGiac[SoDaGiac+1, i].y;
        DT[SoDaGiac+1, i].x2 := DaGiac[SoDaGiac+1, i+1].x;
        DT[SoDaGiac+1, i].y2 := DaGiac[SoDaGiac+1, i+1].y;
        LapPTDT(DT[SoDaGiac+1, i]);
      End;
  End;

Function DT_Phan_Chung_Da_Giac : Real;
  Var
    DTich : Real;
    i : Word;
  Begin
    DaGiac[SoDaGiac+1] := DaGiac[1];
    SoDiem[SoDaGiac+1] := SoDiem[1];
    DT[SoDaGiac+1] := DT[1];
    Diem_Chung_2DG(2, 4);
    Diem_Chung_2DG(3, 4);
    DTich := 0;
    DaGiac[1] := DaGiac[SoDaGiac+1];
    SoDiem[1] := SoDiem[SoDaGiac+1];
    For i := 1 To SoDiem[1] Do
      DTich := DTich+(DaGiac[1, i+1].x-DaGiac[1, i].x)*(DaGiac[1, i+1].y+DaGiac[1, i].y);
    DT_Phan_Chung_Da_Giac := DTich/2;
  End;

Procedure Phan_1;
  Var
    i, j : Word;
  Begin
    FillChar(Thuoc, SizeOf(Thuoc), 0);
    For j := 1 To SoDiem[1] Do
      For i := 2 To SoDaGiac Do
        If Diem_Thuoc_Da_Giac(DaGiac[1, j], i) Then
          Inc(Thuoc[j]);
  End;

Procedure Xuat_Ket_Qua;
  Var
    i, j : Word;
  Begin
    Write('CAU 1: ');
    j := 0;
    For i := 1 To SoDiem[1] Do
      If Thuoc[i] = SoDaGiac-1 Then
        Inc(j);
    WriteLn(j);
    WriteLn('CAU 2: ', Abs(DT_Phan_Chung_Da_Giac):0:10);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Phan_1;
  Xuat_Ket_Qua;
  ReadLn;
END.