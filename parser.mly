%token<string>	IDENT OPERATOR TYPE
%token<int> 	INTEGER
%token			INDENT OUTDENT SEP
%token 			EOF LET
%token			BADTOK

%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	EOF						{ Program "foo" };