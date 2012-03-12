open Parser

let fmt_token =
	function
		| IDENT s -> "(IDENT " ^ s ^ ")"
		| TYPE s -> "(TYPE " ^ s ^ ")"
		| INDENT -> "INDENT"
		| OUTDENT -> "OUTDENT"
		| SEP -> "SEP"