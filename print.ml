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
	Printf.printf "file: %s, line: %d" file lineno;
	for i=1 to lineno-1 do
		input_line in_chan
	done;
	input_line in_chan

let err_msg msg lineno file =
	Printf.printf "Error: %s at line %d in file %s:\n%s\n" msg lineno file (read_lineno file lineno)

let fmt_token =
	function
		| IDENT s -> "(IDENT " ^ s ^ ")"
		| TYPE s -> "(TYPE " ^ s ^ ")"
		| OPERATOR s -> "(OPERATOR " ^ s ^ ")" 
		| INDENT -> "INDENT"
		| OUTDENT -> "OUTDENT"
		| SEP -> "SEP"
		| EOF -> "EOF"
		| ASSIGN -> "ASSIGN"
		| LPAR -> "LPAR"
		| RPAR -> "RPAR"
		| LET -> "LET"
		| IN -> "IN"
		| GUARD -> "GUARD"
		| TYPEDECL -> "TYPEDECL"
		| BADTOK s -> "(BADTOK " ^ s ^ ")"

let id s = s

let fmt_list formatter list = "[" ^ (List.fold_left (fun result item -> result ^ formatter item ^ "; ") "" list) ^ "]"

let rec fmt_expr =
	function
		| Call (name, args) -> Printf.sprintf "(Call %s %s)" name (fmt_list fmt_expr args)

let rec fmt_decl =
	function
		| Decl (name, args, e) -> Printf.sprintf "(Decl %s %s %s)" name (fmt_list id args) (fmt_expr e)

let rec fmt_program = 
	function
		| Program decls -> List.fold_left (fun result decl -> result ^ "\n" ^ fmt_decl decl) "" decls