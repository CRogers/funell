%token<string>  IDENT OPERATOR TYPE
%token<int>     INTEGER
%token          INDENT OUTDENT SEP
%token          EOF ASSIGN LPAR RPAR LET IN GUARD TYPEDECL
%token          BADTOK

%left OPERATOR
%left IDENT
%left ASSIGN

%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	| decls EOF                                                  { Program $1 };

decls:
	/* empty */                                                  { [] }
	| funcDecl decls                                             { $1 :: $2 };


funcDecl:
	| IDENT emptyIdentList ASSIGN callExpr                       { Decl ($1, $2, $4) }
	| OPERATOR IDENT IDENT ASSIGN callExpr                       { Decl ($1, [$2; $3], $5) };

callExpr:
	| IDENT emptyExprList                                        { Call ($1, $2) }
	| callExpr OPERATOR callExpr                                 { Call ($2, [$1; $3]) };

expr:
	| IDENT                                                      { Call ($1, []) }
	| LPAR callExpr RPAR                                         { $2 };

exprList:
	| expr exprList                                              { $1 :: $2 }
	| expr                                                       { [$1] };

emptyExprList:
	/* empty */                                                  { [] }
	| exprList                                                   { $1 };

identList:
	| IDENT identList                                            { $1 :: $2 }
	| IDENT                                                      { [$1] };
		
emptyIdentList:
	/* empty */                                                  { [] }
	| identList                                                  { $1 };