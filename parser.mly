%token<string>  IDENT TYPE
%token<int>     INTEGER
%token          INDENT OUTDENT SEP
%token          EOF ASSIGN LPAR RPAR LET IN GUARD TYPEDECL
%token<string>  BADTOK
%token<string>  OPL0 OPL1 OPL2 OPL3 OPL4 /*OPL5 OPL6 OPL7 OPL8 OPL9 OPL10 OPL11 OPL12 OPL13 OPL14 OPL15 OPL16 OPL17 OPL18 OPL19 OPL20*/
%token<string>  OPR0 OPR1 OPR2 OPR3 OPR4 /*OPR5 OPR6 OPR7 OPR8 OPR9 OPR10 OPR11 OPR12 OPR13 OPR14 OPR15 OPR16 OPR17 OPR18 OPR19 OPR20*/

%left  OPL0 OPL1 OPL2 OPL3 OPL4
%right OPR0 OPR1 OPR2 OPR3 OPR4
%left  IDENT
%left  ASSIGN


%start program
%type<Tree.program> program

%{

open Tree

%}

%%

program:
	| decls                                                      { Program $1 };

decls:
	/* empty */                                                  { [] }
	| funcDecl SEP decls                                         { $1 :: $3 };


funcDecl:
	| IDENT emptyIdentList ASSIGN callExpr                       { Decl ($1, $2, $4) }
	| IDENT operator IDENT ASSIGN callExpr                       { Decl ($2, [$1; $3], $5) };

/* Synatical expressions */
expr:
	| LET funcDecl IN expr                                       { $4 }
	| expr0                                                      { $1 }

/* Level 0 operators */
expr0:
	| expr0 OPL0 expr1                                           { binOp $2 $1 $3 }
	| expr0 OPR0 expr1                                           { binOp $2 $1 $3 }
	| expr1                                                      { $1 }

/* Level 1 operators */
expr1:
	| expr1 OPL1 expr2                                           { binOp $2 $1 $3 }
	| expr1 OPR1 expr2                                           { binOp $2 $1 $3 }
	| expr2                                                      { $1 }

/* Level 2 operators */
expr2:
	| expr2 OPL2 expr3                                           { binOp $2 $1 $3 }
	| expr2 OPR2 expr3                                           { binOp $2 $1 $3 }
	| expr3                                                      { $1 }

/* Level 3 operators */
expr3:
	| expr3 OPL3 expr4                                           { binOp $2 $1 $3 }
	| expr3 OPR3 expr4                                           { binOp $2 $1 $3 }
	| expr4                                                      { $1 }

/* Level 4 operators */
expr4:
	| expr4 OPL4 callExpr                                        { binOp $2 $1 $3 }
	| expr4 OPR4 callExpr                                        { binOp $2 $1 $3 }
	| callExpr                                                   { $1 }

/* Function calls */
callExpr:
	| IDENT basicExpr                                            { Apply (Ident $1, $2) }
	| basicExpr                                                  { $1 }

/* Basic tokens */
basicExpr:
	| IDENT                                                      { Ident $1 }
	| LPAR expr RPAR                                             { $2 };
		

identList:
	| IDENT identList                                            { $1 :: $2 }
	| IDENT                                                      { [$1] };
		
emptyIdentList:
	/* empty */                                                  { [] }
	| identList                                                  { $1 };

operator:
	| OPL0                                                       { $1 }
	| OPL1                                                       { $1 }
	| OPL2                                                       { $1 }
	| OPL3                                                       { $1 }
	| OPL4                                                       { $1 }
	| OPR0                                                       { $1 }
	| OPR1                                                       { $1 }
	| OPR2                                                       { $1 }
	| OPR3                                                       { $1 }
	| OPR4                                                       { $1 }