
%{
var num=0
%}


/* Definición Léxica */
%lex

%options case-insensitive

%%

"Evaluar"           return 'REVALUAR';
";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';

"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'POR';
"/"                 return 'DIVIDIDO';

/* Espacios en blanco */
[ \r\t]+            {}
\n                  {}

[0-9]+\b                return 'ENTERO';
([a-zA-Z_])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: expresion EOF { console.log( " "+$1.C3D )}
    | EOF { return " "}
;

expresion
	: expresion MAS t       { $$={TMP:"t"+num,C3D:$1.C3D+$3.C3D+"t"+num+"="+$1.TMP+"+"+$3.TMP+" "};
                                num++}
	| expresion MENOS t     { $$={TMP:"t"+num,C3D:$1.C3D+$3.C3D+"t"+num+"="+$1.TMP+"-"+$3.TMP+" "};
                                num++}
    | t     { $$ = $1 }
;

t
	: t POR f       { $$={TMP:"t"+num,C3D:$1.C3D+$3.C3D+"t"+num+"="+$1.TMP+"*"+$3.TMP+" "};
                                num++}
	| t DIVIDIDO f      { $$={TMP:"t"+num,C3D:$1.C3D+$3.C3D+"t"+num+"="+$1.TMP+"/"+$3.TMP+" "};
                                num++}
    | f     { $$ = $1 }
;

f
	: IDENTIFICADOR       { $$={TMP:$1,C3D:""} }
	| PARIZQ expresion PARDER       { $$ = $2; }
;

