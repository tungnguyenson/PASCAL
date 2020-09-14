{  Control Object version 1.03  }

Unit CtrlObj;

INTERFACE

  Uses Support;

  Const
    StNotSet  = #0;
    StNotUsed = #0#0;

    chkUnChecked = 0;
    chkChecked   = 1;

    brdNone   = 0;
    brdSingle = 1;
    brdDouble = 2;

    ctrlLabel           = 1;
    ctrlCommandButton   = 2;
    ctrlSingleLineTextBox = 3;
    ctrlCheckBox        = 4;
    ctrlOptionButton    = 5;

    evNothing = 0;
    evCommand = $FFF0;
    evKeyDown = $FFF1;
    evMessage = $FFF2;

    msgFormLoad        = $FF00;
    msgFormNextControl = $FF01;
    msgFormPrevControl = $FF02;
    msgFormKeyEnter    = $FF03;
    msgFormHotKey      = $FF04;
    msgFormUnload      = $FFF0;


    cmdNothing = 0;
    cmdFormUnload = $FFF0;

    MaxControlEachForm = 20;

  Type
    {$I OBJ_DECL}

IMPLEMENTATION

  Uses Keyboard;

  {$I OBJ_IMPL}

BEGIN
END.