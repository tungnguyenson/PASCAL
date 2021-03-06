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
			1.2 - improve eval function
			1.3 - improve alphabeta search by adding iterative deepening,
				  quiescence, principal variation, history, killer heuristics
		->	1.4 - add new rules and interface for tournament between 2 programs
				  A tournament can be controled by ROCC (Referee of Chinese Chess)

	Tab size = 4
}

Program Very_Simple_Chinese_Chess_Program_1_4; { FOR TOURNAMENT }
uses Crt;
const
	MAX_PLY	=   4;
    VERSION =   '1.4';

	OPENING_BOOK_FILE_NAME = 'BOOK.DAT';
	REPORT_FILE_NAME = 'REPORT.TXT';

	SIZE_X	=	9;
	SIZE_Y	=	10;
	BOARD_SIZE= SIZE_X*SIZE_Y;

	MOVE_STACK	=	500;
	HIST_STACK	=	50;
	MAX_MOVE	=	800;

	EMPTY	=	0;
	DARK	=	1;
	LIGHT	=	2;

	PAWN	=	1;
	BISHOP	=	2;
	ELEPHAN	=	3;
	KNIGHT	=	4;
	CANNON	=	5;
	ROOK	=	6;
	KING	=	7;

	INFINITY=	20000;
	NORMAL	= 	0;
	SELECT	=   1;

	MOVETIME = 18*60*3;

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
	capbrandtotal: longint = 0; capgencount: longint = 1;

type
	move = record
				from, dest: byte;
			end;

	gen_rec = record
				m: move;
				prior: integer;
			  end;

	hist_rec = record
				m: move;
				capture: byte;
			   end;

Var
	ply, side, xside, myside: byte;
	newmove: move;
	gen_dat: array[0..MOVE_STACK] of gen_rec;
	gen_begin, gen_end: array[0..HIST_STACK] of integer;
	hist_dat: array[1..MAX_MOVE] of hist_rec;
	hdp: integer;
	history: array[1..BOARD_SIZE, 1..BOARD_SIZE] of byte;
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
	if color[pos] = DARK then textcolor(13)
	else if color[pos] = LIGHT then textcolor(14)
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
	gotoxy(1,25); write('Up, Down, Right, Left: cursor move   Enter: select  ESC: escape  BkSpace: undo');

	for i := 1 to BOARD_SIZE do DrawCell(i, NORMAL);
end;


{ New function: undo }
function Gen: boolean; forward;
procedure UnMakeMove; forward;

function GetHumanMove: boolean;
const x: byte = 5; y: byte = 5;
var ch: char; selecting, from, t, i: integer;
begin
	GetHumanMove := false; selecting := 0;
	if not Gen then begin		 				{ for check legal move only}
		newmove.from := 0; newmove.dest := 0; exit;
	end;

	while true do begin
		MoveTo(x, y);
		ch := ReadKey;
		case ch of
        #8: if hdp >1 then begin
                if selecting<>0 then DrawCell(from, NORMAL); selecting := 0;
				UnMakemove; DrawCell(hist_dat[hdp].m.from, NORMAL); DrawCell(hist_dat[hdp].m.dest, NORMAL);
                UnMakemove; DrawCell(hist_dat[hdp].m.from, NORMAL); DrawCell(hist_dat[hdp].m.dest, NORMAL);
                ply := 0; Gen;
            end;

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
	if newmove.from = 0 then begin UpdateNewMove := true; exit; end;
	from := newmove.from; dest := newmove.dest; UpdateNewMove := piece[dest] = KING;
	hist_dat[hdp].m := newmove; hist_dat[hdp].capture := piece[dest]; inc(hdp);
	if piece[dest] <> EMPTY then dec(materialnumber[side, piece[dest]]);
	piece[dest] := piece[from]; piece[from] := EMPTY;
	color[dest] := color[from]; color[from] := EMPTY;
	DrawCell(from, NORMAL); DrawCell(dest, NORMAL);
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
	kingpalace: array[1..2, 1..9] of byte = ((4,5,6,13,14,15,22,23,24),(67,68,69,76,77,78,85,86,87));


procedure InitGen;
begin
	gen_end[0] := 0; gen_begin[0] := 0; ply := 0; hdp := 1;
end;


function Attack (pos, side: byte): boolean;
const knightcheck2:  array[1..8] of shortint = (-8,-10,-8,-10,8,10,8,10);
var i, j, k, x, y, t, fcannon: integer; sd, xsd: byte; b: boolean;
begin
	b := false; sd := side; xsd := 3 - sd;
	for j := 1 to 4 do begin			{ ROOK, CANNON, PAWN, KING }
		x := mailbox90[pos]; fcannon := 0;
		for k := 1 to 9 do begin
			x := x + offset[ROOK, j]; y := mailbox182[x]; if y = -1 then break;
			if fcannon = 0 then begin
				if color[y] = xsd then
					case piece[y] of
					ROOK: b := true;
					KING: if piece[pos]=KING then b := true;
					PAWN: if (k=1) and
							(((sd=DARK)and(j<>3)) or
							 ((sd=LIGHT)and(j<>4))) then b := true;
					end;
				if color[y] <> EMPTY then fcannon := 1;
			end else 	{ CANNON case }
				if color[y] <> EMPTY then begin
					if (color[y]=xsd)and(piece[y]=CANNON) then b := true;
					break;
				end;
			if b then break;
		end; { for k }
		if b then break;
	end; { for j}

	if not b then
	for j := 1 to 8 do begin				{ Knight Check }
		y := mailbox182[mailbox90[pos] + offset[KNIGHT, j]]; if y = -1 then continue;
		if (color[y]=xsd)and(piece[y]=KNIGHT)and(color[pos+knightcheck2[j]]=EMPTY) then
		begin b := true; break; end;
	end;

	if sd = DARK then t := pos else t := 91 - pos;

	if not (b or (piece[pos] in [ELEPHAN,BISHOP,KING])) then begin
		if (legalpositon[t] and maskpiece[ELEPHAN])<>0 then
		for j := 1 to 4 do begin				{ Elephan Check }
			y := mailbox182[mailbox90[pos] + offset[ELEPHAN, j]]; if y = -1 then continue;
			if (color[y]=xsd)and(piece[y]=ELEPHAN)and(color[pos+elephancheck[j]]=EMPTY) then
			begin b := true; break; end;
		end;

		if (not b) and ((legalpositon[t] and maskpiece[BISHOP])<>0) then
		for j := 1 to 4 do begin				{ Bishop Check }
			y := mailbox182[mailbox90[pos] + offset[BISHOP, j]]; if y = -1 then continue;
			if (color[y]=xsd)and(piece[y]=BISHOP) then
			begin b := true; break; end;
		end;

		if (not b) and ((legalpositon[t] and maskpiece[KING])<>0) then
		for j := 1 to 4 do begin				{ King Check }
			y := mailbox182[mailbox90[pos] + offset[KING, j]]; if y = -1 then continue;
			if (color[y]=xsd)and(piece[y]=KING) then
			begin b := true; break; end;
		end;

	end;
	Attack := b;
end;


function IsInCheck (side: byte): boolean;
var i, pos: integer;
begin
	i := 1; repeat pos := kingpalace[side, i]; inc(i); until piece[pos] = KING;
	IsInCheck := Attack(pos, side);
end;


{ not allow a move that makes a same position in last 30 positions }
function CheckMoveLoop: boolean;
const MAXREP = 30;
var hdmap: array [1..MAXREP] of byte; c, f, i, j, k, m, p: integer;
	cm: move; b, canfa: boolean;
begin
	CheckMoveLoop := false;

	{ if one side has not any attack pieces, it can make any move }
	if (hdp < 3) or
	   (materialnumber[xside, ROOK] + materialnumber[xside, CANNON] +
		materialnumber[xside, KNIGHT] + materialnumber[xside, PAWN] = 0) then exit;

	for i := 1 to MAXREP do hdmap[i] := 0;
	if hdp-1 > MAXREP then m := MAXREP else m := hdp-1;
	c := 0; i := 1; k := 0;

	while i <= m do begin
		if hist_dat[hdp-i].capture <> EMPTY then break
		else if hdmap[MAXREP+1-i] = 0 then begin
			inc (c); hdmap[MAXREP+1-i] := c;
			p := hist_dat[hdp-i].m.dest; f := hist_dat[hdp-i].m.from;

			j := i+1;
			while j <= m do begin
				if f = hist_dat[hdp-j].m.dest then begin
					f := hist_dat[hdp-j].m.from;
					hdmap[MAXREP+1-j] := c;
					if p = f then begin
						if k < j then k := j;
						break;
					end;
				end; { if f = }
				inc (j);
			end; { while j<=m }

			if j > m then break;
		end; { if hdmap }
		inc (i);

		if (i>2) and (i=k) then begin
			CheckMoveLoop := true;
			b := Attack (hist_dat[hdp-1].m.dest, xside);
			if not b then begin
				cm := hist_dat[hdp-1].m; UnMakeMove;
				b := Attack (cm.from, side);
				Makemove (cm);
				if b then CheckMoveLoop := false;
			end;
			exit;
		end;
	end;
end;


function MoveSave (from, dest: byte): boolean;
var b: boolean; ms: move;
begin
	if piece[dest] = KING then MoveSave := true
	else begin
		ms.from := from; ms.dest := dest;
  		MakeMove (ms); dec(nodecount);
		b := IsInCheck (xside);
    	if not b then b := CheckMoveLoop;
		UnMakeMove;
		MoveSave := not b;
	end;
end;


procedure Gen_push(from, dest: byte);
begin
	if MoveSave (from, dest) then begin
		gen_dat[gen_end[ply]].m.from := from;
		gen_dat[gen_end[ply]].m.dest := dest;
		if piece[dest]<>EMPTY then
			 gen_dat[gen_end[ply]].prior := piece[dest]*100 - piece[from]
		else gen_dat[gen_end[ply]].prior := history[from, dest];
		inc(gen_end[ply]);
	end;
end;


function Gen: boolean;
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
	Gen := gen_end[ply] > gen_begin[ply];
end;


{ Generate all capture moves }
function GenCapture: boolean;
var i, j, k, n, p, x, y, t, fcannon: integer;
begin
	gen_end[ply] := gen_begin[ply];

	for i := 1 to BOARD_SIZE do
		if color[i] = side then begin
			p := piece[i];
			for j := 1 to 8 do begin
				if offset[p, j] = 0 then break;
				x := mailbox90[i]; fcannon := 0;
				if p in [ROOK, CANNON] then n := 9 else n := 1;
				for k := 1 to n do begin
					if (p=PAWN) and (side=LIGHT) then x := x - offset[p, j]
					else x := x + offset[p, j];
					y := mailbox182[x];
					if side = DARK then t := y else t := 91-y;
					if (y=-1) or ((legalpositon[t] and maskpiece[p])=0) then break;
					if fcannon = 0 then begin
						if color[y] <> side then begin
							case p of
							KNIGHT: if (color[i+knightcheck[j]]=EMPTY) and (color[y]=xside) then gen_push(i, y);
							ELEPHAN:if (color[i+elephancheck[j]]=EMPTY) and (color[y]=xside) then gen_push(i, y);
							CANNON: ;
							else if color[y]=xside then gen_push(i, y);
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
	capbrandtotal := capbrandtotal + gen_end[ply] - gen_begin[ply];
    if gen_end[ply] > gen_begin[ply] then inc(capgencount);
	GenCapture := gen_end[ply] > gen_begin[ply];
end;


(***** EVALUATE *****)
function Bonous: integer;
const pn: array[1..6] of integer = (-2, -3, -3, -4, -4, -5); { There is not King }
var bn: array[1..2, 0..6] of integer; i, j, s: integer;
begin
	bn[1, 0] := 0; bn[2, 0] := 0;
	for i := 1 to 6 do begin bn[1, i] := pn[i]; bn[2, i] := pn[i]; end;

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
var mply: byte; follow_pv: boolean;
    pv: array[0..HIST_STACK, 0..HIST_STACK] of move;
    pv_length: array[0..HIST_STACK] of integer;

procedure Check_pv;
var i: integer;
begin
	follow_pv := false;
	for i:=gen_begin[ply] to gen_end[ply] do
		if (gen_dat[i].m.from = pv[0, ply].from) and
		   (gen_dat[i].m.dest = pv[0, ply].dest) then begin
			follow_pv := true; inc(gen_dat[i].prior, 1000); exit;
		end;
end;


procedure Quicksort(q, r: integer);
var i, j, x: integer; g: gen_rec;
begin
	i := q; j := r; x := gen_dat[(q+r) div 2].prior;

	repeat
		while gen_dat[i].prior > x do inc(i);
		while gen_dat[j].prior < x do dec(j);
		if i <= j then begin
			g := gen_dat[i]; gen_dat[i] := gen_dat[j]; gen_dat[j] := g;
			inc(i); dec(j);
		end;
	until i > j;

	if q < j then quicksort(q, j); if i < r then quicksort(i, r);
end;


procedure Sort;
begin
	 Quicksort(gen_begin[ply], gen_end[ply]-1);
end;


function Quiescence(alpha, beta: integer): integer;
var i, j, best, value: integer;
begin
	if mply < ply then begin mply := ply;
		gotoxy(50, 13); write('Quiesce depth    : ', mply, '  ');
	end;

	value := Eval;
	if value >= beta then begin Quiescence := value; exit; end;
	if value > alpha then alpha := value;

	if not GenCapture then begin
		if not IsInCheck(side) then begin Quiescence := value; exit; end
		else if not Gen then begin Quiescence := -1000 + ply; exit; end;
	end;

	if follow_pv then Check_pv; Sort;
	best := value; i := gen_begin[ply];
    pv_length[ply] := ply;

	while (i < gen_end[ply]) and (best < beta) and (systicks-tickstart <= MOVETIME) do begin
		if best > alpha then alpha := best;

		if MakeMove(gen_dat[i].m) then value := 1000 - ply
		else value := -Quiescence(-beta, -alpha);
		UnMakeMove;

		if value > best then begin
			best := value;
            for j := ply+1 to pv_length[ply+1] do
                pv[ply, j] := pv[ply+1, j];
            pv_length[ply] := pv_length[ply+1];
		end;
		inc (i);
	end; { while }

	Quiescence := best;
end;


{ Search game tree by alpha-beta algorith }
function AlphaBeta (alpha, beta: integer; depth: byte): integer;
var i, j, best, value: integer;
begin
	if depth = 0 then AlphaBeta := Quiescence(alpha, beta)
	else begin
		if not Gen then begin AlphaBeta := -1000 + ply; exit; end;

		if follow_pv then Check_pv; Sort;
		best := -INFINITY; i := gen_begin[ply];
        pv_length[ply] := ply;

		while (i < gen_end[ply]) and (best < beta) and (systicks-tickstart <= MOVETIME) do begin
			if best > alpha then alpha := best;

			if MakeMove(gen_dat[i].m) then value := 1000 - ply { by subtration for ply, coputer could find the longest way to lose }
			else value := -AlphaBeta(-beta, -alpha, depth-1);
			UnMakeMove;

			if value > best then begin
				history[gen_dat[i].m.from, gen_dat[i].m.dest] := depth;
				best := value; if ply = 0 then newmove := gen_dat[i].m;
                pv[ply, ply] := gen_dat[i].m;
                for j := ply+1 to pv_length[ply+1] do
                    pv[ply, j] := pv[ply+1, j];
                pv_length[ply] := pv_length[ply+1];
			end;
			inc (i);
		end; { while }

		AlphaBeta := best;
	end;
end;


(***** THINK *****)
{ Call AlphaBeta function and display some information }
procedure ComputerThink;
var best, d, i, j: integer; newmovesave: move;
begin
	tickstart := systicks; nodecount := 0; mply := MAX_PLY;
	for i := 1 to BOARD_SIZE do
		for j := 1 to BOARD_SIZE do history[i, j] := 0;

	d := 1; newmove.from := 0;
	repeat
		follow_pv := true; newmovesave := newmove;
		best := AlphaBeta(-INFINITY, INFINITY, d);
		inc (d);
	until (d > MAX_PLY) or (systicks-tickstart > MOVETIME);

	if systicks-tickstart > MOVETIME then newmove := newmovesave;
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
	gotoxy(50, 13);write('Quiesce depth    : ', mply);
	gotoxy(50, 14);write('Quie brand factor: ', capbrandtotal/capgencount:0:2, '  ');
end;


(***** TOURNAMENT *****)
{ Format of file PLAY.INI:
	 1st line: 'COMPUTER','HUMAN','OTHER' - first player is computer, human or other program
	 2nd line: 'COMPUTER','HUMAN','OTHER' - second player is computer, human or other program
	 3th line: code of opponent (e.g: 123456)
	 4th line: time total for playing (-1 if it is not counted)
	 5th line: input file name of move (to read) (e.g: c:\move\a.txt)
	 6th line: output file names of move (to write) (e.g: c:\move\b.txt)

 Format of file of move:
	 1st line: move's text (e.g: H2E2)
     2nd line: first left time (-1 if it is not counted)
     3th line: second left time (-1 if it is not counted)
}
const ininame = 'PLAY.INI'; zzz = 500; COMPUTER = 0; HUMAN = 1; OTHER = 2;
var
	firstside, moveInput, moveOutput: string;
    mylefttime, opplefttime: integer;
    myplayer, opponent: byte;
    opponentcode: word;

procedure InitPlay;
var f: Text; s: string; code: integer; ok : Boolean;
begin
    writeln('Wait for reading file ', ininame, '...');
	assign(f, ininame);
	repeat
		{$I-} reset(f); {$I+}
        ok := IOResult = 0; if not ok then delay(random(zzz));
	until ok;

	readln(f, s);              { First line is 'COMPUTER', 'HUMAN' or 'OTHER'}
	if s = 'COMPUTER' then myside := LIGHT
	else myside := DARK;

	readln(f, s);               { Second line is 'COMPUTER', 'HUMAN' or 'OTHER' }
	if s = 'COMPUTER' then myplayer := COMPUTER
	else myplayer := HUMAN;

	readln(f, s); val(s, opponentcode, code);   { 3th line is code of opponent }
	readln(f, s); val(s, mylefttime, code);     { 4th line is time total for playing }
    if opponent = COMPUTER then
    begin readln(f, moveInput); readln(f, moveOutput); end; { 6, 7th lines are input/output file names }
	close(f);
End;


procedure PutMessage;
var f: text; s: string; ok: Boolean;
begin
    gotoxy(1, 24); write('Writing computer''s move...   ');
	assign(f, moveOutput);
	Repeat {$I-} rewrite(f); {$I+} until IOResult=0;
    writeln(f, chr((newmove.from-1) mod SIZE_X + 65), SIZE_X-(newmove.from-1) div SIZE_X,
			   chr((newmove.dest-1) mod SIZE_X + 65), SIZE_X-(newmove.dest-1) div SIZE_X);
    mylefttime := -1; opplefttime := -1;
    str(mylefttime, s); writeln(f, s);
    str(opplefttime, s); writeln(f, s);
	close(f);
end;


function GetMessage: boolean;
var f: text; s: string; code: integer;
begin
    gotoxy(1, 24); write('Waiting for opponent move... ');
	assign(f, moveInput); GetMessage := true;
	repeat
		delay(random(zzz)); {$I-} reset(f); {$I+}
        while keypressed do if readkey = #27 then exit;
	until IOResult=0;

	readln(f, s); if (s='WIN')or(s='LOST')or(s='FINISH') then exit;
    newmove.from := ord(s[1])-64 + (SIZE_X-ord(s[2])+48)*SIZE_X;
    newmove.dest := ord(s[3])-64 + (SIZE_X-ord(s[4])+48)*SIZE_X;

	readln(f, s); val(s, opplefttime, code);
	readln(f, s); val(s, mylefttime, code);
	close(f); erase(f);
    gotoxy(1, 24); write('Computer is thinking...      ');
    GetMessage := false;
end;


function MyMove: boolean;
begin
	MyMove := false;
	if MyPlayer = COMPUTER then ComputerThink
	else MyMove := GetHumanMove;

    if opponent = COMPUTER then begin
		PutMessage;
       	while keypressed do if readkey = #27 then MyMove := true;
	end;
end;


function OpponentMove: boolean;
begin
	OpponentMove :=  false;
    if opponent = COMPUTER then begin
		GetMessage;
       	while keypressed do if readkey = #27 then OpponentMove := true;
	end else OpponentMove := GetHumanMove;
end;


(***** REPORT *****)
const reportcount: integer = 0;
var rf: text; s: string;

procedure WriteReport (force: boolean);
begin
    if reportcount = 0 then begin
    	assign(rf, REPORT_FILE_NAME); rewrite(rf);
		{ 3 first lines are sort information about this program }
        writeln(rf, 'Very Simple Chinese Chess. Version 1.4 - 1/1/1999');
        writeln(rf, 'Writen by Pham Hong Nguyen');
        writeln(rf, 'Vietnam National University, Ha noi, Viet nam.');
        if myside = LIGHT then writeln(rf, 'FIRSTPLAYER') else writeln(rf, 'SECONDPLAYER');
        close(rf);
        s := '';
    end;
    inc(reportcount);
    if not force then
       s := s + ' ' + chr((newmove.from-1) mod SIZE_X + 65) + chr(48 + SIZE_X-(newmove.from-1) div SIZE_X) +
		 	          chr((newmove.dest-1) mod SIZE_X + 65) + chr(48 + SIZE_X-(newmove.dest-1) div SIZE_X);

    if (Length(s) > 0) and (((reportcount mod 2) = 0) or force) then begin
        append(rf); writeln(rf, reportcount div 2, s); close(rf);
        s := '';
    end;
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
  get new move and convert it into normal move by the symmetrical kind }
function Getbook: boolean;
var i, j, sk: byte;	b, g: boolean;		{ sk: symmetrical kind }
begin
	g := false; t1 := book;

	{ Computer go first }
	if nm = 0 then begin
		if myside = DARK then sk := 3 else sk := 1;
		j := 1; g := true;
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
	if MyPlayer = HUMAN then exit;
	if not Readbook then exit;

	repeat
		if side = myside then begin
			if not GetBook then break;
		    if opponent = COMPUTER then begin
				PutMessage;
		       	while keypressed do if readkey = #27 then halt;
			end;
			gotoxy(50,11); write('Computer move   : ', chr(((newmove.from-1) mod 9)+65),9-(newmove.from-1) div 9,
											   chr(((newmove.dest-1) mod 9)+65),9-(newmove.dest-1) div 9, '  ');
		end
		else if OpponentMove then
			 begin FollowBook := true; break; end; { break when ESC is pressed }

		{ Save 4 symmetrical forms }
		for i := 1 to 4 do begin
			ss[i, nm+1] := SymmetricConvert(newmove.from, i);
			ss[i, nm+2] := SymmetricConvert(newmove.dest, i);
		end;

		nm := nm + 2;
		side := xside; xside := 3 - xside;
        WriteReport(false);
		if UpdateNewMove then halt;
	until false;

	Delbook;
end;


(***** MAIN BLOCK *****)
Begin
	InitGen; InitPlay; DrawBoard; side := LIGHT; xside := DARK;

    if opponent = COMPUTER then begin
    	gotoxy(1, 23);
		if myside = LIGHT then begin
			textcolor(14); write('I AM FIRST PLAYER');
		end else begin textcolor(13); write('I AM SECOND PLAYER'); end;
	end;

	if not FollowBook then
	repeat
		if side = myside then
		begin if MyMove then break; end
		else if OpponentMove then break;
		side := xside; xside := 3 - xside;
        WriteReport(false);
	until UpdateNewMove;
	WriteReport(true);
End.
