{
	VSCCP - Very Simple Chinese Chess Program
	Written by Pham Hong Nguyen
	Faculty of Information Technology - Vietnam National University, Hanoi
	Office: 334 Nguyen Trai street, Thanh Xuan District, Hanoi, Vietnam
	Home page: http://www.geocities.com/siliconvalley/grid/6544/
	Email    : phhnguyen@yahoo.com

	Version:
			1.0 - basic
			1.1 - add opening book
		->	1.2 - improve eval function
			1.3 - improve alphabeta search by adding iterative deepening,
				  quiescence, principal variation, history, killer heuristics
			1.4 - add new rules and interface for tournament between 2 programs
				  A tournament can be controled by ROCC (Referee of Chinese Chess)

	Tab size = 4

	Improve functions: Eval
}

Program Very_Simple_Chinese_Chess_Program_1_2; { IMPROVE EVAL FUNCTION }
uses Crt;
const
	MAX_PLY		=	4;
	VERSION		=	'1.2';
	OPENING_BOOK_FILE_NAME = 'BOOK.DAT';

	SIZE_X		=	9;
	SIZE_Y		=	10;
	BOARD_SIZE	=	SIZE_X*SIZE_Y;

	MOVE_STACK	=	500;
	HIST_STACK	=	50;

	EMPTY		=	0;
	DARK		=	1;
	LIGHT		=	2;

	PAWN		=	1;
	BISHOP		=	2;
	ELEPHAN		=	3;
	KNIGHT		=	4;
	CANNON		=	5;
	ROOK		=	6;
	KING		=	7;

	INFINITY	=	20000;
	NORMAL		= 	0;
	SELECT		=   1;

	(* the board representation and the initial board state *)
	piece: array[1..BOARD_SIZE] of byte = 	(* PAWN, KNIGHT, BISHOP, CANNON, ROOK, KING, or EMPTY *)
		   (6, 4, 3, 2, 7, 2, 3, 4, 6,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 5, 0, 0, 0, 0, 0, 5, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1,
			0, 5, 0, 0, 0, 0, 0, 5, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			6, 4, 3, 2, 7, 2, 3, 4, 6);

	color: array[1..BOARD_SIZE] of byte = 	(* LIGHT, DARK, or EMPTY *)
		   (1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 0, 0, 0, 0, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			2, 0, 2, 0, 2, 0, 2, 0, 2,
			0, 2, 0, 0, 0, 0, 0, 2, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0,
			2, 2, 2, 2, 2, 2, 2, 2, 2);

	materialnumber: array[1..2, 1..7] of byte = ((5, 2, 2, 2, 2, 2, 1), (5, 2, 2, 2, 2, 2, 1));

	{ For getting information }
	brandtotal: longint = 0; gencount: longint = 0;

type
	move =		record
					from, dest: byte;
				end;

	gen_rec =	record
					m: move;
				end;

	hist_rec =	record
					m: move;
					capture: byte;
				end;

Var
	ply, side, xside, computerside: byte;
	newmove: move;
	gen_dat: array[0..MOVE_STACK] of gen_rec;
	gen_begin, gen_end: array[0..HIST_STACK] of integer;
	hist_dat: array[1..HIST_STACK] of hist_rec;
	hdp: integer;
	systicks: longint absolute $40:$6C;		{ Clock counter }
	nodecount, tickstart, tickend: longint;


(***** INTERFACE *****)
procedure MoveTo (x, y: byte);
begin
	gotoxy (5*x-4, 2*y-1);
end;


procedure DrawCell (pos, mode: byte);
const piece_char: string[8] = '+PBENCRK'; (* the piece letters *)
begin
	if color[pos]=DARK then textcolor(13)
	else if color[pos]=LIGHT then textcolor(14)
	else textcolor(7);
	if mode=NORMAL then textbackground(0) else textbackground(1);
	MoveTo(((pos-1) mod 9)+1, (pos+8) div 9); write(piece_char[piece[pos]+1]);
end;


procedure DrawBoard;
var i: integer;
begin
	textcolor(7); textbackground(0); clrscr; gotoxy(1,1);
	writeln('+----+----+----+----+----+----+----+----+  9');
	writeln('|    |    |    | \  |  / |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  8');
	writeln('|    |    |    | /  |  \ |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  7');
	writeln('|    |    |    |    |    |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  6');
	writeln('|    |    |    |    |    |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  5');
	writeln('|                                       |');
	writeln('+----+----+----+----+----+----+----+----+  4');
	writeln('|    |    |    |    |    |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  3');
	writeln('|    |    |    |    |    |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  2');
	writeln('|    |    |    | \  |  / |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  1');
	writeln('|    |    |    | /  |  \ |    |    |    |');
	writeln('+----+----+----+----+----+----+----+----+  0');
	writeln('A    B    C    D    E    F    G    H    I');
	gotoxy(48,1); writeln('VERY SIMPLE CHINESE CHESS PROGRAM');
	gotoxy(50,2); writeln('(C) Pham Hong Nguyen. Ver '+ VERSION);
	gotoxy(1,25); write('Up, Down, Right, Left: cursor move   Enter or Space: select  ESC: escape');

	for i := 1 to BOARD_SIZE do DrawCell(i, NORMAL);
end;


procedure Gen;  forward;

function GetHumanMove: boolean;
const x: byte = 5; y: byte = 5;
var ch: char; selecting, from, t, i: integer;
begin
	GetHumanMove := false; selecting := 0;
	Gen;		 							{ for check legal move only}

	while true do begin
		MoveTo(x, y);
		ch := ReadKey;
		case ch of
		#13, ' ': begin                 		{ Enter or Spacebar }
					t := x + (y-1)*SIZE_X;
					if selecting=0 then begin
						if color[t]=side then begin
							selecting := 1; from := t; DrawCell(t, SELECT);
						end;
					end else begin
						 if t <> from then DrawCell(from, NORMAL);
						 if color[t]=side then begin
							from := t; DrawCell(t, SELECT);
						 end
                   		 else begin
							newmove.from := from; newmove.dest := t;
							for i := gen_begin[ply] to gen_end[ply]-1 do
								if (gen_dat[i].m.from = from) and (gen_dat[i].m.dest = t)then
									exit;
							DrawCell(from, SELECT);
						 end;
                   	end;
				end;

		#27: begin GetHumanMove := true; break; end;	{ ESC }

		#0: begin
				ch := ReadKey;
				case ch of
				#75: if x > 1 then x := x-1 else x := SIZE_X;   { LEFT }
				#77: if x = SIZE_X then x := 1 else x := x+1;	{ RIGHT }
				#72: if y > 1 then y := y-1 else y := SIZE_Y;	{ UP }
				#80: if y = SIZE_Y then y := 1 else y := y+1;	{ DOWN }
				end;
			end;
		end; {case}
	end; {while}
end;


(**** MOVE GENERATE ****)
const
	offset: array[1..7, 1..8] of shortint =
		   ((-1, 1,13, 0, 0, 0, 0, 0),		{ PAWN (for DARK side only) }
			(-12,-14,12,14,0,0,0,0),		{ BISHOP }
			(-28,-24,24,28, 0, 0, 0, 0 ),	{ ELEPHAN }
			(-11,-15,-25,-27,11,15,25,27),	{ KNIGHT }
			(-1, 1,-13,13, 0, 0, 0, 0),		{ CANNON }
			(-1, 1,-13,13, 0, 0, 0, 0),		{ ROOK }
			(-1, 1,-13,13, 0, 0, 0, 0));	{ KING }

	{ big board for checking over border and reconvert into normal board's position }
	mailbox182: array[1..182] of shortint =
		   (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,
			-1,-1,10,11,12,13,14,15,16,17,18,-1,-1,
			-1,-1,19,20,21,22,23,24,25,26,27,-1,-1,
			-1,-1,28,29,30,31,32,33,34,35,36,-1,-1,
			-1,-1,37,38,39,40,41,42,43,44,45,-1,-1,
			-1,-1,46,47,48,49,50,51,52,53,54,-1,-1,
			-1,-1,55,56,57,58,59,60,61,62,63,-1,-1,
			-1,-1,64,65,66,67,68,69,70,71,72,-1,-1,
			-1,-1,73,74,75,76,77,78,79,80,81,-1,-1,
			-1,-1,82,83,84,85,86,87,88,89,90,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1);

	{ convert a new move into big board's position }
	mailbox90: array[1..90] of byte =
			(29, 30, 31, 32, 33, 34, 35, 36, 37,
			 42, 43, 44, 45, 46, 47, 48, 49, 50,
			 55, 56, 57, 58, 59, 60, 61, 62, 63,
			 68, 69, 70, 71, 72, 73, 74, 75, 76,
			 81, 82, 83, 84, 85, 86, 87, 88, 89,
			 94, 95, 96, 97, 98, 99,100,101,102,
			107,108,109,110,111,112,113,114,115,
			120,121,122,123,124,125,126,127,128,
			133,134,135,136,137,138,139,140,141,
			146,147,148,149,150,151,152,153,154);

	{ for checking a piece could stay in a position or not }
	legalpositon: array[1..90] of byte =
		   (1, 1, 5, 3, 3, 3, 5, 1, 1,
			1, 1, 1, 3, 3, 3, 1, 1, 1,
			5, 1, 1, 3, 7, 3, 1, 1, 5,
			1, 1, 1, 1, 1, 1, 1, 1, 1,
			9, 1,13, 1, 9, 1,13, 1, 9,
			9, 9, 9, 9, 9, 9, 9, 9, 9,
			9, 9, 9, 9, 9, 9, 9, 9, 9,
			9, 9, 9, 9, 9, 9, 9, 9, 9,
			9, 9, 9, 9, 9, 9, 9, 9, 9,
			9, 9, 9, 9, 9, 9, 9, 9, 9);

	maskpiece: array[1..7] of byte = (8, 2, 4, 1, 1, 1, 2); { used for legalpositon }
	knightcheck:  array[1..8] of shortint = (1,-1,-9,-9,-1,1,9,9);
	elephancheck: array[1..8] of shortint = (-10,-8,8,10,0,0,0,0);
	kingpalace: array[1..9] of byte = (4,5,6,13,14,15,22,23,24); {,(67,68,69,76,77,78,85,86,87));}


procedure InitGen;
begin
	gen_end[0] := 0; gen_begin[0] := 0; ply := 0; hdp := 1;
end;


function KingFace (from, dest: integer): boolean;
var i, k, t: integer;
begin
	kingface := false; i := from mod 9;
	if (i>=4) and (i<=6) and (piece[dest]<>KING) then begin
		t := piece[dest]; piece[dest] := piece[from]; piece[from] := EMPTY;
		i := 1; repeat k := kingpalace[i]; inc(i); until piece[k]=KING;
		k := k + SIZE_X;
		while (k < BOARD_SIZE) and (piece[k] = EMPTY) do k := k + SIZE_X;
		if piece[k]=KING then kingface := true;
		piece[from] := piece[dest]; piece[dest] := t;
	end;
end;


procedure Gen_push (from, dest: byte);
begin
	if not KingFace(from, dest) then begin
		gen_dat[gen_end[ply]].m.from := from;
		gen_dat[gen_end[ply]].m.dest := dest;
		inc(gen_end[ply]);
	end;
end;


procedure Gen;
var i, j, k, n, p, x, y, t, fcannon: integer;
begin
	gen_end[ply] := gen_begin[ply];

	for i := 1 to BOARD_SIZE do             { scan board all }
		if color[i] = side then begin
			p := piece[i];
			for j := 1 to 8 do begin        { for all directions }
				if offset[p, j] = 0 then break;
				fcannon := 0;
				x := mailbox90[i];          { convert into big board's position }
				if p in [ROOK, CANNON] then n := 9 else n := 1;
				for k := 1 to n do begin
					if (p=PAWN)and(side=LIGHT) then x := x - offset[p, j]
					else x := x + offset[p, j];
					y := mailbox182[x];     { reconvert into normal board }
					if side = DARK then t := y else t := 91 - y;
					if (y=-1) or ((legalpositon[t] and maskpiece[p])=0) then break;
					if fcannon = 0 then begin
						if color[y] <> side then begin
							case p of
							KNIGHT: if color[i+knightcheck[j]]=EMPTY then gen_push(i, y);
							ELEPHAN:if color[i+elephancheck[j]]=EMPTY then gen_push(i, y);
							CANNON: if color[y] = EMPTY  then gen_push(i, y);
							else gen_push(i, y);
							end;
						end;
						if color[y]<>EMPTY then begin if p=CANNON then fcannon := 1 else break; end;
					end
					else begin	{ CANNON case }
						if color[y] <> EMPTY then begin
							if color[y] = xside then gen_push(i, y);
							break;
						end;
					end;
				end; { for k }
			end; { for j}
	end;

	gen_end[ply+1] := gen_end[ply]; gen_begin[ply+1] := gen_end[ply];
	brandtotal := brandtotal + gen_end[ply] - gen_begin[ply]; inc(gencount);
end;


(***** MOVE *****)
function MakeMove (m: move): boolean;
var from, dest: integer;
begin
    inc(nodecount);
	from := m.from; dest := m.dest; MakeMove := piece[dest] = KING;
	if piece[dest] <> EMPTY then dec(materialnumber[xside, piece[dest]]);
	hist_dat[hdp].m := m; hist_dat[hdp].capture := piece[dest];
	piece[dest] := piece[from]; piece[from] := EMPTY;
	color[dest] := color[from]; color[from] := EMPTY;
	inc(hdp); inc(ply); side := xside; xside := 3 - xside;
end;


procedure UnMakeMove;
var from, dest: byte;
begin
	dec(hdp); dec(ply); side := xside; xside := 3 - xside;
	from := hist_dat[hdp].m.from; dest := hist_dat[hdp].m.dest;
	piece[from] := piece[dest]; color[from] := color[dest];
	piece[dest] := hist_dat[hdp].capture;
	if piece[dest] = EMPTY then color[dest] := EMPTY else color[dest] := xside;
	if piece[dest] <> EMPTY then inc(materialnumber[xside, piece[dest]]);
end;


function UpdateNewMove: boolean;
var from, dest: byte;
begin
	from := newmove.from; dest := newmove.dest; UpdateNewMove := piece[dest] = KING;
	if piece[dest] <> EMPTY then dec(materialnumber[side, piece[dest]]);
	piece[dest] := piece[from]; piece[from] := EMPTY;
	color[dest] := color[from]; color[from] := EMPTY;
	DrawCell(from, NORMAL); DrawCell(dest, NORMAL);
end;


(***** EVALUATE *****)
function Bonous: integer;
const pn: array[0..6] of integer = (0,-2, -3, -3, -4, -4, -5); { There is not King }
var bn: array[1..2, 0..6] of integer; i, s: integer;
begin
	for i := 0 to 6 do begin bn[DARK, i] := pn[i]; bn[LIGHT, i] := pn[i]; end;

	for i := 1 to 2 do begin			{ Scan DARK and LIGHT }
		if materialnumber[i, BISHOP] < 2 then begin
			inc(bn[3-i, ROOK], 4);
			inc(bn[3-i, KNIGHT], 2);
			inc(bn[3-i, PAWN], 1);
		end;

		if materialnumber[i, ELEPHAN] < 2 then begin
			inc(bn[3-i, ROOK], 2);
			inc(bn[3-i, CANNON], 2);
			inc(bn[3-i, PAWN], 1);
		end;
	end;

	if (color[1]=DARK) and (color[2]=DARK) and (piece[1]=ROOK) and (piece[2]=KNIGHT) then
		dec(bn[DARK, 0], 10);
	if (color[8]=DARK) and (color[9]=DARK) and (piece[9]=ROOK) and (piece[8]=KNIGHT) then
		dec(bn[DARK, 0], 10);
	if (color[82]=LIGHT) and (color[83]=LIGHT) and (piece[82]=ROOK) and (piece[83]=KNIGHT) then
		dec(bn[LIGHT, 0], 10);
	if (color[89]=LIGHT) and (color[90]=LIGHT) and (piece[90]=ROOK) and (piece[89]=KNIGHT) then
		dec(bn[LIGHT, 0], 10);

	s := bn[side, 0] - bn[xside, 0];
	for i := 1 to 6 do
		s := s  +	materialnumber[side,  i] * bn[side,  i]
				-	materialnumber[xside, i] * bn[xside, i];
	Bonous := s;
end;


function Eval: integer;
const
	pointtable: array[1..7, 1..2, 1..90] of byte =
	 (((0,  0,  0,  0,  0,  0,  0,  0,  0, 			{ DARK PAWN }
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
	   10,  0, 12,  0, 15,  0, 12,  0, 10,
	   10,  0, 13,  0, 10,  0, 13,  0, 10,
	   20, 20, 20, 20, 20, 20, 20, 20, 20,
	   20, 21, 21, 22, 22, 22, 21, 21, 20,
	   20, 21, 21, 23, 23, 23, 21, 21, 20,
	   20, 21, 21, 23, 22, 23, 21, 21, 20,
	   11, 12, 13, 14, 14, 14, 13, 12, 11),

	  (11, 12, 13, 14, 14, 14, 13, 12, 11,          { LIGHT PAWN }
	   20, 21, 21, 23, 22, 23, 21, 21, 20,
	   20, 21, 21, 23, 23, 23, 21, 21, 20,
	   20, 21, 21, 22, 22, 22, 21, 21, 20,
	   20, 20, 20, 20, 20, 20, 20, 20, 20,
	   10,  0, 13,  0, 10,  0, 13,  0, 10,
	   10,  0, 12,  0, 15,  0, 12,  0, 10,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0)),

	  ((0,  0,  0, 20,  0, 20,  0,  0,  0, 			{ DARK BISHOP }
		0,  0,  0,  0, 22,  0,  0,  0,  0,
		0,  0,  0, 19,  0, 19,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0),

	   (0,  0,  0,  0,  0,  0,  0,  0,  0,          { LIGHT BISHOP }
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0, 19,  0, 19,  0,  0,  0,
		0,  0,  0,  0, 22,  0,  0,  0,  0,
		0,  0,  0, 20,  0, 20,  0,  0,  0)),

	  ((0,  0, 25,  0,  0,  0, 25,  0,  0, 			{ DARK ELEPHAN }
		0,  0,  0,  0,  0,  0,  0,  0,  0,
	   23,  0,  0,  0, 28,  0,  0,  0, 23,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 22,  0,  0,  0, 22,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0),

	   (0,  0,  0,  0,  0,  0,  0,  0,  0,          { LIGHT ELEPHAN }
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 22,  0,  0,  0, 22,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
	   23,  0,  0,  0, 28,  0,  0,  0, 23,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 25,  0,  0,  0, 25,  0,  0)),

	  ((40, 35, 40, 40, 40, 40, 40, 35, 40, 		{ DARK KNIGHT }
		40, 41, 42, 40, 20, 40, 42, 41, 40,
		40, 42, 43, 40, 40, 40, 43, 42, 40,
		40, 42, 43, 43, 43, 43, 43, 42, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 41, 42, 42, 42, 42, 42, 41, 40,
		40, 40, 40, 40, 40, 40, 40, 40, 40),

	   (40, 40, 40, 40, 40, 40, 40, 40, 40, 		{ LIGHT KNIGHT }
		40, 41, 42, 42, 42, 42, 42, 41, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 42, 43, 43, 43, 43, 43, 42, 40,
		40, 42, 43, 40, 40, 40, 43, 42, 40,
		40, 41, 42, 40, 20, 40, 42, 41, 40,
		40, 35, 40, 40, 40, 40, 40, 35, 40)),

	  ((50, 50, 50, 50, 50, 50, 50, 50, 50, 		{ DARK CANNON }
		50, 50, 50, 50, 50, 50, 50, 50, 50,
		50, 51, 53, 53, 55, 53, 53, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 51, 51, 51, 51, 51, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50),

	   (50, 50, 50, 50, 50, 50, 50, 50, 50, 		{ LIGHT CANNON }
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 51, 51, 51, 51, 51, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 53, 53, 55, 53, 53, 51, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50)),


	  ((89, 92, 90, 90, 90, 90, 90, 92, 89, 		{ DARK ROOK }
		91, 92, 90, 93, 90, 93, 90, 92, 91,
		90, 92, 90, 91, 90, 91, 90, 92, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 94, 90, 94, 90, 94, 90, 94, 90,
		90, 93, 90, 91, 90, 91, 90, 93, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 91, 90, 90, 90, 90, 90, 91, 90,
		90, 92, 91, 91, 90, 91, 91, 92, 90,
		90, 90, 90, 90, 90, 90, 90, 90, 90),

	   (90, 90, 90, 90, 90, 90, 90, 90, 90, 		{ LIGHT ROOK }
		90, 92, 91, 91, 90, 91, 91, 92, 90,
		90, 91, 90, 90, 90, 90, 90, 91, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 93, 90, 91, 90, 91, 90, 93, 90,
		90, 94, 90, 94, 90, 94, 90, 94, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 92, 90, 91, 90, 91, 90, 92, 90,
		91, 92, 90, 93, 90, 93, 90, 92, 91,
		89, 92, 90, 90, 90, 90, 90, 92, 89)),

	  ((0,  0,  0, 30, 35, 30,  0,  0,  0, 			{ DARK KING }
		0,  0,  0, 15, 15, 15,  0,  0,  0,
		0,  0,  0,  1,  1,  1,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0),

	   (0,  0,  0,  0,  0,  0,  0,  0,  0,          { LIGHT KING }
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  1,  1,  1,  0,  0,  0,
		0,  0,  0, 15, 15, 15,  0,  0,  0,
		0,  0,  0, 30, 35, 30,  0,  0,  0)));
var i, s: integer;
begin
	s := 0;
	for i := 1 to BOARD_SIZE do
		if color[i] = DARK then s := s + pointtable[piece[i], DARK, i]
		else if color[i] = LIGHT then s := s - pointtable[piece[i], LIGHT, i];;
	if side = LIGHT then s := -s;
	Eval := s + Bonous;
end;


(***** SEARCH *****)
{ Search game tree by alpha-beta algorith }
function AlphaBeta (alpha, beta: integer; depth: byte): integer;
var i, best, value: integer;
begin
	if depth = 0 then AlphaBeta := Eval
	else begin
		Gen; best := -INFINITY; i := gen_begin[ply];
		while (i < gen_end[ply]) and (best < beta) do begin
			if best > alpha then alpha := best;

			if MakeMove(gen_dat[i].m) then value := 1000-ply { by subtration for ply, computer could find the longest way to lose }
			else value := -AlphaBeta(-beta, -alpha, depth-1);
			UnMakeMove;

			if value > best then begin
				best := value; if ply = 0 then newmove := gen_dat[i].m;
			end;
			inc (i);
		end; { while }

		AlphaBeta := best;
	end;
end;


(***** THINK *****)
{ Call AlphaBeta function and display some information }
procedure ComputerThink;
var best: integer;
begin
	tickstart := systicks; nodecount := 0;
	best := AlphaBeta(-INFINITY, INFINITY, MAX_PLY);
	tickend := systicks;

	{ Display some information }
	textcolor(7);
	gotoxy(50, 4); write('Depth            : ', MAX_PLY);
	gotoxy(50, 5); write('Node total       : ', nodecount, '  ');
	gotoxy(50, 6); write('Brand factor     : ', brandtotal/gencount:3:2, '  ');
	gotoxy(50, 7); write('Time (second)    : ', (tickend-tickstart)/18.23:0:2, '  ');
	gotoxy(50, 8); write('Nodes per second : ', nodecount*18.23/(tickend-tickstart+1):0:0, '  ');
	gotoxy(50, 9); write('Score            : ', best, '  ');
	gotoxy(50,11); write('Computer move    : ', chr(((newmove.from-1) mod SIZE_X)+65),SIZE_X-(newmove.from-1) div SIZE_X,
											    chr(((newmove.dest-1) mod SIZE_X)+65),SIZE_X-(newmove.dest-1) div SIZE_X, '  ');
end;


(***** OPENING BOOK *****)
{
	When you have a move's line, it may be not in opening book but
	one of its symmetry is in. So you have to convert move's line into all
	symmetrical forms. There are 4 symmetrical forms as following:
		(1) normal move
		(2) vertical axial symmetry
		(3) horizontal axial symmetry
		(4) central symmetry
	After finding out a symmetry in opening book, you can get a new move
	and convert it into normal move.
}
function FollowBook: boolean;
type
	tp = ^node;
	node = record	{ Book data will be saved in single linked list }
				line: array[1..52] of byte;
				len: byte;
				next: tp;
		   end;
var
	book, t1, t2: tp;
	ss: array[1..4, 1..52] of byte; { save 4 symmetrical kinds of line }
	nm,                 			{ working pointer of line }
	i: byte;
	f: text;

function Readbook: boolean;
var i, len: integer; s: string; line: array[1..52] of byte;
begin
	{$I-} Assign(f, OPENING_BOOK_FILE_NAME); Reset(F); {$I+}
	if IOResult <> 0 then begin Readbook:= false; exit; end;

	book := nil;
	while not Eof(F) do
	begin
		readln(f, s); i:=1; len := 0;
		{ Convert string into position }
		while (i <= length(s)) and (s[i] <> ';') do
			if s[i] <> ' ' then begin
				inc(len);
				line[len] := ord(s[i])-64 + (SIZE_X-ord(s[i+1])+48)*SIZE_X;
				inc(i, 2);
			end else inc(i);

		if len > 0 then begin { save in single linked list }
			New(t1); t1^.next := nil; t1^.len := len;
			for i:=1 to len do t1^.line[i] := line[i];
			if book = nil then book := t1 else t2^.next := t1;
			t2 := t1;
		end;
	end;
	Close(F); Readbook := true;
end;


procedure DelBook;
begin
	t1 := book; t2 := book^.next;
	while t1 <> nil do begin Dispose(t1); t1 := t2; t2 := t2^.next; end;
end;


{ Convert a position into a symmetrical position }
function SymmetricConvert(m, k: integer): byte;
begin
	case k of
		1: SymmetricConvert := m;
		2: SymmetricConvert := ((m-1) div SIZE_X)*SIZE_X + SIZE_X-((m-1) mod SIZE_X);
		3: SymmetricConvert := m + (SIZE_X - 2*((m-1) div SIZE_X))*SIZE_X;
		4: SymmetricConvert := BOARD_SIZE+1 - m;
	end;
end;


{ Search opening book list for one of symmetrical lines. If it is found,
  get new move and convert it into normal move by the symmetrical kind. }
function Getbook: boolean;
var i, j, sk: byte; b, g: boolean;			{ sk: symmetrical kind }
begin
	g := false; t1 := book;

	{ Computer go first }
	if nm = 0 then begin
		if computerside = DARK then sk := 3 else sk := 1; j := 1; g := true;
	end else
		while t1 <> nil do begin
			if nm < t1^.len then begin
				sk := 0;
				repeat
					b := true; inc(sk);
					for j := 1 to nm do
						if ss[sk, j] <> t1^.line[j] then b := false;
				until (sk > 4) or b;

				if b then begin inc(j); g := true; break; end;
			end;
			t1 := t1^.next;
		end;

	{ Convert new move into normal }
	if g then begin
		newmove.from := SymmetricConvert(t1^.line[j], sk);
		newmove.dest  := SymmetricConvert(t1^.line[j+1], sk);
	end;
	GetBook := g;
end;

begin { FollowBook }
	FollowBook := false; nm := 0;
	if not Readbook then exit;

	repeat
		if side = computerside then begin
			if not GetBook then break;
			gotoxy(50,11); write('Computer move    : ', chr(((newmove.from-1) mod SIZE_X)+65),SIZE_X-(newmove.from-1) div SIZE_X,
											    		chr(((newmove.dest-1) mod SIZE_X)+65),SIZE_X-(newmove.dest-1) div SIZE_X, '  ');
		end
		else if GetHumanMove then
			 begin FollowBook := true; break; end; { break when ESC is pressed }

		{ Save 4 symmetrical forms }
		for i := 1 to 4 do begin
			ss[i, nm+1] := SymmetricConvert(newmove.from, i);
			ss[i, nm+2] := SymmetricConvert(newmove.dest, i);
		end;

		nm := nm + 2;
		side := xside; xside := 3 - xside;

		if UpdateNewMove then halt;
	until false;

	Delbook;
end;


(***** MAIN BLOCK *****)
Begin
	InitGen; DrawBoard; side := DARK; xside := LIGHT; computerside := DARK;

	if not FollowBook then
	repeat
		if side = computerside then ComputerThink
		else if GetHumanMove then break;
		side := xside; xside := 3 - xside;
	until UpdateNewMove;
End.
