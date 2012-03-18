# Add --table on the next line to use Menhir's table-based back-end.
PGFLAGS         := --infer
GENERATED       := parser.ml parser.mli lexer.ml
MODULES         := tree print parser lexer main
EXECUTABLE      := bin/funell
OCAMLDEPWRAPPER := ocamldep.wrapper

include OCamlMakefile
$(eval $(call menhir_monomodule,parser))