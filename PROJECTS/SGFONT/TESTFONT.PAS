
Uses Graph, SGFont;

Var
  i : Byte;

Procedure InitGraphMode;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := VGA;
    GraphMode := VGAHi;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Procedure TestVNFont(FontFile : String);
  Begin
    LoadFont(FontFile);
    ClearDevice;
    SetColor(15);
    Rectangle(0, 0, 430, 140);
    For i := 33 To 255 Do
      PrintChar(10+(i Mod 32)*13, (i Div 32-1)*17+10, Chr(i));{}
    SetColor(13);
    PrintStr(130, 160, 'Testing font: '''+FontFile+'''');{}
    SetColor(11);
    PrintStr(100, 180, VNIConv('Coojng hoaf xax hooji chur nghixa Vieejt Nam'));{}
    SetColor(14);
    PrintStr(120, 200, VNIConv('DDoojc laajp - Tuwj do - Hajnh phusc'));{}
    ReadLn;
  End;

Procedure TestFont(FontFile : String);
  Begin
    LoadFont(FontFile);
    ClearDevice;
    SetColor(15);
    Rectangle(0, 0, 430, 140);
    For i := 33 To 255 Do
      PrintChar(10+(i Mod 32)*13, (i Div 32-1)*17+10, Chr(i));{}
    SetColor(13);
    PrintStr(130, 160, 'Testing font: '''+FontFile+'''');{}
    SetColor(11);
    PrintStr(100, 180, 'The Socialist Republic of Viet Nam');{}
    SetColor(14);
    PrintStr(115, 200, 'Independ - Freedom - Happy');{}
    ReadLn;
  End;

BEGIN
  InitGraphMode;
  TestVNFont('sans.fon');
  TestVNFont('vntime.fon');
  TestVNFont('vntimeh.fon');
  TestFont('arial.fon');
  TestFont('swis.fon');
  TestFont('italic.fon');
  TestFont('system.fon');
  TestFont('fixedsys.fon');
  TestFont('serif.fon');
  CloseGraph;
END.