{Chuong trinh 2 LOCKFILE.PAS}
{$M 8192,0,0}
Program EXECUTABLE_FILE_LOCKER;
Uses Crt,Dos;
Type
 Str15=String[15];
Var 
 Search:SearchRec;
 Dir:DirStr;
 Path:PathStr;
 Name:NameStr;
 Ext:ExtStr;
 Filename:PathStr;
 Regs:Registers;
 IsEXE:Boolean;
Const
 FileIns:Word=0;

Procedure SetPassword(IsEXE: Boolean);
{Thu tuc mat ma cho tap tin}
Var FBuffer:Word;
Begin
 SwapVecTors;
 If NOT IsEXE then
  Exec('LOCK-COM.COM',' '+FileName)
 Else
  Exec('LOCK-EXE.COM', ' '+ FileName);
 SwapVectors;
 GotoXY(60,WhereY);
 If DosError<>0 then Write('Cannot set password...')
 Else
 case DosExitCode of
  0:Begin Write('done...');Inc(FileIns)End;
  2:Write('error...');
  3:Write('was locked...');
 End;
END;{Setpassword}

Begin{MAIN}
 Writeln;
 Writeln('  The Executable file locker 1996.');
 Writeln('      Written by Dao Hai Nam, Da Lat University K95.');
 Writeln;
 If ParamCount=0 then
  Path:='*.*'
 Else
  Path:=ParamStr(1);
 Path:=FExpand(Path);
 FindFirst(Path,Archive,Search); {Tim tap tin dau tien}
 FSplit(Path,Dir,Name,Ext);
 While DosError=0 do 
 Begin
  If (Pos('.EXE',Search.Name)<>0)
     OR
     (Pos('.COM',Search.Name)<>0)
  then 
  Begin
   If (Search.Name<>'LOCK-COM.COM') AND
      (Search.Name<>'LOCK-EXE.COM') AND
      (Search.Name<>'LOCKFILE.EXE') then 
   Begin
    Write(Search.Name);
    FileName:=Dir+Search.Name;
    GotoXY(20,WhereY);
    If Pos('.EXE',Search.Name)<>0 then
     IsEXE:=True
    Else
     IsEXE:=False;
    SetPassword(IsEXE);
    Writeln;
   End;
  End;{If Pos(COM) AND Pos(EXE)}
  FindNext(Search); {Tim tap tin tiep theo}
 End;{While Dos Error=0}
 Writeln;
 If FileIns>0 then
  Writeln(FileIns,' file(s) is installed.')
 Else
  Writeln('File not found.');
End.{MAIN}
