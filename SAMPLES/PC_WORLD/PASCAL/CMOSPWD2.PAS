Program Delete_Password; 
          uses crt, dos; 
          var c: char; 
Begin 
          clrscr; 
          Writeln('Do you want to delete CMOS (y/n)? '); 
          c:=readkey; 
          If upcase(c)='Y' then 
          begin 
          port[$70]:= $40; 
          port[$71]:= 5; 
          writeln('OK!'); 
          end; 
End. 