Uses CRT, Graph, spGraph;

Const
  CardHeight = 96;
  CardWidth  = 71;

  FormBackColor = 8;
  CardBacKColor = 15;
  CardBorderColor = 0;

  Heart   = 1;
  Diamond = 2;
  Club    = 3;
  Spade   = 4;

{  CardChar : Array[1..13] Of String[2] = (
    'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K');{}

Var
  X, Y : Integer;

Procedure DrawCard(X, Y : Integer; CardID, CardType : Byte);
  Var
    i, j : Integer;
    X2, Y2 : Integer;
  Begin
    SetFillStyle(1, CardBackColor);
    X2 := X+CardWidth-1;
    Y2 := Y+CardHeight-1;
    Bar(X+1, Y+1, X2-1, Y2-1);
    SetColor(CardBorderColor);
    Line(X+2, Y  , X2-2, Y);
    Line(X+2, Y2 , X2-2, Y2);
    Line(X  , Y+2, X   , Y2-2);
    Line(X2 , Y+2, X2  , Y2-2);
    PutPixel(X+1 , Y+1 , CardBorderColor);
    PutPixel(X2-1, Y+1 , CardBorderColor);
    PutPixel(X2-1, Y2-1, CardBorderColor);
    PutPixel(X+1 , Y2-1, CardBorderColor);
    Case CardID Of
      1 : {A};
    End;
  End;

Procedure HideCard(X, Y : Integer);
  Begin
    SetColor(0);
    SetFillStyle(1, 0);
    Bar(X, Y, X+CardWidth-1, Y+CardHeight-1);
  End;

Procedure ReadData;
  Var
    F : Text;
    i, j : Integer;
    H, W : Integer;
    C : Byte;
  Begin
    Assign(F, 'solitare.pic');
    Reset(F);
    ReadLn(F, H, W);
    For i := 1 To H Do
      For j := 1 To W Do
        Begin
          Read(F, C);
          PutPixel(j-1, i-1, C);
        End;
    Close(F);
  End;

BEGIN
  InitGraphMode('SVGA256', 2);
  SetFillStyle(1, FormBackColor);
  Bar(0, 0, GetMaxX, GetMaxY);{}
  ReadData;
  ReadLn;
  CloseGraph;
END.