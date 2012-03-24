all: funell

funell: *.ml *.mll *.mly
	ocamlbuild -use-menhir funell.native
	mv funell.native funell

automatons: 
	menhir --dump parser.mly
	menhir --dump preparser.mly
	rm parser.ml parser.mli preparser.ml preparser.mli	

