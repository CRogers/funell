%token<string>  IDENT TYPE
%token<int>     INTEGER
%token          EOF SEP ASSIGN LPAR RPAR LET IN OPINFIXR OPINFIXL
%token<string>  BADTOK
%token<string>  OPL0 OPL1 OPL2 OPL3 OPL4 /*OPL5 OPL6 OPL7 OPL8 OPL9 OPL10 OPL11 OPL12 OPL13 OPL14 OPL15 OPL16 OPL17 OPL18 OPL19 OPL20*/
%token<string>  OPR0 OPR1 OPR2 OPR3 OPR4 /*OPR5 OPR6 OPR7 OPR8 OPR9 OPR10 OPR11 OPR12 OPR13 OPR14 OPR15 OPR16 OPR17 OPR18 OPR19 OPR20*/

%left  OPL0
%right OPR0
%left  OPL1
%right OPR1
%left  OPL2
%right OPR2
%left  OPL3
%right OPR3
%left  OPL4
%right OPR4

%{

open Tree

%}

%start program
%type<Tree.program> program

%%

program:
	| decls EOF                                                  { Program $1 };

decls:
	/* empty */                                                  { [] }
	| funcDecl SEP decls                                         { $1 :: $3 }
	| opinfix operator INTEGER SEP d=decls                       { d }
	| SEP decls                                                  { $2 }

%inline opinfix:
	| OPINFIXR                                                   {}
	| OPINFIXL                                                   {}

funcDecl:
	| IDENT emptyIdentList ASSIGN expr                           { Decl ($1, $2, $4) }
	| i1=IDENT; op=operator; i2=IDENT; ASSIGN; e=expr            { Decl (op, [i1; i2], e) };

/* Synatical expressions */
expr:
	| LET funcDecl IN expr                                       { $4 }
	| applyExpr                                                  { $1 }

/* Function calls */
applyExpr:
	| basicExpr                                                  { $1 }
	| IDENT basicExpr                                            { Apply (Ident $1, $2) }
	| e1=applyExpr; op=operator; e2=applyExpr                    { binOp op e1 e2 }

/* Basic tokens */
basicExpr:
	| IDENT                                                      { Ident $1 }
	| INTEGER                                                    { Int $1 }
	| LPAR expr RPAR                                             { $2 };
		

identList:
	| IDENT identList                                            { $1 :: $2 }
	| IDENT                                                      { [$1] };
		
emptyIdentList:
	/* empty */                                                  { [] }
	| identList                                                  { $1 };

%inline operator:
	| op = OPL0                                                  { op }
	| op = OPL1                                                  { op }
	| op = OPL2                                                  { op }
	| op = OPL3                                                  { op }
	| op = OPL4                                                  { op }
	| op = OPR0                                                  { op }
	| op = OPR1                                                  { op }
	| op = OPR2                                                  { op }
	| op = OPR3                                                  { op }
	| op = OPR4                                                  { op }