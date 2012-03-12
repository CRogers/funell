type token =
  | IDENT of (string)
  | OPERATOR of (string)
  | TYPE of (string)
  | INTEGER of (int)
  | INDENT
  | OUTDENT
  | SEP
  | EOF
  | LET
  | BADTOK

open Parsing;;
# 11 "parser.mly"

open Tree

# 19 "parser.ml"
let yytransl_const = [|
  261 (* INDENT *);
  262 (* OUTDENT *);
  263 (* SEP *);
    0 (* EOF *);
  264 (* LET *);
  265 (* BADTOK *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* OPERATOR *);
  259 (* TYPE *);
  260 (* INTEGER *);
    0|]

let yylhs = "\255\255\
\001\000\000\000"

let yylen = "\002\000\
\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\001\000\002\000"

let yydgoto = "\002\000\
\004\000"

let yysindex = "\255\255\
\001\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000"

let yytablesize = 1
let yytable = "\001\000\
\003\000"

let yycheck = "\001\000\
\000\000"

let yynames_const = "\
  INDENT\000\
  OUTDENT\000\
  SEP\000\
  EOF\000\
  LET\000\
  BADTOK\000\
  "

let yynames_block = "\
  IDENT\000\
  OPERATOR\000\
  TYPE\000\
  INTEGER\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    Obj.repr(
# 19 "parser.mly"
          ( Program "foo" )
# 86 "parser.ml"
               : Tree.program))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Tree.program)
