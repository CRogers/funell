open Print
open Printf
open Lexing

let print_lex file fmt_func lexer_func =
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	
	while not lexbuf.lex_eof_reached do
		Printf.printf "%s " (fmt_func (lexer_func lexbuf))
	done

let print_parse prog = print_endline (fmt_program prog)

let preparse file =
	(* Preparse the files so we can get the operator precedences *)
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	let pre = (try Preparser.program Prelexer.token lexbuf with
		| Preparser.Error ->
				let token = Lexing.lexeme lexbuf in
				err_msg ("Preparser could not parse token " ^ token) !Prelexer.lineno file;
				Printf.printf "\nPrelexer output:\n";
				print_lex file fmt_pretoken Prelexer.token; 0) in
		
		
		close_in in_chan;
		pre

let parse file =
	let in_chan = open_in file in
	let lexbuf = Lexing.from_channel in_chan in
	let prog = (try Parser.program Lexer.token lexbuf with 
		| Parser.Error -> 
			let token = Lexing.lexeme lexbuf in
			err_msg ("Parser could not recognise token " ^ token) !Lexer.lineno file;
			Printf.printf "\nLexer output:\n";
			print_lex file fmt_token Lexer.token; Tree.Program []) in
	
	close_in in_chan;
	prog

let main () =
	let args = Sys.argv in
	let file = Array.get args 1 in
	
	preparse file;
	let prog = parse file in
		
	print_parse prog;
	exit 0

let funell = main ()