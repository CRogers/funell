type infixdef = 
	| Infixl of string * int
	| Infixr of string * int



type param = string

type expr = 
	| Apply of expr * expr list
	| Int of int
	| Ident of string

type typeExpr =
	| Type of string * typeExpr list
	| RawType of string * string list

type arg = string

type decl = 
	| Decl of string * arg list * expr

type program = Program of decl list


let binOp op l r = Apply ((Apply (Ident op, l)), r)


let addToHash ht vs = List.iter (fun (k, v) -> Hashtbl.add ht k v) vs

let makehash n vs =
	let ht = Hashtbl.create n in
	addToHash ht vs;
	ht