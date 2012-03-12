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

}

let types = ['A'-'Z']['a'-'z']+

rule token = parse
	  types					{ TYPE (lexeme lexbuf) }
	| eof					{ EOF }