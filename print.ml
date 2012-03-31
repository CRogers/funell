open Preparser
open Parser
open Lexer
open Tree

let revtbl ht n =
	let rev = Hashtbl.create n in
	Hashtbl.iter (fun k v -> Hashtbl.add rev v k) ht;
	rev

let backwardtable = revtbl kwtable 64

let read_lineno file lineno =
	let in_chan = open_in file in
	for i=1 to lineno-1 do
		input_line in_chan
	done;
	input_line in_chan

let err_msg msg lineno file =
	Printf.printf "Error: %s at line %d in file %s:\n%s\n" msg lineno file (read_lineno file lineno)

let fmt_pretoken =
	function
		| INFIXR -> "INFIXR"
		| INFIXL -> "INFIXL"
		| OPERATOR s -> "(OPERATOR " ^ s ^ ")"
		| NUMBER i -> "(NUMBER " ^ string_of_int i ^ ")"
		| LINEBREAK -> "LINEBREAK"
		| PREEOF -> "EOF"

let fmt_token =
	function
		| IDENT s -> "(IDENT " ^ s ^ ")"
		| INTEGER i -> "(INTEGER " ^ string_of_int i ^ ")"
		| TYPE s -> "(TYPE " ^ s ^ ")"
		| OPL0 s -> "(OPL0 " ^ s ^ ")"
		| OPL1 s -> "(OPL1 " ^ s ^ ")"
		| OPL2 s -> "(OPL2 " ^ s ^ ")"
		| OPL3 s -> "(OPL3 " ^ s ^ ")"
		| OPL4 s -> "(OPL4 " ^ s ^ ")"
		| OPR0 s -> "(OPR0 " ^ s ^ ")"
		| OPR1 s -> "(OPR1 " ^ s ^ ")"
		| OPR2 s -> "(OPR2 " ^ s ^ ")"
		| OPR3 s -> "(OPR3 " ^ s ^ ")"
		| OPR4 s -> "(OPR4 " ^ s ^ ")"
		| EOF -> "EOF"
		| SEP -> "SEP"
		| ASSIGN -> "ASSIGN"
		| LPAR -> "LPAR"
		| RPAR -> "RPAR"
		| LET -> "LET"
		| IN -> "IN"
		| OPINFIXR -> "OPINFIXR"
		| OPINFIXL -> "OPINFIXL"
		| DATADECL -> "DATADECL"
		| TYPEDECL -> "TYPEDECL"
		| GUARD -> "GUARD"
		| BADTOK s -> "(BADTOK " ^ s ^ ")"

let id s = s

let fmt_list formatter = 
	function 
		| [] -> "[]"
		| (head::tail) -> "[" ^ (List.fold_left (fun result item -> result ^ ", " ^ formatter item) (formatter head) tail) ^ "]"

let rec fmt_expr =
	function
		| Apply (name, arg) -> Printf.sprintf "(Apply %s %s)" (fmt_expr name) (fmt_list fmt_expr arg)
		| Ident s -> s
		| Int i -> string_of_int i

let rec fmt_typePattern = 
	function
		| PatternParam param -> param
		| PatternType ftype -> ftype
		| Pattern patterns -> Printf.sprintf "(Pattern %s)" (fmt_list fmt_typePattern patterns)

let rec fmt_decl =
	function
		| DeclPlaceholder -> "DeclPlaceholder"
		| Decl (name, args, e, ft) -> Printf.sprintf "(Decl %s %s %s)" name (fmt_list id args) (fmt_expr e)
		| DataDecl (name, typeArgs, decls) -> Printf.sprintf "(DataDecl %s %s %s)" name (fmt_list id typeArgs) (fmt_list fmt_decl decls)
		| RightDataDecl (name, patterns, declare) -> Printf.sprintf "(RightDataDecl %s %s %s)" name (fmt_list fmt_typePattern patterns) (fmt_decl declare)

let rec fmt_program = 
	function
		| Program decls -> List.fold_left (fun result decl -> result ^ fmt_decl decl ^ "\n") "" decls