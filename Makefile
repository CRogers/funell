all: funell

funell: *.ml *.mll *.mly
	ocamlbuild -use-menhir funell.native
	mv funell.native funell

automatons: 
	menhir --dump parser.mly
	menhir --dump preparser.mly
	$(call removeGen)

conflicts:
	menhir --explain parser.mly
	menhir --explain preparser.mly
	$(call removeGen)

removeGen = rm parser.ml parser.mli preparser.ml preparser.mli	

