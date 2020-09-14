Program Sua_file_Pas; 
Var
 f1,f2:file of char;
 ch:char;
 i:byte;
Begin
if (paramstr(1)='') or (paramstr (1)= '/?') then
Begin 
 Writeln ('Sua file PAS 1.1 - duoc viet boi Vu Trong Thu, 1997');
 Writeln ('------------');
 Writeln ('Cach su dung:');
 Writeln ('Fixpas ');
 Writeln ('Cam on ban da su dung chuong trinh nay!');
 Exit;
End;
Writeln ('Dang sua file', paramstr(1), '...');
Assign (f1,paramstr(1));
Reset (f1);
Seek (f1, filesize(f1)-256);
If paramstr(2)<> '' then assign (f2, paramstr(2))
else assign (f2, 'TEMP.$$$');
Rewrite(f2);
For i:=1 to 27 do 
begin 
 read (f1,ch);
 write (f2,ch);
end;
Seek (f1,27);
While filepos (f1) < filesize (f1) - 256 do
Begin 
 Read (f1,ch);
 Write (f2,ch);
End;
Close (f1);
Close (f2);
If paramstr(2)= '' then
Begin
 Erase (f1);
 Rename (f2, paramstr(1));
End;
End.
