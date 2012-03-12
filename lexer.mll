let makehash n vs =
	let ht = Hashtbl.create n in
	List.iter vs (fun (k, v) -> Hashtbl.add ht k v) vs
	ht

(* A small hashtable for keywords *)
let kwtable = 
	makehash 64
	   []