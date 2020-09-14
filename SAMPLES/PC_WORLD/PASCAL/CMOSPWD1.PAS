Program Delete_Password; 
          uses crt, dos; 
          const Abval: array[$37..$3F] of byte=(192,0,0,0,0,0,0,5,133); 
          var i: byte; 
          c: char; 
Begin 
          clrscr; 
          Writeln('Are you sure (y/n)? '); 
          c:=readkey; 
          If upcase(c)='Y' then 
          begin 
          for i:=$37 to $3F do 
          begin 
          port[$70]:=i; 
          port[$71]:=Abval[i]; 
          end; 
          writeln('OK!'); 
          end; 
End. 