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
  WriteLn('�������������������');
  WriteLn('������ ��������������');
  WriteLn('�������������������');
  WriteLn('�������������������');{}
{ ReadLn;
  VGAFont;{}
END.

        � � � � � � � � � � � � � � � � � � �

        � � � � � � � � � � � � � � � � � � �

        � � � � � � � � � � � � � � � � � � �

        � � � � � � � � � � � � � � � � � � �

        �������������������
        �ABCDEFGHIJKLMNOPQ�
        �RSTUVWXYZABCabcde�
        �fghijklmnopqrstuv�
        �������������������

218 219 220 221 222 223 224 225 226 227
 �   �   �   �   �   �   �   �   �   �

        ������
        ������
        ������

