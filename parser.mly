%token<string>	IDENT OPERATOR TYPE
%token<int> 	INTEGER
%token			INDENT OUTDENT SEP
%token 			EOF ASSIGN LPAR RPAR LET IN GUARD TYPEDECL
%token			BADTOK

%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	EOF                          { Program "foo" };