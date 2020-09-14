Uses Crt, Dos; 
Const
 NUColor = $9F;
 BlinkOn = TRUE;
 BlinkOff = FALSE;

Procedure SetBlink (OnOff: Boolean);
Var
 R: Registers;
Begin
R.AX := $1003;
If OnOff then R.BL := 1 else R.BL := 0;
Intr ($10,R);
End;

Begin 
ClrScr; 
SetBlink (BlinkOff); 
TextColor( NUColor);
Writeln('Day la mau cua NU 8.0');
SetBlink (BlinkOff);
End.

ÿ