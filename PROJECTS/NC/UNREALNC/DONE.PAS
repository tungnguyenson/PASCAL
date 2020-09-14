Procedure DoneNC;
  Begin
    SetTxtColor(7, 0);
    ClearWindow(1, 1, 80, 25, 0);{}
    Dispose(LeftPanel);
    Dispose(RightPanel);
    ChDir(Copy(AppPath, 1, Length(AppPAth)-1));
  End;

