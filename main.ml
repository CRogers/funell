open Lexer
open Lexing
open Print
open Printf

let main () =
	let args = Sys.argv in
	let file = Array.get args 1 in
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	while not lexbuf.lex_eof_reached do
		Printf.printf "%s " (fmt_token (Lexer.token lexbuf))
	done

let funell = main ()