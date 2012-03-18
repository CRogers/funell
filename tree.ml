type param = string

type expr = 
	| Apply of expr * expr
	| Number of int
	| Ident of string

type typeExpr =
	| Type of string * typeExpr list
	| RawType of string * string list

type arg = string

type decl = 
	| Decl of string * arg list * expr
	| TypeDecl of string * string list * typeExpr

type program = Program of decl list


let binOp op l r = Apply ((Apply (Ident op, l)), r)