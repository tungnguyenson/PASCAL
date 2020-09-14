{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}

Uses CRT;

Const
  TenTepDL = 'BL2.INP';
  TenTepKQ = 'BL2.OUT';
  TenTepTmp = 'BL2.TMP';
  MaxMN = 50;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Var
  Xet, ChuaXet, MC : Array[0..MaxMN+1, 0..MaxMN+1] Of Shortint;
  Nhan, KC : Array[0..MaxMN+1, 0..MaxMN+1] Of Word;
  Queue, Luu, DD : Array[1..MaxMN*MaxMN, 1..2] Of Byte;
  Truoc : Array[1..MaxMN, 1..MaxMN, 1..2] Of Byte;
  SoDong, SoCot, U, V, S, T : Byte;
  Top, ChiPhi, LeftQ, RightQ : Word;
  Found : Boolean;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, SoDong, SoCot);
    ReadLn(F, U, V);
    ReadLn(F, S, T);
    For i := 1 To SoDong Do
      For j := 1 To SoCot Do
        Read(F, MC[i, j]);
    Close(F);
{    For i := 1 To SoDong Do
      Begin
        For j := 1 To SoCot Do Write(MC[i, j]:3);
        WriteLn;
      End;{}
  End;

Function Tim_Thay_Bien(y, x : ShortInt) : Boolean;
  Var
    j, k, l : Byte;
    Found : Boolean;
  Begin
    FillChar(ChuaXet, SizeOf(ChuaXet), 1);
    LeftQ := 1;
    RightQ := 1;
    Queue[LeftQ, 1] := y;
    Queue[LeftQ, 2] := x;
    ChuaXet[y, x] := 0;
    Found := False;
    While (LeftQ <= RightQ)And(Not Found) Do
      Begin
        For j := 1 To 4 Do
          If Not Found Then
            Begin
              k := y+Next[j, 1];
              l := x+Next[j, 2];
              If (ChuaXet[k, l] = 1)And(MC[k, l] = 0) Then
                Begin
                  Truoc[k, l, 1] := y;
                  Truoc[k, l, 2] := x;
                  Inc(RightQ);
                  Queue[RightQ, 1] := k;
                  Queue[RightQ, 2] := l;
                  ChuaXet[k, l] := 0;
                  If (k < 1)Or(k > SoDong)Or(l < 1)Or(l > SoCot) Then
                    Found := True;
                End;
            End;
        If Not Found Then
          Begin
            Inc(LeftQ);
            y := Queue[LeftQ, 1];
            x := Queue[LeftQ, 2];
          End;
      End;
    Tim_Thay_Bien := Found;
  End;

Function Tim_O_Nang_Luong(y, x : ShortInt) : Boolean;
  Var
    j, k, l : Byte;
    Found : Boolean;
  Begin
    FillChar(ChuaXet, SizeOf(ChuaXet), 1);
    LeftQ := 1;
    RightQ := 1;
    Queue[LeftQ, 1] := y;
    Queue[LeftQ, 2] := x;
    ChuaXet[y, x] := 0;
    Found := False;
    While (LeftQ <= RightQ)And(Not Found) Do
      Begin
        For j := 1 To 4 Do
          If Not Found Then
            Begin
              k := y+Next[j, 1];
              l := x+Next[j, 2];
              If (k >= 1)And(k <= SoDong)And(l >= 1)And(l <= SoCot) Then
                If (ChuaXet[k, l] = 1)And(MC[k, l] = 0) Then
                  Begin
                    Truoc[k, l, 1] := y;
                    Truoc[k, l, 2] := x;
                    Inc(RightQ);
                    Queue[RightQ, 1] := k;
                    Queue[RightQ, 2] := l;
                    ChuaXet[k, l] := 0;
                    If (k = S)And(l = T) Then Found := True;
                  End;
            End;
        If Not Found Then
          Begin
            Inc(LeftQ);
            y := Queue[LeftQ, 1];
            x := Queue[LeftQ, 2];
          End;
      End;
    Tim_O_Nang_Luong := Found;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    FillChar(MC, SizeOf(MC), 0);
    FillChar(ChuaXet, SizeOf(ChuaXet), 1);
    FillChar(Queue, SizeOf(Queue), 0);
    Found := False;
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, l, d, ys, xs : Word;
    MinNhan : Word;
  Begin
    If Tim_Thay_Bien(U, V) Then
      Begin
        ys := Queue[RightQ, 1];
        xs := Queue[RightQ, 2];
        i := 0;
        Repeat
          Inc(i);
          DD[i, 1] := ys;
          DD[i, 2] := xs;
          ys := Truoc[DD[i, 1], DD[i, 2], 1];
          xs := Truoc[DD[i, 1], DD[i, 2], 2];
        Until (ys = 0)Or(xs = 0);
        For j := 1 To i-1 Do Luu[j] := DD[i-j+1];
        Top := i-1;
        Found := True;
      End
     Else If Tim_O_Nang_Luong(U, V) Then
      Begin
        ys := Queue[RightQ, 1];
        xs := Queue[RightQ, 2];
        i := 0;
        Repeat
          Inc(i);
          DD[i, 1] := ys;
          DD[i, 2] := xs;
          ys := Truoc[DD[i, 1], DD[i, 2], 1];
          xs := Truoc[DD[i, 1], DD[i, 2], 2];
        Until (ys = 0)Or(xs = 0);
        For j := 1 To i Do Luu[j] := DD[i-j+1];
        Top := i;
        FillChar(Truoc, SizeOf(Truoc), 0);
        FillChar(Nhan, SizeOf(Nhan), $FF);
        FillChar(Xet, SizeOf(Xet), 0);
        FillChar(KC, SizeOf(KC), 0);
        Nhan[S, T] := 0;
        Repeat
          MinNhan := $FFFF;
          For i := 1 To SoDong Do
            For j := 1 To SoCot Do
              If (MinNhan > Nhan[i, j])And(Xet[i, j] = 0) Then
                Begin
                  MinNhan := Nhan[i, j];
                  ys := i;
                  xs := j;
                End;
          If MinNhan <> $FFFF Then
            Begin
              Xet[ys, xs] := 1;
              For i := 1 To 4 Do
                If (MC[ys+Next[i, 1], xs+Next[i, 2]] <> -1)And
                   (Xet[ys+Next[i, 1], xs+Next[i, 2]] = 0) Then
                  Begin
                    k := ys+Next[i, 1];
                    l := xs+Next[i, 2];
                    If MC[k, l] = 1 Then d := (KC[ys, xs]+1)*2+1
                                    Else d := 1;
                    If Nhan[ys, xs]+d < Nhan[k, l] Then
                      Begin
                        Nhan[k, l] := Nhan[ys, xs]+d;
                        Truoc[k, l, 1] := ys;
                        Truoc[k, l, 2] := xs;
                        KC[k, l] := KC[ys, xs]+1;
                      End;
                  End;
            End;
        Until MinNhan = $FFFF;
        MinNhan := $FFFF;
        For i := 1 To SoDong Do
          For j := 1 To SoCot Do
            If (i = 1)Or(i = SoDong)Or(j = 1)Or(j = SoCot) Then
              If MinNhan > Nhan[i, j] Then
                Begin
                  MinNhan := Nhan[i, j];
                  ys := i;
                  xs := j;
                End;
        If MinNhan <> $FFFF Then
          Begin
            Found := True;
            i := 0;
            Repeat
              Inc(i);
              DD[i, 1] := ys;
              DD[i, 2] := xs;
              ys := Truoc[DD[i, 1], DD[i, 2], 1];
              xs := Truoc[DD[i, 1], DD[i, 2], 2];
            Until (ys = 0)Or(xs = 0);
            For j := 2 To i Do
              Luu[Top+j-1] := DD[i-j+1];
            Top := Top+i-1;
          End;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F, FTmp : Text;
    i, j, k, y, x, SoCua, SoDC : Word;
  Begin
    Assign(FTmp, TenTepTmp);
    Rewrite(FTmp);
    If Not Found Then WriteLn(FTmp, 0)
     Else
      Begin
        SoCua := 0;
        SoDC := 0;
        For i := 1 To Top Do
          If MC[Luu[i, 1], Luu[i, 2]] = 1 Then Inc(SoCua);
        For i := 1 To Top Do
          Begin
            y := Luu[i, 1];
            x := Luu[i, 2];
            WriteLn(FTmp, y, ' ', x);
            Inc(SoDC);
            If (MC[y, x] = 1)And(SoCua > 1) Then
              Begin
                Dec(SoCua);
                j := i;
                While (j >= 1)And((Luu[j, 1] <> S)Or(Luu[j, 2] <> T)) Do
                  Begin
                    Dec(j);
                    WriteLn(FTmp, Luu[j, 1], ' ', Luu[j, 2]);
                    Inc(SoDC);
                  End;
                While (j <= Top)And(j <> i) Do
                  Begin
                    Inc(j);
                    WriteLn(FTmp, Luu[j, 1], ' ', Luu[j, 2]);
                    Inc(SoDC);
                  End;
              End;
          End;
      End;
    Close(FTmp);
    Assign(F, TenTepKQ);
    Rewrite(F);
    Reset(FTmp);
    WriteLn(F, SoDC);
    While Not EOF(FTmp) Do
      Begin
        ReadLn(FTmp, i, j);
        WriteLn(F, i, ' ', j);
      End;
    Close(FTmp);
    Close(F);
  End;

BEGIN
  ClrScr;
  Khoi_Tao;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.