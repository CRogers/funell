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

type ftype = 
	| EmptyFT
	| FType of string * ftype

type typePattern =
	| PatternParam of string
	| PatternType of string
	| Pattern of typePattern list

type decl = 
	| DeclPlaceholder
	(* Fucntion declare of  funcName * args * right hand expr * type *)
	| Decl of string * arg list * expr * ftype
	| DataDecl of string * string list * decl list
	| RightDataDecl of string * typePattern list * decl

type program = Program of decl list


let binOp op l r = Apply ((Apply (Ident op, l)), r)


let addToHash ht vs = List.iter (fun (k, v) -> Hashtbl.add ht k v) vs

let makehash n vs =
	let ht = Hashtbl.create n in
	addToHash ht vs;
	ht