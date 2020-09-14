Program Switching;

Uses CRT;

Const
  InputFile1 : String = 'SWITCH1.INP';
  InputFile2 : String = 'SWITCH2.INP';
  MaxN = 100;
  On  = 1;
  Off = 0;
  Row    = 1;
  Column = 2;

Type
  LightArray = Array[1..MaxN, 1..MaxN] Of Byte;
  ResultArray = Array[1..MaxN*MaxN, 1..2] Of Byte;

Var
  Source, Target, Save : LightArray;
  Result : ResultArray;
  N : Byte;
  SwitchCount : Word;

Procedure Show_Array(A : LightArray);
  Var
    i, j : Byte;
  Begin
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          Write(A[i, j]:3);
        WriteLn;
      End;
{    ReadLn;{}
  End;

Procedure Read_FileName;
  Begin
    Write('Nhap ten tep du lieu 1: ');
    ReadLn(InputFile1);
    Write('Nhap ten tep du lieu 2: ');
    ReadLn(InputFile2);
  End;

Procedure Read_Data;
  Var
    F1, F2 : Text;
    i, j : Byte;
    Ch : Char;
  Begin
    Assign(F1, InputFile1);
    Reset(F1);
    Assign(F2, InputFile2);
    Reset(F2);
    ReadLn(F1, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          Begin
            Read(F1, Ch);
            If Ch = '1' Then Source[i, j] := On
                        Else Source[i, j] := Off;
            Read(F2, Ch);
            If Ch = '1' Then Target[i, j] := On
                        Else Target[i, j] := Off;
          End;
        ReadLn(F1);
        ReadLn(F2);
      End;
    Close(F2);
    Close(F1);
{    Show_Array(Source);{}
{    Show_Array(Target);{}
  End;

Procedure Switch_Row(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To N Do
      If Source[i, j] = On Then Source[i, j] := Off
                           Else Source[i, j] := On;
  End;

Procedure Switch_Column(j : Byte);
  Var
    i : Byte;
  Begin
    For i := 1 To N Do
      If Source[i, j] = On Then Source[i, j] := Off
                           Else Source[i, j] := On;
  End;

Function Switch1 : Boolean;
  Var
    i, j : Byte;
  Begin
    Switch1 := True;
    SwitchCount := 0;
    {Switch Rows}
    For i := 1 To N Do
      If Source[i, 1] <> Target[i, 1] Then
        Begin
          Switch_Row(i);
          Inc(SwitchCount);
          Result[SwitchCount, 1] := Row;
          Result[SwitchCount, 2] := i;
        End;
    {Switch Columns}
    For j := 1 To N Do
      If Source[1, j] <> Target[1, j] Then
        Begin
          Switch_Column(j);
          Inc(SwitchCount);
          Result[SwitchCount, 1] := Column;
          Result[SwitchCount, 2] := j;
        End;
    {Comparison}
    For i := 1 To N Do
      For j := 1 To N Do
        If Source[i, j] <> Target[i, j] Then
          Switch1 := False;
  End;

Function Rand_Switch : Word;
  Var
    j, k, l, m : Byte;
    Count, Max : Word;
    RandomNumber, i : LongInt;
  Begin
    Randomize;{}
    Read_Data;
    RandomNumber := N*N;
    If N <= 20 Then RandomNumber := Sqr(RandomNumber)
               Else RandomNumber := RandomNumber*N;
    Count := 0;
    For i := 1 To N Do
      For j := 1 To N Do
        If Source[i, j] = On Then Inc(Count);
    Max := Count;
    Save := Source;
    For i := 1 To RandomNumber Do
      Begin
        j := Random(2)+1;
        k := Random(N)+1;
        m := 0;
        If j = Row Then
          Begin
            For l := 1 To N Do
              If Source[k, l] = On Then Inc(m);
            Switch_Row(k);
          End
         Else
          Begin
            m := 0;
            For l := 1 To N Do
              If Source[l, k] = On Then Inc(m);
            Switch_Column(k);
          End;
        Count := Count-m+(N-m);
        If Count > Max Then
          Begin
            Max := Count;
            Target := Source;
          End;
      End;
    Source := Save;
{    Show_Array(Source);
    WriteLn(Max);
    Show_Array(Target);{}
    Switch1;
    WriteLn(Max);{}
  End;

Procedure Swicth2;
  Var
    MaxOn : Word;
  Begin
    MaxOn := Rand_Switch;
  End;

Procedure Write_Result;
  Var
    i : Word;
  Begin
    For i := 1 To SwitchCount Do
      Begin
        If Result[i, 1] = Row Then Write('D')
                              Else Write('C');
        Write(Result[i, 2], ' ')
      End;
  End;

Procedure Implement;
  Begin
    If Switch1 = True Then Write_Result
     Else
      Begin
        WriteLn('Khong the');
        Swicth2;
        Write_Result;
      End;
  End;

Procedure Finished;
  Begin
    WriteLn;
    WriteLn;
    Write('Nhan phim Enter de ket thuc ...');
    ReadLn;
  End;

BEGIN
  ClrScr;
  Read_FileName;
  Read_Data;
  Implement;
  Finished;
END.