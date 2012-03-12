%token<string>	IDENT OPERATOR TYPE
%token<int> 	INTEGER
%token			INDENT OUTDENT SEP
%token 			EOF LET ASSIGN
%token			BADTOK

%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	EOF						{ Program "foo" };