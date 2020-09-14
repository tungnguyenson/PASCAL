Uses CRT, Font;

Var
  i : Byte;

BEGIN
  TextAttr := 7;
  ClrScr;
  NapFont(192, 31, Seg(NewChars), Ofs(NewChars));{}
  For i := 32 To 255 Do
    Write(i:3, Chr(i), ' ');
{ WriteLn;
  WriteLn('окккккккккккккккккк');
  WriteLn('нРкнСм ТмУмФмХмЦмЧмШм');
  WriteLn('нЩмЪмЫмЬмЭмЮмЯмамбм');
  WriteLn('нвмгмдмемжмзмимймкм');{}
{ ReadLn;
  VGAFont;{}
END.

        о к к к к к к к к к к к к к к к к к с

        н Р м С м Т м У м Ф м Х м Ц м Ч м Ш м

        н Щ м Ъ м Ы м Ь м Э м Ю м Я м а м б т

        н в м г м д м е м ж м з м и м й м к т

        окккккккккккккккккс
        уABCDEFGHIJKLMNOPQу
        уRSTUVWXYZABCabcdeу
        уfghijklmnopqrstuvу
        плллллллллллллллллр

218 219 220 221 222 223 224 225 226 227
 к   л   м   н   о   п   р   с   т   у

        кккккк
        нкмккм
        нкмккм

