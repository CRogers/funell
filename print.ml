open Parser
open Lexer

let revtbl ht n =
	let rev = Hashtbl.create n in
	Hashtbl.iter (fun k v -> Hashtbl.add rev v k) ht;
	rev

let backwardtable = revtbl kwtable 64

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
		| BADTOK -> "BADTOK"