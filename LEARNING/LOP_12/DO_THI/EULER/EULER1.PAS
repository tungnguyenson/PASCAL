Program Chu_Trinh_EULER;

Uses CRT;

Const
  Max = 100;

Var
  Dinh : Array[1..Max] Of Byte;
  Canh : Array[1..Max, 1..Max] Of Byte;
  Queue, ChuTrinh : Array[1..Max*Max] Of Byte;
  N, i : Byte;
  SoTT : Word;
  TepVao, TepRa : String;

Procedure Khoi_Tao;
  Begin
    FillChar(Queue, SizeOf(Queue), 0);
    FillChar(Dinh, SizeOf(Dinh), 0);
    SoTT := 0;
  End;

Procedure DocDL(TenTep : String);
  Var
    F : Text;
    i, j, k : Word;
  Begin
    Assign(F, TenTep);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Read(F, Canh[i, j]);
        ReadLn(F);
      End;
    Close(F);
  End;

Function Tim_Chu_Trinh_Con(i : Byte) : Word;
  Var
    j, bd : Byte;
    Left, Right : Word;
    Stop : Boolean;
  Begin
    Inc(SoTT);
    Dinh[i] := SoTT;
    Queue[1] := i;
    bd := i;
    Left := 0;
    Right := 0;
    Stop := False;
    While (Left <= Right)And(Stop = False)  Do
      Begin
        Inc(Left);
        i := Queue[Left];
        For j := 1 To N Do
          If (Dinh[j] = 0)And(Canh[i, j] = 1) Then
            Begin
              Canh[i, j] := 0;
              Canh[j, i] := 0;
              Inc(Right);
              Queue[Right] := j;
              Dinh[j] := SoTT;
              If Canh[bd, j] = 1 Then
                Begin
                  Stop := True;
                  Break;
                End;
            End;
      End;
  End;

{---------------------------------------------}
Begin
  ClrScr;
  Write('Nhap ten tep chua du lieu: ');
  ReadLn(TepVao);
  DocDL(TepVao);
  ReadLn;
End.