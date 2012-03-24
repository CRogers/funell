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
		| PREEOF -> "PREEOF"

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
		| BADTOK s -> "(BADTOK " ^ s ^ ")"

let id s = s

let fmt_list formatter list = "[" ^ (List.fold_left (fun result item -> result ^ formatter item ^ ", ") "" list) ^ "]"

let rec fmt_expr =
	function
		| Apply (name, arg) -> Printf.sprintf "(Apply %s %s)" (fmt_expr name) (fmt_expr arg)
		| Ident s -> s
		| Number i -> string_of_int i

let rec fmt_decl =
	function
		| Decl (name, args, e) -> Printf.sprintf "(Decl %s %s %s)" name (fmt_list id args) (fmt_expr e)

let rec fmt_program = 
	function
		| Program decls -> List.fold_left (fun result decl -> result ^ fmt_decl decl ^ "\n") "" decls