/* description: Simple expressions */

%lex
%%

\s+    { /* ignore */ }
"is"  { return 'IS'; }
"show" { return 'SHOW'; }
[0-9]+("."[0-9]+)? { return 'NUMBER'; }
[a-zA-Z]+ { return 'IDENT'; }
"+"    { return '+'; }
"."    { return '.'; }
<<EOF>> { return 'EOF'; }

/lex

%left '+'

%%

program
  : stmt_list EOF
    {{ return ['Program', {}].concat($1); }}
  ;

stmt_list
  : stmt '.'
    { $$ = [$1]; }
  | stmt_list stmt '.'
    { $1.push($2); $$ = $1; }
  ;

stmt
  : IDENT IS expr
    {{ $$ = ['IsStmt', {}, $1, $3]; }}
  | SHOW expr
    {{ $$ = ['ShowStmt', {}, $2]; }}
  ;

expr
  : IDENT
    {{ $$ = ['IdentExpr', {name: yytext} ]; }}
  | NUMBER
    {{ $$ = ['NumberLit', {val: Number(yytext)}]; }}
  | expr '+' expr
    {{ $$ = ['AddExpr', {}, $expr1, $expr2]; }}
  ;

