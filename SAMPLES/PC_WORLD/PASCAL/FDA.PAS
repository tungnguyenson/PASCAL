Program FDA; 
uses
 dos;
var
 fvar:file;
 CurrentPath, workingPath, SearchMask:string;
 N: byte;
 Param: array[1..8] of string;
CONST
 FileAttributed: word = 0;
 Attr: word= $0;
 SubDir: boolean = false;
 DirToo: boolean = false;

FUNCTION Upper (S:string): string;
Var
 i: byte;
Begin
 for i := 1 to length (s) do s[i] := upcase (s[i]);
 Upper := s;
End;

PROCEDURE PathSplit (DirName: string); 
var
 i, DN: byte;
Begin
 if (DirName [2]= ':') and (DirName[3] <> '\')
 then insert ('\', DirName, 3);
 DN :=0;
 for i := 1 to length (DirName) do
  if DirName[i] = '\' then DN := i;
  if DN = 0 then
  begin
   WorkingPath := CurrentPath;
   SearchMask := DirName
  end
  else begin
   WorkingPath := copy (DirName,  1,  DN-1);
   SearchMask := copy (DirName, DN+1,  length (DirName)-DN)
  end;
  if WorkingPath[2] <> ':' then
   WorkingPath := CurrentPath  + '\' + WorkingPath;
  if WorkingPath [length (WorkingPath)] = '\' then
   dec (WorkingPath [0]);
   (*
   vi workingpath thuoc loai string
   nen dung
   copy(workingpath,1,length(workingpath-1))
   *)
  if (SearchMask = ' ') or (SearchMask = '.') then
   SearchMask := '*.*';
  if pos ('.', SearchMask) = 0
  then
   SearchMask := SearchMask + '*.*'
  else
   if SearchMask [1] = '.' then
    SearchMask := '*' + SearchMask
End;

PROCEDURE Scan_Files (OrigPath, SearchName: string); 
Var
 F: SearchRec;
 SuborigPath: string;
begin
 findfirst (origPath + '\' + SearchName, Anyfile-VolumeID, F);
 while DosError = 0 do
 begin
  assign (FVar, origPath + '\' + F.Name);
  if (F.Attr and Directory <> 0) then
  begin
   if DirToo then
   begin
    setFattr (FVar, Attr);
    if DosError <> 0 then
     writeln ('Error attribute setting.')
    else
     inc (FileAttributed);
   end;
  end
  else
  begin
   setFattr (FVar, Attr);
   if DosError <> 0 then
    writeln ('Error attribute setting.')
   else
    inc (FileAttributed);
  end;
  findnext(F);
 end;
 if SubDir then {scanning subdirectories}
 begin
  findfirst (OrigPath + '\*.*', Directory, F);
  while dosError = 0 do
  begin
   if (F.Attr and $10 <> 0) and (F.Name[1] <> '.')
   then
   begin
    SubOrigPath := OrigPath + '\' + F.Name;
    Scan_Files(SubOrigPath, SearchName);
   end;
   findnext (F);
  end;
 end;
End;

BEGIN
writeln('File/Directory Attribute-PC Master Utilities Pack. Copyrigh by Thanh Hai.');
for N := 1 to paramCount do
 Param[N] := upper(paramStr(N));
if paramCount <> 0 then
begin
 getDir (0, CurrentPath);
 if Param[1] <> ' '
 then
 begin
  if Param[1] = '\SUB' then
   SubDir := true
  else
   PathSplit(Param[1]);
 end;
 for N :=2 to paramCount do
 begin
  if Param [N] = '/SUB' then SubDir := true;
  if Param[N] = '/SUB' then SubDir := true;
  if Param[N] = '/R' then Attr := Attr or Readonly;
  if Param[N] = '/H' then Attr := Attr or Hidden;
  if Param[N] = '/S' then Attr := Attr or Sysfile;
  if Param[N] = '/A' then Attr := Attr or Archive;
  if Param[N] = '/T' then Attr := $1+$2+$4+$20;
  if Param[N] = '/C' then Attr := $0;
 end;
 Scan_Files (WorkingPath, SearchMask);
 if FileAttributed <> 0
 then
  writeln (FileAttributed, ' file(s) have been reattributed.')
 else
  if DosError = 3 then
   writeln ('Directory not found-' + WorkingPath)
  else
   writeln('No matching file detected -' + SearchMask);
end
else
begin 
 writeln( 'Command Use: FDA [Pathname] /SUB/DIR/A /R /H /S /T /C');
 writeln( ' whereas: [pathname]-name of directory and /or file (s)');
 writeln( '  wildcards in filename are acceptable');
 writeln( ' *.* at default');
 writeln( ' /SUB-subdirectories are inclusive');
 writeln( ' /DIR-directory is handled as file');
 writeln( ' /A-archive');
 writeln( ' /R-read only');
 writeln( ' /H-hidden');
 writeln( ' /S-system');
 writeln( ' /T-total attribute');
 writeln( ' /C-clear');
end;
END.