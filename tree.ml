type param = string

type expr = 
	| Call of string * expr list
	| Number of int

type typeExpr =
	| Type of string * typeExpr list
	| RawType of string * string list

type arg = string

type decl = 
	| Decl of string * arg list * expr
	| TypeDecl of string * string list * typeExpr

type program = Program of decl list