funell: *.ml *.mll *.mly
	ocamlbuild -use-menhir funell.native
	mv funell.native funell
