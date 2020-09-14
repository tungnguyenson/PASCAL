program Alarm;
          {$M $800,0,0} {2k stack}
          Uses Crt,Dos;
          Const
          a=1193180;
          b=65536;
          c=1573040;
          Var OldTimer: Procedure;
          i:Byte;
          v, code: integer;
          Ticks: longint;
          l: ^longint;
          Const
          Time: Array[1..3] of byte = (0,0,0);
          limit: Array[1..3] of byte = (23,59,59);
          {$F+}
          Procedure NewTimer ; interrupt;
          Procedure Bell;
          Const Params: array[1..7] of word = (10,1,600,3000,17,5,1900);
          var i,j,k: word;
          begin {BELL}
          for i:=1 to Params[1] do
          begin
          j:=Params[2];
          {}
          repeat
          j:=j+Params[3];
          Sound(Params[4]-j);
          Delay(Params[5]);
          Nosound;
          Delay(Params[6]);
          until j>Params[7]
          end;
          end; {BELL}
          begin {Newrimer}
          If l^ mod c = ticks then Bell;
          Inline ($9c);
          Oldtimer;
          end; {New TIMER}
          {$F-}
          Procedure Help;
          begin
          writeln('Syntax: ALARM gio[phut[giay]]');
          Halt(1);
          end;

          Begin {Main program}
          if not (Paramcount in [1..3]) then Help;
          for i:= 1 to Paramcount do
          begin
          Val(ParamStr(i),v,code);
          time[i]:=v;
          if not (time[i] in [0..limit[i]]) or (code<>0) then Help;
          end;
          Ticks:=Time[3]+60*Time[2]+3600*longint(Time[1]);
          Ticks:= a div b*Ticks+a mod b*Ticks div b
                  + a mod b*Ticks mod b div b;
          l:=Ptr(0,$46c);
          GetIntVec($1c,@Oldtimer);
          SetIntVec($1c,Addr(NewTimer));
          Writeln ('Se len chuong luc', Time[1], ':', Time[2], ':', Time[3]);
          Keep (0); {Ket thuc & thuong truc trong bo nho}
          end.

