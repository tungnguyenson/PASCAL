Unit Dic;

Interface

  Const
    TDicMaxWord = 4000;
    TDicWordMaxLength = 15;

  Type
    TWordList = Array[1..TDicMaxWord] Of String[TDicWordMaxLength];

    TDicWord = String[TDicWordMaxLength];

    PDictionary = ^TDictionary;

    TDictionary = Object
      WordList : TWordList;
      WordCount : Word;
      WordOffset : Array['A'..'Z'] Of Word;
      Procedure LoadDictionary(Source : String);
      Function ValidWord(W : TDicWord) : Boolean;
    End;

Implementation

  {
    TDictionary.LoadDictionary
        Description :
          Read word list from the dictionary source file
        Parameters :
          Source : Indicate dictionary source file
        Return :
          Object.WordList
          Object.WordCount
          Object.WordOffset
  }

  Procedure TDictionary.LoadDictionary;
    Var
      F : Text;
      S : String;
    Begin
      Assign(F, Source);
      Reset(F);
      WordCount := 0;
      FillChar(WordOffset, SizeOf(WordOffset), 0);
      While Not EOF(F) Do
        Begin
          ReadLn(F, S);
          If (Length(S) <= 15)And(Length(S) >= 1) Then
            Begin
              Inc(WordCount);
              WordList[WordCount] := S;
              If WordOffset[Upcase(S[1])] = 0 Then
                 WordOffset[Upcase(S[1])] := WordCount;
            End;
        End;
      Close(F);
    End;

  {
    TDictionary.ValidWord
        Description :
          Tra nghia cua 1 tu
        Parameters :
          W : Tu can tra (chi xet chu hoa)
        Return :
          True neu tu do la dung
          False neu nguoc lai
  }

  Function TDictionary.ValidWord;
    Var
      Offset, UBound : Word;
      S : String;
      I : Byte;

    Procedure BinarySearch(Left, Right : Word);
      Begin
      End;

    Begin
      ValidWord := True;
      Offset := WordOffset[W[1]];
      UBound := WordOffset[Chr(Ord(W[1])+1)];
      While Offset < UBound Do
        Begin
          I := 1;
          S := WordList[Offset];
          {If Length(S)
          While
          While W[I] = [I] Do Inc(I);
          If I < Length}
          Inc(Offset);
        End;
    End;

End.