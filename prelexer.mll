{
	
open Preparser
open Lexing
open Tree

let lineno = ref 1

}

let newline = '\n'
let operators = ['<''>''.'':''|''\\''?'':''~''#''!''@''$''%''^''&''*''-''+''*''/''['']''{''}''=']+
let num = ['1'-'9']+

rule token = parse
	| newline               { incr lineno; SEP }
	| "infixl"              { INFIXL }
	| "infixr"              { INFIXR }
	| operators             { OPERATOR }
	| num                   { NUMBER (int_of_string (lexeme lexbuf)) }
	| eof                   { EOF }
	| _                     { token lexbuf }