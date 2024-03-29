exception Operator_not_found of string

open Parser

(* A hashtable to keep a list of infix operator precedents *)
let optable: (string, Parser.token) Hashtbl.t = 
	let ht = Hashtbl.create 64 in
	List.iter (fun (k,v) -> Hashtbl.add ht k v) [("+", OPL2 "+"); ("-", OPL2 "-"); ("*", OPL3 "*"); ("/", OPL4 "/")];
	ht 

let getOperator op = 
	try Hashtbl.find optable op
	with Not_found -> raise (Operator_not_found op)
 