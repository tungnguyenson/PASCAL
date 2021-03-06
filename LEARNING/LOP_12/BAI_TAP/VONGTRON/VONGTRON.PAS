{$R-}
Uses CRT;

Type
  HinhTron = Record   
    x, y, R : Real;   
  End;
  LabelType = Record
    Value : Word; 
    StepPass : Byte;  
  End;
  Step = (Walk, Jump, Fall);
  TrangThai = (DaXet, ChuaXet);

Const
  Max = 100; 
  VC = 10000;   
  KhoangCach : Array[Walk..Fall] Of Word = (1, 200, VC);

Var     
  HT : Array[1..Max] Of HinhTron;     
  QH : Array[1..Max, 1..Max] Of Step;     
  Labels : Array[1..Max] Of LabelType;      
  Xet : Array[1..Max] Of TrangThai;
  Last : Array[1..Max] Of Byte;
  TenTepDL : String;
  S, T, N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Write('Nhap ten tep chua du lieu: ');
    ReadLn(TenTepDL);{}
    Assign(F, TenTepDL); 
    Reset(F);
    N := 0;
    While Not EOF(F) Do
      Begin
        Inc(N);
        ReadLn(F, HT[N].x, HT[N].y, HT[N].R);
      End;
    Close(F);
  End;

Procedure Tinh_Khoang_Cach;
  Var
    i, j : Byte;
    KC : Real;
  Begin
    FillChar(QH, SizeOf(QH), Fall);
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        Begin
          KC := SQRT((HT[i].x-HT[j].x)*(HT[i].x-HT[j].x)+
                     (HT[i].y-HT[j].y)*(HT[i].y-HT[j].y))-(HT[i].R+HT[j].R);
          If KC = 0.5 Then
            Begin
              i := i;
            End;
          If KC <= 0.5 Then
            Begin
              QH[i, j] := Walk;
              QH[j, i] := Walk;
            End
           Else If (KC > 0.5)And(KC <= 0.8) Then
            Begin
              QH[i, j] := Jump;
              QH[j, i] := Jump;
            End
        End;
  End;

Function DIJLKSTRA(Source, Dest : Byte) : Boolean;
  Var
    i, u : Byte;
    Min : Word;
  Begin
    For i := 1 To N Do
      With Labels[i] Do
        Begin
          Value := VC;
          StepPass := 0;
        End;
    FillChar(Xet, SizeOf(Xet), ChuaXet);
    FillChar(Last, SizeOf(Last), 0);
    Labels[Source].Value := 0;
    Repeat
      Min := VC;
      For i := 1 To N Do 
        If (Labels[i].Value < Min)And(Xet[i] = ChuaXet) Then
          Begin
            Min := Labels[i].Value;
            u := i;
          End;
      Xet[u] := DaXet;
      For i := 1 To N Do
        If (Labels[u].Value+KhoangCach[QH[u, i]] < Labels[i].Value) Or
           ((Labels[u].Value+KhoangCach[QH[u, i]] = Labels[i].Value)And
           (Labels[u].StepPass+1 < Labels[i].StepPass))Then
           Begin
             Labels[i].Value := Labels[u].Value+KhoangCach[QH[u, i]];
             Last[i] := u;
             Labels[i].StepPass := Labels[u].StepPass+1;
           End;
    Until (Min = VC)Or(Xet[Dest] = DaXet);
    If Xet[Dest] = DaXet Then DIJLKSTRA := True
                         Else DIJLKSTRA := False;
  End;

Procedure Xuat_Ket_Qua;
  Var
    u, i, j : Byte;
  Begin
    u := S;
    j := 0;
    Repeat
      Write(u, '->', Last[u]);
      If QH[u, Last[u]] = Jump Then
        Begin
          WriteLn(' Nhay');
          Inc(j);
        End Else WriteLn;
      u := Last[u];
    Until u = T;
    WriteLn('So lan nhay: ', j);
    WriteLn('So duong tron di qua: ', Labels[S].StepPass);
  End; 

Procedure Thuc_Hien;
  Var
    Ch : Char;
  Begin
    Repeat
      ClrScr;
      WriteLn('  1. Doc du lieu');
      WriteLn('  2. Tim duong di');
      WriteLn('  3. Dung chuong trinh');
      Write('Muc duoc chon: ');
      Repeat
        Ch := ReadKey;
      Until Ch In  ['1'..'3'];
      WriteLn(Ch);
      Case Ch Of
        '1' :
          Begin
            Doc_Du_Lieu;
            Tinh_Khoang_Cach;
          End;
        '2' :
          If TenTepDL <> '' Then
            Begin
              Write('  S = ');  ReadLn(S);
              Write('  T = ');  ReadLn(T);
              If DIJLKSTRA(T, S) Then Xuat_Ket_Qua
               Else WriteLn('Khong ton taI duong di!');
              Write('Nhan 1 phim bat ki de tiep tuc ...');
              Readkey;
            End;
      End;
    Until Ch = '3';
  End;

BEGIN	   
  ClrScr;
  TenTepDL := '';
  Thuc_Hien;
END.