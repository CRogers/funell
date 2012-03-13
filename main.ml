open Print
open Printf
open Lexing

let print_lex file =
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	while not lexbuf.lex_eof_reached do
		Printf.printf "%s " (fmt_token (Lexer.token lexbuf))
	done

let print_parse prog = print_endline (fmt_program prog)

let main () =
	let args = Sys.argv in
	let file = Array.get args 1 in
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	let prog = try Parser.program Lexer.token lexbuf with
		| Parsing.Parse_error -> 
			let token = Lexing.lexeme lexbuf in
			err_msg ("Parser could not recognise token " ^ token) !Lexer.lineno file;
			Printf.printf "\nLexer output:\n";
			print_lex file;
			Tree.Program [] in
	
	print_parse prog;
	
	close_in in_chan;
	exit 0

let funell = main ()