Unit Blocks;

Interface

  Const
    chrBlock = #197#198;

    StdBlock : Array[0..7, 1..4, 1..4] Of Byte = (
               ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)),
               ((1, 0, 0, 0), (1, 0, 0, 0), (1, 1, 0, 0), (0, 0, 0, 0)),
               ((0, 1, 0, 0), (0, 1, 0, 0), (1, 1, 0, 0), (0, 0, 0, 0)),
               ((1, 0, 0, 0), (1, 1, 0, 0), (0, 1, 0, 0), (0, 0, 0, 0)),
               ((0, 1, 0, 0), (1, 1, 0, 0), (1, 0, 0, 0), (0, 0, 0, 0)),
               ((1, 0, 0, 0), (1, 1, 0, 0), (1, 0, 0, 0), (0, 0, 0, 0)),
               ((1, 1, 0, 0), (1, 1, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)),
               ((1, 0, 0, 0), (1, 0, 0, 0), (1, 0, 0, 0), (1, 0, 0, 0)));

  Type
    TBlock = Object
      Left, Top, Height, Width : Byte;
      Color : Byte;
      Grid : Array[1..4, 1..4] Of Byte;
      Mask : Array[1..4] Of Byte;
      Procedure GetBlockSize;
      Procedure Show;
      Procedure Hide;
      Procedure Refresh;
    End;

  Procedure DrawBlock(x, y, Color : Byte);
  Procedure NewBlock(Var Block : TBlock);
  Procedure GenerateBlock(Var Block : TBlock; Style : Byte);
  Procedure RotateBlock(Var Block : TBlock);

Implementation

  Uses Support;

  Procedure DrawBlock;
    Begin
      OutStrAttr(x, y, chrBlock, Color+8, Color);
    End;

  Procedure NewBlock;
    Var
      i : Byte;
    Begin
      With Block Do
        Begin
          FillChar(Grid, SizeOf(Grid), 0);
          FillChar(Mask, SizeOf(Mask), 0);
          Left := 1;
          Top := 1;
          Color := 0;
          GetBlockSize;
        End;
    End;

  Procedure GenerateBlock;
    Var
      i, j : Byte;
    Begin
      For i := 1 To 4 Do
        For j := 1 To 4 Do
          Block.Grid[i, j] := StdBlock[Style, i, j];
      Block.Color := Style;
    End;

  Procedure TBlock.GetBlockSize;
    Var
      i, j : Byte;
    Begin
      Height := 0;
      Width := 0;
      For i := 1 To 4 Do
        For j := 1 To 4 Do
          If Grid[i, j] <> 0 then
            Begin
              If i > Height Then Height := i;
              If j > Width Then Width := j;
            End;
    End;

  Procedure TBlock.Show;
    Var
      i, j : Byte;
    Begin
      GetBlockSize;
      Color := Color Mod 8;
      For i := 1 To Height Do
        For j := 1 To Width Do
          If Grid[i, j] = 0 Then DrawBlock(Left+(j-1)*2, Top+(i-1), 0)
                            Else DrawBlock(Left+(j-1)*2, Top+(i-1), Color);
    End;

  Procedure TBlock.Hide;
    Var
      i, j : Byte;
    Begin
      GetBlockSize;
      For i := 1 To Height Do
        For j := 1 To Width Do
          DrawBlock(Left+(j-1)*2, Top+(i-1), 0);
    End;

  Procedure TBlock.Refresh;
    Begin
      Show;
    End;

  Procedure RotateBlock;
    Var
      Tmp : TBlock;
      i, j : Byte;
    Begin
      With Block Do
        Begin
          GetBlockSize;
          NewBlock(Tmp);
          For i := 1 To Height Do
            For j := 1 To Width Do
              Tmp.Grid[j, Height-i+1] := Grid[i, j];
          Block.Grid := Tmp.Grid;
          { Update position }
          If Width >= Height Then
            Begin
              Left := Left+((Width-Height) Div 2)*2;
              Top := Top-(Width-Height) Div 2;
            End
           Else
            Begin
              Left := Left-((Height-Width) Div 2)*2;
              Top := Top+(Height-Width) Div 2;
            End
        End;
    End;

END.