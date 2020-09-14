Unit Font;

Interface

  Type
     Character = Array[0..15] of Byte;

  {$I FontSave}

  Function VNF(St : String) : String;
  Procedure LoadCharacter(KT : Character; STT : Byte);
  Procedure LoadFont(KiTuBatDau : Byte; SoKiTu, Segment, Ofset : Word);
  Procedure VGAFont;

Implementation

  Uses Dos;

  Function VNF(St : String) : String;
    Const
      Max_Code = 74;
      Code1 : Array[1..Max_Code] of String[3] = (
        'AW', 'AA', 'EE', 'OO', 'OW', 'UW', 'DD', 'aw', 'aa',
        'ee', 'oo', 'ow', 'uw', 'dd', 'af', 'ar', 'ax', 'as',
        'aj','awf','awr','awx','aws','awj','aaf','aar','aax',
       'aas','aaj', 'ef', 'er', 'ex', 'es', 'ej','eef','eer',
       'eex','ees','eej', 'if', 'ir', 'ix', 'is', 'ij', 'os',
        'or', 'ox', 'os', 'oj','oof','oor','oox','oos','ooj',
       'owf','owr','owx','ows','owj', 'uf', 'ur', 'ux', 'us',
        'uj','uwf','uwr','uwx','uws','uwj', 'yf', 'yr', 'yx',
        'ys', 'yj');
      Code2 : Array[1..Max_Code] of Byte = (
        161, 162, 163, 164, 165, 166, 167, 168, 169,
        170, 171, 172, 173, 174, 181, 182, 183, 184,
        185, 187, 188, 189, 190, 198, 199, 200, 201,
        202, 203, 204, 206, 207, 208, 209, 210, 211,
        212, 213, 214, 215, 216, 220, 221, 222, 223,
        225, 226, 227, 228, 229, 230, 231, 232, 233,
        234, 235, 236, 237, 238, 239, 241, 242, 243,
        244, 245, 246, 247, 248, 249, 250, 251, 252,
        253, 254);
     Begin_Code = 161;
    Var
      i, j : Byte;
    Begin
      For i := Max_Code Downto 1 do
        While Pos(Code1[i], St) <> 0 do
          Begin
            j := Pos(Code1[i], St);
            Delete(St, j, Length(Code1[i]));
            Insert(Chr(Code2[i]), St, j);
          End;
      VNF := St;
    End;

  Procedure LoadCharacter;
    Var
      Regs : Registers;
    Begin
      With Regs do
        Begin
          AH := $11;
          AL := 0;
          BH := 16;
          BL := 0;
          CX := 1;
          DX := STT;
          ES := Seg(KT);
          BP := Ofs(KT);
        End;
    End;

  Procedure LoadFont;
    Var
      Regs : Registers;
    Begin
      With Regs do
        Begin
          AH := $11;
          AL := 0;
          BH := 16;
          BL := 0;
          CX := SoKiTu;
          DX := KiTuBatDau;
          ES := Segment;
          BP := Ofset;
          Intr($10, Regs);
        End;
    End;

  Procedure VGAFont;
    Var
      Regs : Registers;
    Begin
      Regs.AX := $0003;
      Intr($10, Regs);
    End;

BEGIN
  LoadFont(0, 256, Seg(UserFont), Ofs(UserFont));{}
END.