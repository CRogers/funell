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
		[("=", ASSIGN); ("(", LPAR); (")", RPAR); ("let", LET); ("in", IN); ("|", GUARD); ("type", TYPEDECL) ] 

(* Look up to see if s is a keyword, if so return the appropriate token otherwise use f to make token *)
let seeIfKw s f =
	try Hashtbl.find kwtable s with Not_found -> f s

let lastIndent = ref 0
let lineno = ref 1

}

let types = ['A'-'Z']['a'-'z''A'-'Z''0'-'9']*
let idents = ['a'-'z''A'-'Z''0'-'9']+
let operators = ['<''>''.'':''|''\\''?'':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}''=']+

let white = ['\t'' ']
let newline = '\n'

rule token = parse
	| newline white*        { let indent = String.length (lexeme lexbuf) - 1 and li = !lastIndent in
	                          incr lineno;
	                          lastIndent := indent;
							  token lexbuf
	                          (*if indent == li then SEP
	                          else (if indent > li then INDENT else OUTDENT)*) }
	| white+                { token lexbuf }
	| types                 { TYPE (lexeme lexbuf) }
	| idents                { seeIfKw (lexeme lexbuf) (fun s -> IDENT s) }
	| operators             { seeIfKw (lexeme lexbuf) (fun s -> OPERATOR s) }
	| eof                   { EOF }
	| _                     { seeIfKw (lexeme lexbuf) (fun s -> BADTOK s) }