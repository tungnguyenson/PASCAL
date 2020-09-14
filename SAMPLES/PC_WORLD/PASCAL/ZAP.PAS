PROGRAM Zap; 
{$I-,S-}
{$M 8192, 8192, 655360} 
USES Dos; 
VAR 
 FVar : file; 
 CurrentPath, WorkingPath, SearchMask : pathstr; 
CONST 
 FileDeleted : integer = 0; 

Function Upper (S: pathstr): pathstr; 
Var 
 i : byte; 
Begin 
for i := 1 to length (S) do S[i]:= upcase (S[i]); 
Upper := S; 
End; 

PROCEDURE Path_Split (DirName: pathstr); 
Var 
 i, DN : byte; 
Begin 
if (DirName [2] = ':') and (DirName [3] <> '\') then
 insert ('\', DirName, 3) ;

DN := 0;
for i := 1 to length (DirName) do
 if (DirName [i] = '\') then DN := i;

if DN = 0 then
begin
 WorkingPath := CurrentPath; 
 SearchMask := DirName; 
end 
else 
begin 
 WorkingPath := copy (DirName, 1, DN-1); 
 SearchMask := copy (DirName, DN+1, length (DirName) -DN); 
end; 
if WorkingPath [2] <> ':' then
 WorkingPath := CurrentPath + '\' + WorkingPath;
if WorkingPath[length(WorkingPath)]='\' then
 dec (WorkingPath [0]); 
{the nay khong chuan,
 nen viet cat string tuong minh}
if SearchMask = '' then
 SearchMask := '*.BAK';
(* If pos ('.', SearchMask = '.' then *)
If pos ('.', SearchMask) = 0 then
 SearchMask := SearchMask + '*.*'
else if SearchMask [1] = '.' then
 SearchMask := '*' + SearchMask;
End; 

PROCEDURE Scan_Files (OrigPath, SearchName: pathstr); 
Var
 F : SearchRec;
 SubOrigPath : pathstr;
Begin
Findfirst (OrigPath + '\' + SearchName, Anyfile-Directory-VolumeID, F);
while DosError = 0 do
begin
 assign (FVar, OrigPath + '\' + F.Name);
 erase (FVar);
 if IOresult = 0 then
 begin
  writeln (' ', OrigPath + '\' + F.Name);
  inc (FileDeleted) ;
 end
 else writeln ('Disk access error ...');
 findnext (F);
end;
findfirst (OrigPath + '\*.*', Directory, F);
while DosError = 0 do
begin
 if ( F.Attr and $10 <> 0) and (F.Name[1] = '.') then
 begin
  SubOrigPath := OrigPath + '\' + F.Name;
  Scan_Files (SubOrigPath,SearchName);
 end;
 findnext (F) ;
end;

End;


BEGIN
writeln ('ZAP - PC Master Utilities Pack. Copyright by Thanh Hai.');
if paramCount <> 0 then
begin
 getDir (0, CurrentPath);
 Path_Split (upper (ParamStr (1)));
 Scan_Files(WorkingPath, SearchMask);
 if DosError = 3 then writeln ('Directory not found - ' + WorkingPath)
 else
  case FileDeleted of
   0 : writeln ('No matching file detected - ' + SearchMask);
   1 : writeln ('1 file has been deleted.');
  else writeln (FileDeleted, ' files have been deleted.');
 end
end
else 
begin 
 writeln ('Command Use : ZAP [file spec]');
 writeln ('whereas : [file spec] - name of directory and/or file(s)');
 writeln (' wildcards in filename are acceptable');
 writeln (' *.BAK at default');
 writeln ('Example : ZAP a:\program\. means ZAP a:\program\*.*');
 writeln ('ZAP program\ means ZAP [current_dir]\program\*.bak');
 writeln ('ZAP prog means ZAP [current_dir]\prog*.*');
 writeln ('ZAP \.prg means ZAP [current_dir]\*.prg');
 writeln ('ZAP program. means ZAP [current_dir]\program');
 writeln ('ZAP C: erases all .bak files in all directories on disk');
end;
END.
