UNIT Comment;

INTERFACE

  Uses Support;

  Procedure ShowAComment(X : Byte; Number : Byte; Name : String;
                         Var NextCommentPos : Byte);

  Procedure ShowCommentBar;

  Procedure ShowCommentBarAttachALT;

  Procedure ShowCommentBarAttachCTRL;

  Var
    cmmID : Byte;

IMPLEMENTATION

  Uses CtrlObj, Global;

  Procedure ShowAComment;
  Var S : String[2];
  Begin
    Str(Number, S);
    OutStr(X, 25, S, 7, 0);
    OutStr(X+Length(S), 25, Name, 0, 3);
    NextCommentPos := X+Length(S)+Length(Name)+1;
  End;

  Procedure ShowCommentBar;
  Var X : Byte;
  Begin
    ShowAComment(1, 1,  'About ', X);
    ShowAComment(X, 2,  'Menu  ', X);
    ShowAComment(X, 3,  'View  ', X);
    ShowAComment(X, 4,  'Edit  ', X);
    ShowAComment(X, 5,  'Copy  ', X);
    ShowAComment(X, 6,  'RenMov', X);
    ShowAComment(X, 7,  'MkDir ', X);
    ShowAComment(X, 8,  'Delete', X);
    ShowAComment(X, 9,  'PullDn', X);
    ShowAComment(X, 10, 'Quit  ', X);
  End;

  Procedure ShowCommentBarAttachALT;
  Var X : Byte;
  Begin
    ShowAComment(1, 1,  'Left  ', X);
    ShowAComment(X, 2,  'Right ', X);
    ShowAComment(X, 3,  'Future', X);
    ShowAComment(X, 4,  'Future', X);
    ShowAComment(X, 5,  'Future', X);
    ShowAComment(X, 6,  'Future', X);
    ShowAComment(X, 7,  'FinDel', X);
    ShowAComment(X, 8,  'Future', X);
    ShowAComment(X, 9,  'Future', X);
    ShowAComment(X, 10, 'Future', X);
  End;

  Procedure ShowCommentBarAttachCTRL;
  Var X : Byte;
  Begin
    ShowAComment(1, 1,  'Left  ', X);
    ShowAComment(X, 2,  'Right ', X);
    ShowAComment(X, 3,  'Name  ', X);
    ShowAComment(X, 4,  'Exten ', X);
    ShowAComment(X, 5,  'Time  ', X);
    ShowAComment(X, 6,  'Size  ', X);
    ShowAComment(X, 7,  'Unsort', X);
    ShowAComment(X, 8,  'Future', X);
    ShowAComment(X, 9,  'Future', X);
    ShowAComment(X, 10, 'Future', X);
  End;

END.