{
	
open Parser
open Lexing

let makehash n vs =
	let ht = Hashtbl.create n in
	List.iter (fun (k, v) -> Hashtbl.add ht k v) vs;
	ht

(* A small hashtable for keywords *)
let kwtable = 
	makehash 64
		[("let", LET); ]

let lookup s = try Hashtbl.find kwtable s with Not_found -> IDENT s  

let lastIndent = ref 0

}

let types = ['A'-'Z']['a'-'z''A'-'Z''0'-'9']*
let idents = ['a'-'z''A'-'Z''0'-'9']+
let operators = ['<''>''.'':''|''\\''?''='':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}']+
let white = ['\t'' ']
let newline = '\n'

rule token = parse
	| newline white*		{ let indent = String.length (lexeme lexbuf) - 1 and li = !lastIndent in
							  lastIndent := indent;
							  if indent == li then SEP
							  else (if indent > li then INDENT else OUTDENT) }
	| white+				{ token lexbuf }
	| types					{ TYPE (lexeme lexbuf) }
	| idents				{ IDENT (lexeme lexbuf) }
	| operators				{ OPERATOR (lexeme lexbuf) }
	| eof					{ EOF }
	| _						{ BADTOK }