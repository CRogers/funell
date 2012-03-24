%token         INFIXR INFIXL SEP
%token<string> OPERATOR
%token<int>    NUMBER

%start<unit>   program

%{

open Tree
open Parser

(* Put builtin operators into optable *)
addToHash optable [("+", OPL2); ("-", OPL2); ("*", OPL3); ("/", OPL4)]

let getOp infix prec = match infix with
	| INFIXL -> match prec with
		| 0 -> OPL0
		| 1 -> OPL1
		| 2 -> OPL2
		| 3 -> OPL3
		| 4 -> OPL4
	| INFIXR -> match prec with
		| 0 -> OPR0
		| 1 -> OPR1
		| 2 -> OPR2
		| 3 -> OPR3
		| 4 -> OPR4

let addOp infix op prec =
	try
		Hashtbl.find optable op;
		raise (Failure Printf.sprintf "Infix operator %s already defined!" op)) 
	with
		Not_found -> Hashtbl.add optable op (getOp op)


%}

%%

program:
	| infix=infixes; op=OPERATOR; num=NUMBER; SEP program          { addOp infix op num }
	| SEP program                                                  { }

%inline infixes:
	| INFIXL                                                       { $1 }
	| INFIXR                                                       { $1 }