/*
	VSCCP - Very Simple Chinese Chess Program
	Written by Pham Hong Nguyen
	Faculty of Information Technology - Vietnam National University, Hanoi
	Office: 334 Nguyen Trai street, Thanh Xuan District, Hanoi, Vietnam
	Home page: http://www.Geocities.com/SiliconValley/Grid/6544/
	Email    : phhnguyen@yahoo.com

	Version:
			1.0 - basic
			1.1 - add opening book
		 ->	1.2 - improve eval function
			1.3 - improve alphabeta search by adding iterative deepening,
				  quiescence, principal variation, history, killer heuristics
			1.4 - add new rules and interface for tournament between 2 programs
				  A tournament can be controled by ROCC (Referee of Chinese Chess)
*/

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <alloc.h>
#include "defs12.h"


/* the board representation && the initial board state */
char color[BOARD_SIZE]= {
		0, 0, 0, 0, 0, 0, 0, 0, 0,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		7, 0, 7, 7, 7, 7, 7, 0, 7,
		0, 7, 0, 7, 0, 7, 0, 7, 0,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		1, 7, 1, 7, 1, 7, 1, 7, 1,
		7, 1, 7, 7, 7, 7, 7, 1, 7,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		1, 1, 1, 1, 1, 1, 1, 1, 1};

char piece[BOARD_SIZE]= {
		5, 3, 2, 1, 6, 1, 2, 3, 5,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		7, 4, 7, 7, 7, 7, 7, 4, 7,
		0, 7, 0, 7, 0, 7, 0, 7, 0,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		0, 7, 0, 7, 0, 7, 0, 7, 0,
		7, 4, 7, 7, 7, 7, 7, 4, 7,
		7, 7, 7, 7, 7, 7, 7, 7, 7,
		5, 3, 2, 1, 6, 1, 2, 3, 5};

char materialnumber[2][7] = {{5, 2, 2, 2, 2, 2, 1}, {5, 2, 2, 2, 2, 2, 1}};

/* For getting information */
unsigned long 	nodecount, brandtotal = 0, gencount = 0;
char	ply, side, xside, computerside;
move	newmove;
gen_rec	gen_dat[MOVE_STACK];
short	gen_begin[HIST_STACK], gen_end[HIST_STACK];
hist_rec hist_dat[HIST_STACK];
short	hdp;

volatile unsigned long *systicks=(unsigned long*)0x46C; /* Clock counter */
unsigned long tickstart, tickend;

/***** INTERFACE *****/
void MoveTo(short x, short y)
{
	gotoxy (5*x+1, 2*y+1);
}


void DrawCell(short pos, short mode)
{
	char piece_char[] = "PBENCRK+"; /*"TSVMPXT+"; /* the piece letters */

	if (color[pos]==DARK) textcolor(13);
	else if (color[pos]==LIGHT) textcolor(14); else textcolor(7);
	if (mode==NORMAL) textbackground(0); else textbackground(1);
	MoveTo(pos%9, pos/9);
	cprintf("%c", piece_char[piece[pos]]);
}


void DrawBoard(void)
{
	int i;
	textcolor(7); textbackground(0); clrscr(); gotoxy(1,1);
	printf("+----+----+----+----+----+----+----+----+  9\n");
	printf("|    |    |    | \\  |  / |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  8\n");
	printf("|    |    |    | /  |  \\ |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  7\n");
	printf("|    |    |    |    |    |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  6\n");
	printf("|    |    |    |    |    |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  5\n");
	printf("|                                       |\n");
	printf("+----+----+----+----+----+----+----+----+  4\n");
	printf("|    |    |    |    |    |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  3\n");
	printf("|    |    |    |    |    |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  2\n");
	printf("|    |    |    | \\  |  / |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  1\n");
	printf("|    |    |    | /  |  \\ |    |    |    |\n");
	printf("+----+----+----+----+----+----+----+----+  0\n");
	printf("A    B    C    D    E    F    G    H    I\n");
	gotoxy(1,25); printf("Up, Down, Right, Left: cursor move   Enter or Space: select  ESC: escape");
	gotoxy(48,1); cprintf("VERY SIMPLE CHINESE CHESS PROGRAM");
	gotoxy(50,2); cprintf("(C) Pham Hong Nguyen. Ver %s", VERSION);

	for (i=0; i<BOARD_SIZE; i++) DrawCell(i, NORMAL);
}


void Gen(void);

short GetHumanMove(void)
{
	static short x = 4, y = 5;
	short ch, from, t, i, selecting = 0;

	Gen();		 /* for check legal move only */

	while (1) {
		MoveTo (x, y);
		ch = (short)getch();
		switch (ch) {
		case 13:
		case 32:                  		/* Enter or Spacebar */
			t = x + y*SIZE_X;
			if (!selecting) {
				if (color[t]==side) {
					selecting = 1; from = t; DrawCell(t, SELECT);
				}
			} else {
				if (t != from) DrawCell(from, NORMAL);
				if (color[t]==side) {
					from = t; DrawCell(t, SELECT);
				} else {
					newmove.from = from; newmove.dest = t;
					for (i=gen_begin[ply]; i<gen_end[ply]; i++)
						if (gen_dat[i].m.from==newmove.from && gen_dat[i].m.dest==newmove.dest) return 0;
					DrawCell(from, SELECT);
				}
			}
			break;

		case 27:  return 1; 	/* ESC */

		case 0:
				ch = (short)getch();
				switch (ch) {
				case 75: if (x) x--; else x = SIZE_X-1; break;	/* LEFT */
				case 77: if (x<SIZE_X-1) x++; else x = 0; break;	/* RIGHT */
				case 72: if (y) y--; else y = SIZE_Y-1; break;	/* UP */
				case 80: if (y<SIZE_Y-1) y++; else y = 0; break;	/* DOWN */
				}
				break;
		} /* switch */
	} /* while */
}


/**** MOVE GENERATE ****/
short offset[7][8] =
		{{-1, 1,13, 0, 0, 0, 0, 0},		/* PAWN {for DARK side} */
		{-12,-14,12,14,0,0,0,0},		/* BISHOP */
		{-28,-24,24,28, 0, 0, 0, 0 },	/* ELEPHAN */
		{-11,-15,-25,-27,11,15,25,27},	/* KNIGHT */
		{-1, 1,-13,13, 0, 0, 0, 0},		/* CANNON */
		{-1, 1,-13,13, 0, 0, 0, 0},		/* ROOK */
		{-1, 1,-13,13, 0, 0, 0, 0}};	/* KING */

short mailbox182[182] =
		{-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
		-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
		-1,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8,-1,-1,
		-1,-1, 9,10,11,12,13,14,15,16,17,-1,-1,
		-1,-1,18,19,20,21,22,23,24,25,26,-1,-1,
		-1,-1,27,28,29,30,31,32,33,34,35,-1,-1,
		-1,-1,36,37,38,39,40,41,42,43,44,-1,-1,
		-1,-1,45,46,47,48,49,50,51,52,53,-1,-1,
		-1,-1,54,55,56,57,58,59,60,61,62,-1,-1,
		-1,-1,63,64,65,66,67,68,69,70,71,-1,-1,
		-1,-1,72,73,74,75,76,77,78,79,80,-1,-1,
		-1,-1,81,82,83,84,85,86,87,88,89,-1,-1,
		-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
		-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};

short mailbox90[90] =
		{28, 29, 30, 31, 32, 33, 34, 35, 36,
		 41, 42, 43, 44, 45, 46, 47, 48, 49,
		 54, 55, 56, 57, 58, 59, 60, 61, 62,
		 67, 68, 69, 70, 71, 72, 73, 74, 75,
		 80, 81, 82, 83, 84, 85, 86, 87, 88,
		 93, 94, 95, 96, 97, 98, 99,100,101,
		106, 107,108,109,110,111,112,113,114,
		119, 120,121,122,123,124,125,126,127,
		132, 133,134,135,136,137,138,139,140,
		145, 146,147,148,149,150,151,152,153};

short legalposition[90] =
		{1, 1, 5, 3, 3, 3, 5, 1, 1,
		1, 1, 1, 3, 3, 3, 1, 1, 1,
		5, 1, 1, 3, 7, 3, 1, 1, 5,
		1, 1, 1, 1, 1, 1, 1, 1, 1,
		9, 1,13, 1, 9, 1,13, 1, 9,
		9, 9, 9, 9, 9, 9, 9, 9, 9,
		9, 9, 9, 9, 9, 9, 9, 9, 9,
		9, 9, 9, 9, 9, 9, 9, 9, 9,
		9, 9, 9, 9, 9, 9, 9, 9, 9,
		9, 9, 9, 9, 9, 9, 9, 9, 9};

short maskpiece[7] = {8, 2, 4, 1, 1, 1, 2},
	knightcheck[8] = {1,-1,-9,-9,-1,1,9,9},
	elephancheck[8] = {-10,-8,8,10,0,0,0,0},
	kingpalace[9] = {3,4,5,12,13,14,21,22,23};


void InitGen(void)
{
	gen_begin[0] = 0; ply = 0; hdp = 0;
}


short KingFace(short from, short dest)
{
	short i, k, t, r = 0;
	i = from % SIZE_X;
	if (i>=3 && i<=5 && piece[dest]!=KING) {
		t = piece[dest]; piece[dest] = piece[from]; piece[from] = EMPTY;
		i = 0;
		for (k=kingpalace[i]; piece[k]!=KING; k++) ;
		for (k += SIZE_X; k<BOARD_SIZE && piece[k]==EMPTY; k += SIZE_X);
		if (piece[k]==KING) r = 1;
		piece[from] = piece[dest]; piece[dest] = t;
	}
	return r;
}


void Gen_push(short from, short dest)
{
	if (!KingFace(from, dest)) {
		gen_dat[gen_end[ply]].m.from = from;
		gen_dat[gen_end[ply]].m.dest = dest;
		gen_end[ply]++;
	}
}


void Gen(void)
{
	short i, j, k, n, p, x, y, t, fcannon;

	gen_end[ply] = gen_begin[ply];

	for(i=0; i < BOARD_SIZE; i++)
		if (color[i]==side) {
			p = piece[i];
			for(j=0; j<8; j++) {
				if (!offset[p][j]) break;
				x = mailbox90[i]; fcannon = 0;
				if (p==ROOK || p==CANNON) n = 9; else n = 1;
				for (k=0; k<n; k++) {
					if (p==PAWN && side==LIGHT) x -= offset[p][j]; else x += offset[p][j];

					y = mailbox182[x];
					if (side == DARK) t = y; else t = 89-y;
					if (y==-1 || (legalposition[t] & maskpiece[p])==0) break;
					if (!fcannon) {
						if (color[y]!=side)
							switch (p) {
							case KNIGHT: if (color[i+knightcheck[j]]==EMPTY) Gen_push(i, y); break;
							case ELEPHAN:if (color[i+elephancheck[j]]==EMPTY) Gen_push(i, y); break;
							case CANNON: if (color[y]==EMPTY) Gen_push(i, y); break;
							default: Gen_push(i, y);
							}
						if (color[y]!=EMPTY) { if (p==CANNON) fcannon++; else break; }
					}
					else {	/* CANNON switch */
						if (color[y] != EMPTY) {
							if (color[y]==xside) Gen_push(i, y);
							break;
						}
					}
				} /* for k */
			} /* for j */
	}

	gen_end[ply+1] = gen_end[ply]; gen_begin[ply+1] = gen_end[ply];
	brandtotal += gen_end[ply] - gen_begin[ply]; gencount++;
}


/***** MOVE *****/
short MakeMove(move m)
{
	short from, dest, p;
	nodecount++;
	from = m.from; dest = m.dest; p = piece[dest];
	if (p != EMPTY) materialnumber[xside][p]--;
	hist_dat[hdp].m = m; hist_dat[hdp].capture = p;
	piece[dest] = piece[from]; piece[from] = EMPTY;
	color[dest] = color[from]; color[from] = EMPTY;
	hdp++; ply++; side = xside; xside = 1-xside;
	return p == KING;
}


void UnMakeMove(void)
{
	short from, dest;
	hdp--; ply--; side = xside; xside = 1-xside;
	from = hist_dat[hdp].m.from; dest = hist_dat[hdp].m.dest;
	piece[from] = piece[dest]; color[from] = color[dest];
	piece[dest] = hist_dat[hdp].capture;
	if (piece[dest] == EMPTY) color[dest] = EMPTY; else color[dest] = xside;
	if (piece[dest] != EMPTY) materialnumber[xside][piece[dest]]++;
}


short UpdateNewMove(void)
{
	short from, dest, p;
	from = newmove.from; dest = newmove.dest; p = piece[dest];
	if (p != EMPTY) materialnumber[side][p]--;
	piece[dest] = piece[from]; piece[from] = EMPTY;
	color[dest] = color[from]; color[from] = EMPTY;
	DrawCell(from, NORMAL); DrawCell(dest, NORMAL);
	return p == KING;
}


/***** EVALUATE *****/
short Bonous(void)
{
	short i, s, bn[2][7] = {{-2, -3, -3, -4, -4, -5, 0},
							{-2, -3, -3, -4, -4, -5, 0}};

	for (i = 0; i < 2; i++) {			// Scan DARK and LIGHT
		if (materialnumber[i][BISHOP] < 2) {
			bn[1-i][ROOK] += 4;
			bn[1-i][KNIGHT] += 2;
			bn[1-i][PAWN] += 1;
		}

		if (materialnumber[i][ELEPHAN] < 2) {
			bn[1-i][ROOK] += 2;
			bn[1-i][CANNON] += 2;
			bn[1-i][PAWN] += 1;
		}
	}

	if (color[0]==DARK && color[1]==DARK && piece[0]==ROOK && piece[1]==KNIGHT)
		bn[DARK][6] -= 10;
	if (color[7]==DARK && color[8]==DARK && piece[8]==ROOK && piece[7]==KNIGHT)
		bn[DARK][6] -= 10;
	if (color[81]==LIGHT && color[82]==LIGHT && piece[81]==ROOK && piece[82]==KNIGHT)
		bn[LIGHT][6] -= 10;
	if (color[88]==LIGHT && color[89]==LIGHT && piece[89]==ROOK && piece[88]==KNIGHT)
		bn[LIGHT][6] -= 10;

	s = bn[side][6] - bn[xside][6];

	for (i=0; i < 6; i++)
		s += materialnumber[side][i] * bn[side][i]
			 -	materialnumber[xside][i] * bn[xside][i];
	return s;
}


char pointtable[7][2][90] =
	 {{{0,  0,  0,  0,  0,  0,  0,  0,  0, 			/* PAWN*/
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		10,  0, 12,  0, 15,  0, 12,  0, 10,
		10,  0, 13,  0, 10,  0, 13,  0, 10,
		20, 20, 20, 20, 20, 20, 20, 20, 20,
		20, 21, 21, 22, 22, 22, 21, 21, 20,
		20, 21, 21, 23, 23, 23, 21, 21, 20,
		20, 21, 21, 23, 22, 23, 21, 21, 20,
		11, 12, 13, 14, 14, 14, 13, 12, 11},

	  {11, 12, 13, 14, 14, 14, 13, 12, 11,          /* PAWN*/
		20, 21, 21, 23, 22, 23, 21, 21, 20,
		20, 21, 21, 23, 23, 23, 21, 21, 20,
		20, 21, 21, 22, 22, 22, 21, 21, 20,
		20, 20, 20, 20, 20, 20, 20, 20, 20,
		10,  0, 13,  0, 10,  0, 13,  0, 10,
		10,  0, 12,  0, 15,  0, 12,  0, 10,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0}},

	  {{0,  0,  0, 20,  0, 20,  0,  0,  0, 			/* BISHOP */
		0,  0,  0,  0, 22,  0,  0,  0,  0,
		0,  0,  0, 19,  0, 19,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0},

	   {0,  0,  0,  0,  0,  0,  0,  0,  0,          /* BISHOP */
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0, 19,  0, 19,  0,  0,  0,
		0,  0,  0,  0, 22,  0,  0,  0,  0,
		0,  0,  0, 20,  0, 20,  0,  0,  0}},

	  {{0,  0, 25,  0,  0,  0, 25,  0,  0, 			/* ELEPHAN */
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		23,  0,  0,  0, 28,  0,  0,  0, 23,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 22,  0,  0,  0, 22,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0},

	   {0,  0,  0,  0,  0,  0,  0,  0,  0,          /* ELEPHAN */
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 22,  0,  0,  0, 22,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
	   23,  0,  0,  0, 28,  0,  0,  0, 23,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0, 25,  0,  0,  0, 25,  0,  0}},

	  {{40, 35, 40, 40, 40, 40, 40, 35, 40, 		/* KNIGHT */
		40, 41, 42, 40, 20, 40, 42, 41, 40,
		40, 42, 43, 40, 40, 40, 43, 42, 40,
		40, 42, 43, 43, 43, 43, 43, 42, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 41, 42, 42, 42, 42, 42, 41, 40,
		40, 40, 40, 40, 40, 40, 40, 40, 40},

	   {40, 40, 40, 40, 40, 40, 40, 40, 40, 		/* KNIGHT */
		40, 41, 42, 42, 42, 42, 42, 41, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 43, 44, 44, 44, 44, 44, 43, 40,
		40, 42, 43, 43, 43, 43, 43, 42, 40,
		40, 42, 43, 40, 40, 40, 43, 42, 40,
		40, 41, 42, 40, 20, 40, 42, 41, 40,
		40, 35, 40, 40, 40, 40, 40, 35, 40}},

	  {{50, 50, 50, 50, 50, 50, 50, 50, 50, 		/* CANNON */
		50, 50, 50, 50, 50, 50, 50, 50, 50,
		50, 51, 53, 53, 55, 53, 53, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 51, 51, 51, 51, 51, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50},

	   {50, 50, 50, 50, 50, 50, 50, 50, 50, 		/* CANNON */
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 51, 51, 51, 51, 51, 51, 50,
		50, 51, 50, 50, 50, 50, 50, 51, 50,
		50, 51, 53, 53, 55, 53, 53, 51, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50,
		50, 50, 50, 50, 50, 50, 50, 50, 50}},


	  {{89, 92, 90, 90, 90, 90, 90, 92, 89, 		/* ROOK */
		91, 92, 90, 93, 90, 93, 90, 92, 91,
		90, 92, 90, 91, 90, 91, 90, 92, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 94, 90, 94, 90, 94, 90, 94, 90,
		90, 93, 90, 91, 90, 91, 90, 93, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 91, 90, 90, 90, 90, 90, 91, 90,
		90, 92, 91, 91, 90, 91, 91, 92, 90,
		90, 90, 90, 90, 90, 90, 90, 90, 90},

	   {90, 90, 90, 90, 90, 90, 90, 90, 90, 		/* ROOK */
		90, 92, 91, 91, 90, 91, 91, 92, 90,
		90, 91, 90, 90, 90, 90, 90, 91, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 93, 90, 91, 90, 91, 90, 93, 90,
		90, 94, 90, 94, 90, 94, 90, 94, 90,
		90, 91, 90, 91, 90, 91, 90, 91, 90,
		90, 92, 90, 91, 90, 91, 90, 92, 90,
		91, 92, 90, 93, 90, 93, 90, 92, 91,
		89, 92, 90, 90, 90, 90, 90, 92, 89}},

	  {{0,  0,  0, 30, 35, 30,  0,  0,  0, 			/* KING */
		0,  0,  0, 15, 15, 15,  0,  0,  0,
		0,  0,  0,  1,  1,  1,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0},

		{0,  0,  0,  0,  0,  0,  0,  0,  0,          /* KING */
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  1,  1,  1,  0,  0,  0,
		0,  0,  0, 15, 15, 15,  0,  0,  0,
		0,  0,  0, 30, 35, 30,  0,  0,  0}}};

short Eval(void)
{
	short i, s = 0;
	for(i=0; i<BOARD_SIZE; i++) {
		if (color[i]==DARK) s += pointtable[piece[i]][DARK][i];
		else if (color[i]==LIGHT) s -= pointtable[piece[i]][LIGHT][i];
	}
	if (side==LIGHT) s = -s;
	return s + Bonous();
}


/***** SEARCH *****/
/* Search game tree by alpha-beta algorith */
short AlphaBeta(short alpha, short beta, short depth)
{
	short i, value, best;

	if (!depth) return Eval();

	Gen();
	best = -INFINITY;

	for (i=gen_begin[ply]; i<gen_end[ply] && best<beta; i++) {
		if (best > alpha) alpha = best;

		if (MakeMove(gen_dat[i].m)) value = 1000-ply;
		else value = -AlphaBeta(-beta, -alpha, depth-1);
		UnMakeMove();

		if (value > best) {
			best = value; if (!ply) newmove = gen_dat[i].m;
		}
	}

	return best;
}


/***** THINK *****/
/* Call AlphaBeta short && display some information */
void ComputerThink(void)
{
	short best;
	tickstart = *systicks; nodecount = 0;

	best = AlphaBeta(-INFINITY, INFINITY, MAX_PLY);

	/* Display some information */
	tickend = *systicks; textcolor(7);
	gotoxy(50, 4); printf("Depth            : %d", MAX_PLY);
	gotoxy(50, 5); printf("Node total       : %ld ", nodecount);
	gotoxy(50, 6); printf("Brand factor     : %.2f ", (float)brandtotal/gencount);
	gotoxy(50, 7); printf("Time (second)    : %.2f ", (tickend-tickstart)/18.23);
	gotoxy(50, 8); printf("Nodes per second : %ld ", (long)(nodecount*18.23/(tickend-tickstart+1)));
	gotoxy(50, 9); printf("Score            : %d ", best);
	gotoxy(50,11); printf("Computer move    : %c%d%c%d ", (char)(newmove.from%SIZE_X+65), (short)(SIZE_X-newmove.from/SIZE_X),
												(char)(newmove.dest%SIZE_X+65), (short)(SIZE_X-newmove.dest/SIZE_X));
}


/***** OPENING BOOK *****/
/*
	When you have a move's line, it may be not in opening book but
	one of its symmetry may be in. So, you have to convert move's line into all
	of symmetrical forms. There are 4 symmetrical forms as following:
		(1) normal move
		(2) vertical axial symmetry
		(3) horizontal axial symmetry
		(4) central symmetry
	After finding out a symmetry in opening book, you can get a new move
	and convert it into normal move.
*/
struct node *book = NULL, *t1, *t2;
short	ss[4][52],  /* save 4 symmetrical kinds of line */
		nm = 0;		/* working pointer of line */
FILE *f;

short Readbook(void)
{
	short i, j, len;
	char s[255], line[52], ch;

	if ((f = fopen("BOOK.DAT", "rt"))== NULL) return 0;

	while(1) {
		/* Read a book line */
		for (j=0, ch=0; ch!='\n'; j++) {
			ch = fgetc(f); s[j] = ch;
			if (feof(f)) break;
		}
		if (feof(f)) break;

		/* Convert string into position */
		for (i=0, len=0; i<j && s[i] !=';'; i++)
			if (s[i] >= 'A') {
				line[len] = s[i]-65 + (SIZE_X-s[i+1]+48)*SIZE_X;
				i++; len++;
			}

		if (len) { 	/* save in single linked list */
			t1 = (struct node *) malloc(sizeof(struct node));
			t1->next = NULL; t1->len = len;
			for (i=0; i<len; i++) t1->line[i] = line[i];
			if (book==NULL) book = t1; else t2->next = t1;
			t2 = t1;
		}
	}

	fclose(f);
	return 1;
}

void DelBook(void)
{
	t1 = book; t2 = book->next;
	while (t1 != NULL) { free(t1); t1 = t2; t2 = t2->next; }
}

/* Convert a position into a symmetrical position */
short SymmetricConvert(short m, short k)
{
	switch (k) {
		case 0: return m;
		case 1: return m+SIZE_X-1-2*(m%SIZE_X);
		case 2: return m + (SIZE_Y-1 - 2*(m/SIZE_X))*SIZE_X;
		case 3: return BOARD_SIZE-1-m;
	}
	return m;
}

/*
 Search opening book list for one of symmetrical lines. If it is found,
 get new move and convert it into normal move by the symmetrical kind.
*/
short GetBook(void)
{
	short k, sk, g = 0;			/* sk: symmetrical kind */

	t1 = book;

	/* Computer go first */
	if (!nm) {
		if (computerside==DARK) sk = 2; else sk = 0;
		k = 0; g = 1;
	} else
		while (t1 != NULL) {
			if (nm < t1->len) {
				for(sk=0; sk<4; sk++) {
					for (k=0,g=1; k<nm; k++)
						if (ss[sk][k]!=t1->line[k]) { g=0; break;}
					if (g) break;
				}
				if (g) break;
			}
			t1 = t1->next;
		}

	/* Convert new move into normal */
	if (g) {
		newmove.from = SymmetricConvert(t1->line[k], sk);
		newmove.dest = SymmetricConvert(t1->line[k+1], sk);
	}
	return g;
}


short FollowBook(void)
{
	short i;

	if (!Readbook()) return 1;

	while(1) {
		if (side==computerside) {
			if (!GetBook()) break;
			gotoxy(50,11); printf("Computer move    : %c%d%c%d ", (char)(newmove.from%SIZE_X+65), (short)(SIZE_X-newmove.from/SIZE_X),
												(char)(newmove.dest%SIZE_X+65), (short)(SIZE_X-newmove.dest/SIZE_X));
		} else if (GetHumanMove()) return 0; /* break when ESC is pressed */

		/* Save 4 symmetrical forms */
		for (i=0; i<4; i++) {
			ss[i][nm] = SymmetricConvert(newmove.from, i);
			ss[i][nm+1] = SymmetricConvert(newmove.dest, i);
		}
		nm += 2; side = xside; xside = 1-xside;
		if (UpdateNewMove()) exit(0);
	}
	DelBook();
	return 1;
}


/***** MAIN BLOCK *****/
void main(void)
{
	InitGen(); DrawBoard(); side = DARK; xside = LIGHT; computerside = side;

	if (FollowBook())
	do {
		if (side == computerside) ComputerThink();
		else if (GetHumanMove()) break;
		side = xside; xside = 1-xside;
	} while (!UpdateNewMove());
}
