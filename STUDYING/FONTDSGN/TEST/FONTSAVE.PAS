Const
  UserFont : Array[0..255, 0..15] Of Byte = (
{  0 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  1 } (  0,   0, 126, 129, 165, 129, 129, 189, 153, 129, 129, 126,   0,   0,   0,   0),
{  2 } (  0,   0, 126, 255, 219, 255, 255, 195, 231, 255, 255, 126,   0,   0,   0,   0),
{  3 } (  0,   0,   0,   0, 108, 254, 254, 254, 254, 124,  56,  16,   0,   0,   0,   0),
{  4 } (  0,   0,   0,   0,  16,  56, 124, 254, 124,  56,  16,   0,   0,   0,   0,   0),
{  5 } (  0,   0,   0,  24,  60,  60, 231, 231, 231, 153,  24,  60,   0,   0,   0,   0),
{  6 } (  0,   0,   0,  24,  60, 126, 255, 255, 126,  24,  24,  60,   0,   0,   0,   0),
{  7 } (  0,   0,   0,   0,   0,   0,  24,  60,  60,  24,   0,   0,   0,   0,   0,   0),
{  8 } (255, 255, 255, 255, 255, 255, 231, 195, 195, 231, 255, 255, 255, 255, 255, 255),
{  9 } (  0,   0,   0,   0,   0,  60, 102,  66,  66, 102,  60,   0,   0,   0,   0,   0),
{ 10 } (255, 255, 255, 255, 255, 195, 153, 189, 189, 153, 195, 255, 255, 255, 255, 255),
{ 11 } (  0,   0,  30,  14,  26,  50, 120, 204, 204, 204, 204, 120,   0,   0,   0,   0),
{ 12 } (  0,   0,  60, 102, 102, 102, 102,  60,  24, 126,  24,  24,   0,   0,   0,   0),
{ 13 } (  0,   0,  63,  51,  63,  48,  48,  48,  48, 112, 240, 224,   0,   0,   0,   0),
{ 14 } (  0,   0, 127,  99, 127,  99,  99,  99,  99, 103, 231, 230, 192,   0,   0,   0),
{ 15 } (  0,   0,   0,  24,  24, 219,  60, 231,  60, 219,  24,  24,   0,   0,   0,   0),
{ 16 } (  0, 128, 192, 224, 240, 248, 254, 248, 240, 224, 192, 128,   0,   0,   0,   0),
{ 17 } (  0,   2,   6,  14,  30,  62, 254,  62,  30,  14,   6,   2,   0,   0,   0,   0),
{ 18 } (  0,   0,  24,  60, 126,  24,  24,  24,  24, 126,  60,  24,   0,   0,   0,   0),
{ 19 } (  0,   0, 102, 102, 102, 102, 102, 102, 102,   0, 102, 102,   0,   0,   0,   0),
{ 20 } (  0,   0, 127, 219, 219, 219, 123,  27,  27,  27,  27,  27,   0,   0,   0,   0),
{ 21 } (  0, 124, 198,  96,  56, 108, 198, 198, 108,  56,  12, 198, 124,   0,   0,   0),
{ 22 } (  0,   0,   0,   0,   0,   0,   0,   0, 254, 254, 254, 254,   0,   0,   0,   0),
{ 23 } (  0,   0,  24,  60, 126,  24,  24,  24,  24, 126,  60,  24, 126,   0,   0,   0),
{ 24 } (  0,   0,  24,  60, 126,  24,  24,  24,  24,  24,  24,  24,   0,   0,   0,   0),
{ 25 } (  0,   0,  24,  24,  24,  24,  24,  24,  24, 126,  60,  24,   0,   0,   0,   0),
{ 26 } (  0,   0,   0,   0,   0,  24,  12, 254,  12,  24,   0,   0,   0,   0,   0,   0),
{ 27 } (  0,   0,   0,   0,   0,  48,  96, 254,  96,  48,   0,   0,   0,   0,   0,   0),
{ 28 } (  0,   0,   0,   0,   0, 192, 192, 192, 192, 254,   0,   0,   0,   0,   0,   0),
{ 29 } (  0,   0,   0,   0,   0,  36, 102, 255, 102,  36,   0,   0,   0,   0,   0,   0),
{ 30 } (  0,   0,   0,   0,  16,  56,  56, 124, 124, 254, 254,   0,   0,   0,   0,   0),
{ 31 } (  0,   0,   0,   0, 254, 254, 124, 124,  56,  56,  16,   0,   0,   0,   0,   0),
{ 32 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 33 } (  0,   0,  24,  60,  60,  60,  24,  24,  24,   0,  24,  24,   0,   0,   0,   0),
{ 34 } (  0, 102, 102, 102,  36,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 35 } (  0,   0,   0, 108, 108, 254, 108, 108, 108, 254, 108, 108,   0,   0,   0,   0),
{ 36 } ( 24,  24, 124, 198, 194, 192, 124,   6, 134, 198, 124,  24,  24,   0,   0,   0),
{ 37 } (  0,   0,   0,   0, 194, 198,  12,  24,  48,  96, 198, 134,   0,   0,   0,   0),
{ 38 } (  0,   0,  56, 108, 108,  56, 118, 220, 204, 204, 204, 118,   0,   0,   0,   0),
{ 39 } (  0,  48,  48,  48,  96,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 40 } (  0,   0,  12,  24,  48,  48,  48,  48,  48,  48,  24,  12,   0,   0,   0,   0),
{ 41 } (  0,   0,  48,  24,  12,  12,  12,  12,  12,  12,  24,  48,   0,   0,   0,   0),
{ 42 } (  0,   0,   0,   0,   0, 102,  60, 255,  60, 102,   0,   0,   0,   0,   0,   0),
{ 43 } (  0,   0,   0,   0,   0,  24,  24, 126,  24,  24,   0,   0,   0,   0,   0,   0),
{ 44 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,  24,  24,  24,  48,   0,   0,   0),
{ 45 } (  0,   0,   0,   0,   0,   0,   0, 254,   0,   0,   0,   0,   0,   0,   0,   0),
{ 46 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  24,  24,   0,   0,   0,   0),
{ 47 } (  0,   0,   0,   0,   2,   6,  12,  24,  48,  96, 192, 128,   0,   0,   0,   0),
{ 48 } (  0,   0, 124, 198, 198, 198, 214, 214, 198, 198, 198, 124,   0,   0,   0,   0),
{ 49 } (  0,   0,  24,  56, 120,  24,  24,  24,  24,  24,  24, 126,   0,   0,   0,   0),
{ 50 } (  0,   0, 124, 198,   6,  12,  24,  48,  96, 192, 198, 254,   0,   0,   0,   0),
{ 51 } (  0,   0, 124, 198,   6,   6,  60,   6,   6,   6, 198, 124,   0,   0,   0,   0),
{ 52 } (  0,   0,  12,  28,  60, 108, 204, 254,  12,  12,  12,  30,   0,   0,   0,   0),
{ 53 } (  0,   0, 254, 192, 192, 192, 252,  14,   6,   6, 198, 124,   0,   0,   0,   0),
{ 54 } (  0,   0,  56,  96, 192, 192, 252, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{ 55 } (  0,   0, 254, 198,   6,   6,  12,  24,  48,  48,  48,  48,   0,   0,   0,   0),
{ 56 } (  0,   0, 124, 198, 198, 198, 124, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{ 57 } (  0,   0, 124, 198, 198, 198, 126,   6,   6,   6,  12, 120,   0,   0,   0,   0),
{ 58 } (  0,   0,   0,   0,  24,  24,   0,   0,   0,  24,  24,   0,   0,   0,   0,   0),
{ 59 } (  0,   0,   0,   0,  24,  24,   0,   0,   0,  24,  24,  48,   0,   0,   0,   0),
{ 60 } (  0,   0,   0,   6,  12,  24,  48,  96,  48,  24,  12,   6,   0,   0,   0,   0),
{ 61 } (  0,   0,   0,   0,   0,   0, 254,   0,   0, 254,   0,   0,   0,   0,   0,   0),
{ 62 } (  0,   0,   0,  96,  48,  24,  12,   6,  12,  24,  48,  96,   0,   0,   0,   0),
{ 63 } (  0,   0, 124, 198, 198,  12,  24,  24,  24,   0,  24,  24,   0,   0,   0,   0),
{ 64 } (  0,   0,   0, 124, 198, 198, 222, 222, 222, 220, 192, 124,   0,   0,   0,   0),
{ 65 } (  0,   0,  16,  56, 108, 198, 198, 254, 198, 198, 198, 198,   0,   0,   0,   0),
{ 66 } (  0,   0, 252, 102, 102, 102, 124, 102, 102, 102, 102, 252,   0,   0,   0,   0),
{ 67 } (  0,   0,  60, 102, 194, 192, 192, 192, 192, 194, 102,  60,   0,   0,   0,   0),
{ 68 } (  0,   0, 248, 108, 102, 102, 102, 102, 102, 102, 108, 248,   0,   0,   0,   0),
{ 69 } (  0,   0, 254, 102,  98, 104, 120, 104,  96,  98, 102, 254,   0,   0,   0,   0),
{ 70 } (  0,   0, 254, 102,  98, 104, 120, 104,  96,  96,  96, 240,   0,   0,   0,   0),
{ 71 } (  0,   0,  60, 102, 194, 192, 192, 222, 198, 198, 102,  58,   0,   0,   0,   0),
{ 72 } (  0,   0, 198, 198, 198, 198, 254, 198, 198, 198, 198, 198,   0,   0,   0,   0),
{ 73 } (  0,   0,  60,  24,  24,  24,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{ 74 } (  0,   0,  30,  12,  12,  12,  12,  12, 204, 204, 204, 120,   0,   0,   0,   0),
{ 75 } (  0,   0, 230, 102, 108, 108, 120, 120, 108, 102, 102, 230,   0,   0,   0,   0),
{ 76 } (  0,   0, 240,  96,  96,  96,  96,  96,  96,  98, 102, 254,   0,   0,   0,   0),
{ 77 } (  0,   0, 198, 238, 254, 254, 214, 198, 198, 198, 198, 198,   0,   0,   0,   0),
{ 78 } (  0,   0, 198, 230, 246, 254, 222, 206, 198, 198, 198, 198,   0,   0,   0,   0),
{ 79 } (  0,   0,  56, 108, 198, 198, 198, 198, 198, 198, 108,  56,   0,   0,   0,   0),
{ 80 } (  0,   0, 252, 102, 102, 102, 124,  96,  96,  96,  96, 240,   0,   0,   0,   0),
{ 81 } (  0,   0, 124, 198, 198, 198, 198, 198, 198, 214, 222, 124,  12,  14,   0,   0),
{ 82 } (  0,   0, 252, 102, 102, 102, 124, 108, 102, 102, 102, 230,   0,   0,   0,   0),
{ 83 } (  0,   0, 124, 198, 198,  96,  56,  12,   6, 198, 198, 124,   0,   0,   0,   0),
{ 84 } (  0,   0, 126, 126,  90,  24,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{ 85 } (  0,   0, 198, 198, 198, 198, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{ 86 } (  0,   0, 198, 198, 198, 198, 198, 198, 198, 108,  56,  16,   0,   0,   0,   0),
{ 87 } (  0,   0, 198, 198, 198, 198, 198, 214, 214, 254, 108, 108,   0,   0,   0,   0),
{ 88 } (  0,   0, 198, 198, 108, 108,  56,  56, 108, 108, 198, 198,   0,   0,   0,   0),
{ 89 } (  0,   0, 102, 102, 102, 102,  60,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{ 90 } (  0,   0, 254, 198, 134,  12,  24,  48,  96, 194, 198, 254,   0,   0,   0,   0),
{ 91 } (  0,   0,  60,  48,  48,  48,  48,  48,  48,  48,  48,  60,   0,   0,   0,   0),
{ 92 } (  0,   0,   0, 128, 192, 224, 112,  56,  28,  14,   6,   2,   0,   0,   0,   0),
{ 93 } (  0,   0,  60,  12,  12,  12,  12,  12,  12,  12,  12,  60,   0,   0,   0,   0),
{ 94 } ( 16,  56, 108, 198,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 95 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 255,   0,   0),
{ 96 } ( 48,  48,  24,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 97 } (  0,   0,   0,   0,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{ 98 } (  0,   0, 224,  96,  96, 120, 108, 102, 102, 102, 102, 220,   0,   0,   0,   0),
{ 99 } (  0,   0,   0,   0,   0, 124, 198, 192, 192, 192, 198, 124,   0,   0,   0,   0),
{100 } (  0,   0,  28,  12,  12,  60, 108, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{101 } (  0,   0,   0,   0,   0, 124, 198, 254, 192, 192, 198, 124,   0,   0,   0,   0),
{102 } (  0,   0,  56, 108, 100,  96, 240,  96,  96,  96,  96, 240,   0,   0,   0,   0),
{103 } (  0,   0,   0,   0,   0, 118, 204, 204, 204, 204, 204, 124,  12, 204, 120,   0),
{104 } (  0,   0, 224,  96,  96, 108, 118, 102, 102, 102, 102, 230,   0,   0,   0,   0),
{105 } (  0,   0,  24,  24,   0,  56,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{106 } (  0,   0,   6,   6,   0,  14,   6,   6,   6,   6,   6,   6, 102, 102,  60,   0),
{107 } (  0,   0, 224,  96,  96, 102, 108, 120, 120, 108, 102, 230,   0,   0,   0,   0),
{108 } (  0,   0,  56,  24,  24,  24,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{109 } (  0,   0,   0,   0,   0, 236, 254, 214, 214, 214, 214, 214,   0,   0,   0,   0),
{110 } (  0,   0,   0,   0,   0, 220, 102, 102, 102, 102, 102, 102,   0,   0,   0,   0),
{111 } (  0,   0,   0,   0,   0, 124, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{112 } (  0,   0,   0,   0,   0, 220, 102, 102, 102, 102, 102, 124,  96,  96, 240,   0),
{113 } (  0,   0,   0,   0,   0, 118, 204, 204, 204, 204, 204, 124,  12,  12,  30,   0),
{114 } (  0,   0,   0,   0,   0, 220, 118,  98,  96,  96,  96, 240,   0,   0,   0,   0),
{115 } (  0,   0,   0,   0,   0, 124, 198,  96,  56,  12, 198, 124,   0,   0,   0,   0),
{116 } (  0,   0,  16,  48,  48, 252,  48,  48,  48,  48,  54,  28,   0,   0,   0,   0),
{117 } (  0,   0,   0,   0,   0, 204, 204, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{118 } (  0,   0,   0,   0,   0, 102, 102, 102, 102, 102,  60,  24,   0,   0,   0,   0),
{119 } (  0,   0,   0,   0,   0, 198, 198, 198, 214, 214, 254, 108,   0,   0,   0,   0),
{120 } (  0,   0,   0,   0,   0, 198, 108,  56,  56,  56, 108, 198,   0,   0,   0,   0),
{121 } (  0,   0,   0,   0,   0, 198, 198, 198, 198, 198, 198, 126,   6,  12, 248,   0),
{122 } (  0,   0,   0,   0,   0, 254, 204,  24,  48,  96, 198, 254,   0,   0,   0,   0),
{123 } (  0,   0,  14,  24,  24,  24, 112,  24,  24,  24,  24,  14,   0,   0,   0,   0),
{124 } (  0,   0,  24,  24,  24,  24,   0,  24,  24,  24,  24,  24,   0,   0,   0,   0),
{125 } (  0,   0, 112,  24,  24,  24,  14,  24,  24,  24,  24, 112,   0,   0,   0,   0),
{126 } (  0,   0, 118, 220,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{127 } (  0,   0,   0,   0,  16,  56, 108, 198, 198, 198, 254,   0,   0,   0,   0,   0),
{128 } (  0,   0,  60, 102, 194, 192, 192, 192, 194, 102,  60,  12,   6, 124,   0,   0),
{129 } (  0,   0, 204, 204,   0, 204, 204, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{130 } (  0,  12,  24,  48,   0, 124, 198, 254, 192, 192, 198, 124,   0,   0,   0,   0),
{131 } (  0,  16,  56, 108,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{132 } (  0,   0, 204, 204,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{133 } (  0,  96,  48,  24,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{134 } (  0,  56, 108,  56,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{135 } (  0,   0,   0,   0,  60, 102,  96,  96, 102,  60,  12,   6,  60,   0,   0,   0),
{136 } (  0,  16,  56, 108,   0, 124, 198, 254, 192, 192, 198, 124,   0,   0,   0,   0),
{137 } (  0,   0, 198, 198,   0, 124, 198, 254, 192, 192, 198, 124,   0,   0,   0,   0),
{138 } (  0,  96,  48,  24,   0, 124, 198, 254, 192, 192, 198, 124,   0,   0,   0,   0),
{139 } (  0,   0, 102, 102,   0,  56,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{140 } (  0,  24,  60, 102,   0,  56,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{141 } (  0,  96,  48,  24,   0,  56,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{142 } (  0, 198, 198,  16,  56, 108, 198, 198, 254, 198, 198, 198,   0,   0,   0,   0),
{143 } ( 56, 108,  56,   0,  56, 108, 198, 198, 254, 198, 198, 198,   0,   0,   0,   0),
{144 } ( 24,  48,  96,   0, 254, 102,  96, 124,  96,  96, 102, 254,   0,   0,   0,   0),
{145 } (  0,   0,   0,   0,   0, 204, 118,  54, 126, 216, 216, 110,   0,   0,   0,   0),
{146 } (  0,   0,  62, 108, 204, 204, 254, 204, 204, 204, 204, 206,   0,   0,   0,   0),
{147 } (  0,  16,  56, 108,   0, 124, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{148 } (  0,   0, 198, 198,   0, 124, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{149 } (  0,  96,  48,  24,   0, 124, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{150 } (  0,  48, 120, 204,   0, 204, 204, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{151 } (  0,  96,  48,  24,   0, 204, 204, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{152 } (  0,   0, 198, 198,   0, 198, 198, 198, 198, 198, 198, 126,   6,  12, 120,   0),
{153 } (  0, 198, 198,   0,  56, 108, 198, 198, 198, 198, 108,  56,   0,   0,   0,   0),
{154 } (  0, 198, 198,   0, 198, 198, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{155 } (  0,  24,  24,  60, 102,  96,  96,  96, 102,  60,  24,  24,   0,   0,   0,   0),
{156 } (  0,  56, 108, 100,  96, 240,  96,  96,  96,  96, 230, 252,   0,   0,   0,   0),
{157 } (  0,   0, 102, 102,  60,  24, 126,  24, 126,  24,  24,  24,   0,   0,   0,   0),
{158 } (  0, 248, 204, 204, 248, 196, 204, 222, 204, 204, 204, 198,   0,   0,   0,   0),
{159 } (  0,  14,  27,  24,  24,  24, 126,  24,  24,  24,  24,  24, 216, 112,   0,   0),
{160 } (  0,  24,  48,  96,   0, 120,  12, 124, 204, 204, 204, 118,   0,   0,   0,   0),
{161 } (  0,  12,  24,  48,   0,  56,  24,  24,  24,  24,  24,  60,   0,   0,   0,   0),
{162 } (  0,  24,  48,  96,   0, 124, 198, 198, 198, 198, 198, 124,   0,   0,   0,   0),
{163 } (  0,  24,  48,  96,   0, 204, 204, 204, 204, 204, 204, 118,   0,   0,   0,   0),
{164 } (  0,   0, 118, 220,   0, 220, 102, 102, 102, 102, 102, 102,   0,   0,   0,   0),
{165 } (118, 220,   0, 198, 230, 246, 254, 222, 206, 198, 198, 198,   0,   0,   0,   0),
{166 } (  0,  60, 108, 108,  62,   0, 126,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{167 } (  0,  56, 108, 108,  56,   0, 124,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{168 } (  0,   0,  48,  48,   0,  48,  48,  96, 192, 198, 198, 124,   0,   0,   0,   0),
{169 } (  0,   0,   0,   0,   0,   0, 254, 192, 192, 192, 192,   0,   0,   0,   0,   0),
{170 } (  0,   0,   0,   0,   0,   0, 254,   6,   6,   6,   6,   0,   0,   0,   0,   0),
{171 } (  0, 192, 192, 194, 198, 204,  24,  48,  96, 206, 147,   6,  12,  31,   0,   0),
{172 } (  0, 192, 192, 194, 198, 204,  24,  48, 102, 206, 154,  63,   6,  15,   0,   0),
{173 } (  0,   0,  24,  24,   0,  24,  24,  24,  60,  60,  60,  24,   0,   0,   0,   0),
{174 } (  0,   0,   0,   0,   0,  51, 102, 204, 102,  51,   0,   0,   0,   0,   0,   0),
{175 } (  0,   0,   0,   0,   0, 204, 102,  51, 102, 204,   0,   0,   0,   0,   0,   0),
{176 } ( 17,  68,  17,  68,  17,  68,  17,  68,  17,  68,  17,  68,  17,  68,  17,  68),
{177 } ( 85, 170,  85, 170,  85, 170,  85, 170,  85, 170,  85, 170,  85, 170,  85, 170),
{178 } (221, 119, 221, 119, 221, 119, 221, 119, 221, 119, 221, 119, 221, 119, 221, 119),
{179 } ( 24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24),
{180 } ( 24,  24,  24,  24,  24,  24,  24, 248,  24,  24,  24,  24,  24,  24,  24,  24),
{181 } ( 24,  24,  24,  24,  24, 248,  24, 248,  24,  24,  24,  24,  24,  24,  24,  24),
{182 } ( 54,  54,  54,  54,  54,  54,  54, 246,  54,  54,  54,  54,  54,  54,  54,  54),
{183 } (  0,   0,   0,   0,   0,   0,   0, 254,  54,  54,  54,  54,  54,  54,  54,  54),
{184 } (  0,   0,   0,   0,   0, 248,  24, 248,  24,  24,  24,  24,  24,  24,  24,  24),
{185 } ( 54,  54,  54,  54,  54, 246,   6, 246,  54,  54,  54,  54,  54,  54,  54,  54),
{186 } ( 54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54,  54),
{187 } (  0,   0,   0,   0,   0, 254,   6, 246,  54,  54,  54,  54,  54,  54,  54,  54),
{188 } ( 54,  54,  54,  54,  54, 246,   6, 254,   0,   0,   0,   0,   0,   0,   0,   0),
{189 } ( 54,  54,  54,  54,  54,  54,  54, 254,   0,   0,   0,   0,   0,   0,   0,   0),
{190 } ( 24,  24,  24,  24,  24, 248,  24, 248,   0,   0,   0,   0,   0,   0,   0,   0),
{191 } (  0,   0,   0,   0,   0,   0,   0, 248,  24,  24,  24,  24,  24,  24,  24,  24),
{192 } (255, 255, 192, 192, 192, 192, 192, 192, 192, 204, 207, 199, 193, 192, 255, 255),
{193 } (255, 255,   3,   3,  99,  99,  99, 195, 195, 131, 131,   3,   3,   3, 255, 255),
{194 } (  0,   0,   0,   0,   0,   0,   0, 255,  24,  24,  24,  24,  24,  24,  24,  24),
{195 } ( 24,  24,  24,  24,  24,  24,  24,  31,  24,  24,  24,  24,  24,  24,  24,  24),
{196 } (  0,   0,   0,   0,   0,   0,   0, 255,   0,   0,   0,   0,   0,   0,   0,   0),
{197 } ( 24,  24,  24,  24,  24,  24,  24, 255,  24,  24,  24,  24,  24,  24,  24,  24),
{198 } ( 24,  24,  24,  24,  24,  31,  24,  31,  24,  24,  24,  24,  24,  24,  24,  24),
{199 } ( 54,  54,  54,  54,  54,  54,  54,  55,  54,  54,  54,  54,  54,  54,  54,  54),
{200 } ( 54,  54,  54,  54,  54,  55,  48,  63,   0,   0,   0,   0,   0,   0,   0,   0),
{201 } (  0,   0,   0,   0,   0,  63,  48,  55,  54,  54,  54,  54,  54,  54,  54,  54),
{202 } ( 54,  54,  54,  54,  54, 247,   0, 255,   0,   0,   0,   0,   0,   0,   0,   0),
{203 } (  0,   0,   0,   0,   0, 255,   0, 247,  54,  54,  54,  54,  54,  54,  54,  54),
{204 } ( 54,  54,  54,  54,  54,  55,  48,  55,  54,  54,  54,  54,  54,  54,  54,  54),
{205 } (  0,   0,   0,   0,   0, 255,   0, 255,   0,   0,   0,   0,   0,   0,   0,   0),
{206 } ( 54,  54,  54,  54,  54, 247,   0, 247,  54,  54,  54,  54,  54,  54,  54,  54),
{207 } ( 24,  24,  24,  24,  24, 255,   0, 255,   0,   0,   0,   0,   0,   0,   0,   0),
{208 } ( 54,  54,  54,  54,  54,  54,  54, 255,   0,   0,   0,   0,   0,   0,   0,   0),
{209 } (  0,   0,   0,   0,   0, 255,   0, 255,  24,  24,  24,  24,  24,  24,  24,  24),
{210 } (  0,   0,   0,   0,   0,   0,   0, 255,  54,  54,  54,  54,  54,  54,  54,  54),
{211 } ( 54,  54,  54,  54,  54,  54,  54,  63,   0,   0,   0,   0,   0,   0,   0,   0),
{212 } ( 24,  24,  24,  24,  24,  31,  24,  31,   0,   0,   0,   0,   0,   0,   0,   0),
{213 } (  0,   0,   0,   0,   0,  31,  24,  31,  24,  24,  24,  24,  24,  24,  24,  24),
{214 } (  0,   0,   0,   0,   0,   0,   0,  63,  54,  54,  54,  54,  54,  54,  54,  54),
{215 } ( 54,  54,  54,  54,  54,  54,  54, 255,  54,  54,  54,  54,  54,  54,  54,  54),
{216 } ( 24,  24,  24,  24,  24, 255,  24, 255,  24,  24,  24,  24,  24,  24,  24,  24),
{217 } ( 24,  24,  24,  24,  24,  24,  24, 248,   0,   0,   0,   0,   0,   0,   0,   0),
{218 } (  0,   0,   0,   0,   0,   0,   0,  31,  24,  24,  24,  24,  24,  24,  24,  24),
{219 } (255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255),
{220 } (  0,   0,   0,   0,   0,   0,   0, 255, 255, 255, 255, 255, 255, 255, 255, 255),
{221 } (240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240),
{222 } ( 15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15),
{223 } (255, 255, 255, 255, 255, 255, 255,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{224 } (  0,   0,   0,   0,   0, 118, 220, 216, 216, 216, 220, 118,   0,   0,   0,   0),
{225 } (  0,   0, 124, 198, 198, 198, 220, 198, 195, 195, 195, 206,   0,   0,   0,   0),
{226 } (  0,   0, 254, 198, 198, 192, 192, 192, 192, 192, 192, 192,   0,   0,   0,   0),
{227 } (  0,   0,   0,   0, 128, 254, 108, 108, 108, 108, 108, 108,   0,   0,   0,   0),
{228 } (  0,   0,   0, 254, 198,  96,  48,  24,  48,  96, 198, 254,   0,   0,   0,   0),
{229 } (  0,   0,   0,   0,   0, 126, 216, 216, 216, 216, 216, 112,   0,   0,   0,   0),
{230 } (  0,   0,   0,   0, 102, 102, 102, 102, 102, 124,  96,  96, 192,   0,   0,   0),
{231 } (  0,   0,   0,   0, 118, 220,  24,  24,  24,  24,  24,  24,   0,   0,   0,   0),
{232 } (  0,   0,   0, 126,  24,  60, 102, 102, 102,  60,  24, 126,   0,   0,   0,   0),
{233 } (  0,   0,   0,  56, 108, 198, 198, 254, 198, 198, 108,  56,   0,   0,   0,   0),
{234 } (  0,   0,  56, 108, 198, 198, 198, 108, 108, 108, 108, 238,   0,   0,   0,   0),
{235 } (  0,   0,  30,  48,  24,  12,  62, 102, 102, 102, 102,  60,   0,   0,   0,   0),
{236 } (  0,   0,   0,   0,   0, 126, 219, 219, 219, 126,   0,   0,   0,   0,   0,   0),
{237 } (  0,   0,   0,   3,   6, 126, 207, 219, 243, 126,  96, 192,   0,   0,   0,   0),
{238 } (  0,   0,  28,  48,  96,  96, 124,  96,  96,  96,  48,  28,   0,   0,   0,   0),
{239 } (  0,   0,   0, 124, 198, 198, 198, 198, 198, 198, 198, 198,   0,   0,   0,   0),
{240 } (  0,   0,   0,   0, 254,   0,   0, 254,   0,   0, 254,   0,   0,   0,   0,   0),
{241 } (  0,   0,   0,   0,  24,  24, 126,  24,  24,   0,   0, 255,   0,   0,   0,   0),
{242 } (  0,   0,   0,  48,  24,  12,   6,  12,  24,  48,   0, 126,   0,   0,   0,   0),
{243 } (  0,   0,   0,  12,  24,  48,  96,  48,  24,  12,   0, 126,   0,   0,   0,   0),
{244 } (  0,   0,  14,  27,  27,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24),
{245 } ( 24,  24,  24,  24,  24,  24,  24,  24, 216, 216, 216, 112,   0,   0,   0,   0),
{246 } (  0,   0,   0,   0,  24,  24,   0, 126,   0,  24,  24,   0,   0,   0,   0,   0),
{247 } (  0,   0,   0,   0,   0, 118, 220,   0, 118, 220,   0,   0,   0,   0,   0,   0),
{248 } (  0,  56, 108, 108,  56,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{249 } (  0,   0,   0,   0,   0,   0,   0,  24,  24,   0,   0,   0,   0,   0,   0,   0),
{250 } (  0,   0,   0,   0,   0,   0,   0,   0,  24,   0,   0,   0,   0,   0,   0,   0),
{251 } (  0,  15,  12,  12,  12,  12,  12, 236, 108, 108,  60,  28,   0,   0,   0,   0),
{252 } (  0, 216, 108, 108, 108, 108, 108,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{253 } (  0, 112, 152,  48,  96, 200, 248,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{254 } (  0,   0,   0,   0, 124, 124, 124, 124, 124, 124, 124,   0,   0,   0,   0,   0),
{255 } (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0));

  ExtUserFont : Array[0..63, 0..15] Of Byte = (
{  0} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  1} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  2} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  3} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  4} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  5} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  6} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  7} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  8} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{  9} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 10} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 11} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 12} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 13} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 14} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 15} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 16} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 17} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 18} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 19} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 20} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 21} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 22} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 23} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 24} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 25} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 26} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 27} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 28} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 29} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 30} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 31} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 32} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 33} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 34} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 35} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 36} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 37} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 38} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 39} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 40} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 41} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 42} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 43} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 44} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 45} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 46} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 47} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 48} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 49} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 50} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 51} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 52} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 53} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 54} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 55} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 56} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 57} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 58} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 59} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 60} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 61} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 62} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{ 63} (  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0));
