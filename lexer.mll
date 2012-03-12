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

(* There are a few reserved symbols, however we want poeople to be able to use theses symbols as parts *)
(* of larger operators, so don't allow reservedOps on their own but allow them when combined *)
let op = ['<''>''.'':''|''\\''?'':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}''=']
let reservedOp = ['=''|']
let opNoRes = op # reservedOp
let operators = opNoRes+ | op* reservedOp op+ | op+ reservedOp op*

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
	| operators 			{ OPERATOR (lexeme lexbuf) }
	| '='					{ ASSIGN }
	| eof					{ EOF }
	| _						{ BADTOK }