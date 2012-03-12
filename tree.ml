type param = string

type expr = 
	| FuncCall of param list
	| OpCall of param * param
	| Number of int

type arg = string

type decl = 
	| Function of string * arg list * expr

type program = Program of string