(*- This Demo is written by NST -*)
(*-          07/11/2001         -*)

Program Pointer_Demostration;

{
 This program shows you how to create an One-Dimension Dynamic-Link-List
 by using Pointer data type.
}

Uses CRT;

Type
  TList = Record
    Index : LongInt;
    Next : Pointer;
  End;

Var
  RecSize : LongInt;
  MemSave : LongInt;
  First : Pointer;
  Last : Pointer;
  ListCount : LongInt;
  Maximum : LongInt;

Procedure IncPoint(Var P : Pointer; I : LongInt);
  Begin
    P := Ptr(Seg(P^)+I Div $10000, Ofs(P^)+I Mod $10000);
  End;

Procedure MemCopy(Source, Dest : Pointer; Count : Word);
  Begin
    Move(Mem[Seg(Source^):Ofs(Source^)],
         Mem[Seg(Dest^):Ofs(Dest^)],
         Count);
  End;

{ Day la ham doc noi dung cua mot con tro }
{ Ham nay chi mang tinh chat tham khao    }
Function AssignPtr(P : Pointer) : Pointer;
  Var
    M : Pointer;
    Segment, Offset : Word;
  Begin
    M := @P;  { M tro den o nho chua P }
    { Doc xem P dang tro den dau:                      }
    {   O nho nay gom 4 bytes lien tiep:               }
		{     2 bytes dau : Offset cua o nho bi P tro toi  }
    {     2 bytes sau : Segment cua o nho bi P tro toi }
    MemCopy(M, @Offset, SizeOf(Offset));
    IncPoint(M, SizeOf(Offset));
    MemCopy(M, @Segment, SizeOf(Segment));
    { AssignPtr luc nay giong het P }
    AssignPtr := Ptr(Segment, Offset);
  End;

Procedure AddItem(I : LongInt; Var P : Pointer);
  Var
    L : LongInt;
    N, M : Pointer;
    Segment, Offset : Word;
  Begin
    GetMem(N, RecSize);
    M := N;
    { Set N^.Index = I }
    MemCopy(@I, N, SizeOf(I));
    IncPoint(N, SizeOf(I));
    { Set N^.Next = Nil }
    L := 0;
    MemCopy(@L, N, 4);
    N := M;
    If First = Nil Then First := N
      Else Begin
        { Now set P^.Next = N }
        Segment := Seg(N^);
        Offset := Ofs(N^);
        IncPoint(P, SizeOf(I));
        MemCopy(@Offset, P, 2);  { Ofs(P^.Next) = Ofs(N^) }
        IncPoint(P, 2);
        MemCopy(@Segment, P, 2);  { Seg(P^.Next) = Seg(N^) }
      End;
    P := N;
  End;

Procedure InitList;
  Var
    P : Pointer;
    I : LongInt;
  Begin
    Randomize;
    First := Nil;
    Last := Nil;
    P := Nil;
    For I := 0 To ListCount-1 Do
		  AddItem(Random(1000), P);
  End;

Procedure GetData(Var I : LongInt; Var P : Pointer);
  Var
    N : Pointer;
    Segment, Offset : Word;
  Begin
    MemCopy(P, @I, SizeOf(I));
    IncPoint(P, SizeOf(I));
    MemCopy(P, @Offset, 2);
    IncPoint(P, 2);
    MemCopy(P, @Segment, 2);
    P := Ptr(Segment, Offset);  { P = P^.Next }
  End;

Procedure ShowList;
  Var
    P : Pointer;
    I : LongInt;
  Begin
    P := First;
    Repeat
      GetData(I, P);
      Write(I:8);
    Until P = Nil;
    WriteLn;
  End;

Procedure ReleaseList;
  Var
    P, Q : Pointer;
    I : LongInt;
  Begin
    P := First;
    Repeat
      Q := P;
      GetData(I, P);
      If Q <> Nil Then FreeMem(Q, RecSize);
    Until P = Nil;
  End;

BEGIN
  ClrScr;
  RecSize := SizeOf(TList);
  MemSave := MaxAvail;
  If MemSave >= RecSize*ListCount Then Begin
    WriteLn('Total free memory : ', MemSave, ' bytes');
    WriteLn('RecSize           : ', RecSize, ' bytes');
    Maximum := MemSave Div RecSize;
    Repeat
      Write('Enter list count (maximum = ', Maximum, '): ');
      ReadLn(ListCount);
    Until ListCount <= Maximum;
    Write('--------------------------------------------------------------------------------');
    WriteLn('Creating list (random from 0 to 999) ...');
    InitList;
    ShowList;
    Write('--------------------------------------------------------------------------------');
    WriteLn('RecSize     : ', RecSize, ' bytes');
    WriteLn('List count  : ', ListCount);
    WriteLn('Used memory : ', MemSave-MaxAvail, ' bytes');
    WriteLn('Total free memory : ', MaxAvail, ' bytes');
    WriteLn;
    Write('Press Enter to release all used memory ...');
    ReadLn;
    ReleaseList;
    WriteLn;
    WriteLn('Total free memory : ', MaxAvail, ' bytes');
    WriteLn('All used memory has been released!');
  End Else Begin
    WriteLn('Not enough memory to run this Demo!');
    WriteLn('Please decrease the ListCount constant');
  End;
  WriteLn;
  Write('Press Enter to exit ...');
  ReadLn;
END.