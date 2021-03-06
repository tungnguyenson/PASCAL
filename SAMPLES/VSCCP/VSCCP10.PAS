{
	VSCCP - Very Simple Chinese Chess Program
	Written by Pham Hong Nguyen
	Faculty of Information Technology - Vietnam National University, Hanoi
	Office: 334 Nguyen Trai street, Thanh Xuan District, Hanoi, Vietnam
	Home page: http://www.geocities.com/siliconvalley/grid/6544/
	Email    : phhnguyen@yahoo.com

	Version:
		->	1.0 - basic
			1.1 - add opening book
			1.2 - improve eval function
			1.3 - improve alphabeta search by adding iterative deepening,
				  quiescence, principal variation, history, killer heuristics
			1.4 - add new rules and interface for tournament between 2 programs
				  A tournament can be controled by ROCC (Referee of Chinese Chess)

	Tab size = 4
}

Program Very_Simple_Chinese_Chess_Program_1_0; { BASIC VERSION }
uses Crt;
const
	MAX_PLY		=	4;
	VERSION 	=	'1.0';
	SIZE_X		=	9;
	SIZE_Y		=	10;
	BOARD_SIZE	= 	SIZE_X*SIZE_Y;

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
	SELECT		=	1;

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

	{ For getting information }
	brandtotal: longint = 0; gencount: longint = 0;

type
	move = 		record
					from, dest: byte;
				end;

	gen_rec = 	record
					m: move;
			  	end;

	hist_rec = 	record
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
    inc (nodecount);
	from := m.from; dest := m.dest; MakeMove := piece[dest] = KING;
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
end;


function UpdateNewMove: boolean;
var from, dest: byte;
begin
	from := newmove.from; dest := newmove.dest; UpdateNewMove := piece[dest] = KING;
	piece[dest] := piece[from]; piece[from] := EMPTY;
	color[dest] := color[from]; color[from] := EMPTY;
	DrawCell(from, NORMAL); DrawCell(dest, NORMAL);
end;


(***** EVALUATE *****)
function Eval: integer;
const piecevalue: array[1..7] of integer = (10, 20, 20, 40, 45, 90, 1000);
var i, s: integer;
begin
    s := 0;
	for i := 1 to BOARD_SIZE do
		if color[i] = side then s := s + piecevalue[piece[i]]
		else if color[i] = xside then s := s - piecevalue[piece[i]];
	Eval := s;
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


(***** MAIN BLOCK *****)
Begin
	InitGen; DrawBoard; side := DARK; xside := LIGHT; computerside := DARK;
	repeat
		if side = computerside then ComputerThink
		else if GetHumanMove then break;
		side := xside; xside := 3 - xside;
	until UpdateNewMove;
End.
