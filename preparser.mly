%token         INFIXR INFIXL LINEBREAK PREEOF
%token<string> OPERATOR
%token<int>    NUMBER

%start<int> program

%{

open Tree
open Parserlib

let getOp infix v prec = match infix with
	| INFIXL -> (match prec with
		| 0 -> Parser.OPL0 v
		| 1 -> Parser.OPL1 v
		| 2 -> Parser.OPL2 v
		| 3 -> Parser.OPL3 v
		| 4 -> Parser.OPL4 v)
	| INFIXR -> (match prec with
		| 0 -> Parser.OPR0 v
		| 1 -> Parser.OPR1 v
		| 2 -> Parser.OPR2 v
		| 3 -> Parser.OPR3 v
		| 4 -> Parser.OPR4 v)

let addOp infix op prec = Hashtbl.add optable op (getOp infix op prec)

%}

%%

program:
	| i=infixes op=OPERATOR n=NUMBER linebreakEof                  { addOp i op n; 0 }
	| OPERATOR program                                             { 0 }
	| LINEBREAK program                                            { 0 }
	| NUMBER program                                               { 0 }
	| PREEOF                                                       { 0 }

infixes:
	| INFIXL                                                       { INFIXL }
	| INFIXR                                                       { INFIXR }

linebreakEof:
	| LINEBREAK program                                            { 0 }
	| PREEOF                                                       { 0 }