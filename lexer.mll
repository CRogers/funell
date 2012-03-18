{
	
open Parser
open Lexing
open Tree

(* A small hashtable for keywords *)
let kwtable = 
	makehash 64
		[("=", ASSIGN); ("(", LPAR); (")", RPAR); ("let", LET); ("in", IN);
		] 

(* A hashtable to keep a list of infix *)

(* Look up to see if s is a keyword, if so return the appropriate token otherwise use f to make token *)
let seeIfKw s f =
	try Hashtbl.find kwtable s with Not_found -> f s

let lineno = ref 1

}

let types = ['A'-'Z']['a'-'z''A'-'Z''0'-'9']*
let idents = ['a'-'z''A'-'Z''0'-'9']+
let operators = ['<''>''.'':''|''\\''?'':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}''=']+

let white = ['\t'' ']
let newline = '\n'

rule token = parse
	| newline               { incr lineno; SEP }
	| white+                { token lexbuf }
	| types                 { TYPE (lexeme lexbuf) }
	| idents                { seeIfKw (lexeme lexbuf) (fun s -> IDENT s) }
	| operators             { seeIfKw (lexeme lexbuf) (fun s -> OPL0 s) }
	| _                     { seeIfKw (lexeme lexbuf) (fun s -> BADTOK s) }