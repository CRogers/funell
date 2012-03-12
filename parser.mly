%token<string>	IDENT OPERATOR TYPE
%token<int> 	INTEGER
%token 			EOF LET

%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	EOF									{ Program "foo" };