{
	
open Preparser
open Lexing
open Tree

let lineno = ref 1

}

let newline = '\n'
let operators = ['<''>''.'':''|''\\''?'':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}''=']+
let num = ['0'-'9']+

rule token = parse
	| newline               { incr lineno; LINEBREAK }
	| "infixl"              { INFIXL }
	| "infixr"              { INFIXR }
	| operators             { OPERATOR (lexeme lexbuf) }
	| num                   { NUMBER (int_of_string (lexeme lexbuf)) }
	| eof                   { PREEOF }
	| _                     { token lexbuf }