{
module Parser
( parseCPP
) where
import Grammar
import Lexer
}

%name                   parseCPP
%tokentype              { Token }
%error                  { parseError }

%token

    WHILE               { TWhile }
    IF                  { TIf }
    ELSE                { TElse }
    RETURN              { TReturn }

    CIN                 { TCin }
    COUT                { TCout }
    '>>'                { TRShift }
    '<<'                { TLShift }

    INT                 { TIntType }
    DOUBLE              { TDoubleType }
    BOOL                { TBoolType }
    STRING              { TStringType }
    VOID                { TVoidType }

    TRUE                { TTrue }
    FALSE               { TFalse }

    '::'                { TDColon }
    ';'                 { TSemi }
    ','                 { TComma }

    '+'                 { TPlus }
    '-'                 { TMinus }
    '*'                 { TMul }
    '/'                 { TDiv }

    '=='                { TEq }
    '!='                { TNEq }
    '>='                { TGE }
    '<='                { TLE }
    '>'                 { TG }
    '<'                 { TL }

    '&&'                { TAnd }
    '||'                { TOr }
    '!'                 { TNot }

    '('                 { TLPar }
    ')'                 { TRPar }

    '{'                 { TLBr }
    '}'                 { TRBr }    

    '='                 { TAssign }

    NAME                { TName $$ }
    INT_VAL             { TInt $$ }
    DOUBLE_VAL          { TDouble $$ }
    STRING_VAL          { TString $$ }

%left '||'  
%left '&&' 
%left '!' 
%nonassoc '==' '!=' '<' '<=' '>' '>='
%left '+' '-'
%left '*' '/' 
%left '-'

%%

program 
    : functions                     { Program $1 }

functions
    : function functions            { $1 : $2 }
    | {- empty -}                   { [] }

function
    : ftype NAME '(' ')' body                               { Fun0 $1 $2 $5 }
    | ftype NAME '(' vtype NAME ')' body                    { Fun1 $1 $2 $4 $5 $7 }
    | ftype NAME '(' vtype NAME ',' vtype NAME ')' body     { Fun2 $1 $2 $4 $5 $7 $8 $10 }

body
    : '{' statements '}'        { $2 }

statements
    : statement statements          { $1 : $2 }  
    | {- empty -}                   { [] }

statement
	: simple_statement ';'              { $1 }
    | compound_statement ';'            { $1 }
    
simple_statement
    : vtype NAME '=' expr            { AssignStmt $1 $2 $4 }
    | NAME '=' expr                  { AssignStmtWithoutType $1 $3 }
	| RETURN expr                    { ReturnStmt $2 }
    | fname '('')'                   { Fun0Stmt $1 }
    | fname '(' expr ')'             { Fun1Stmt $1 $3 }
    | fname '(' expr ',' expr ')'    { Fun2Stmt $1 $3 $5 }
    | NAME '::' CIN '>>' expr        { ReadStmt $5 }
    | NAME '::' COUT '<<' expr       { WriteStmt $5 }



compound_statement
    : WHILE '(' expr ')' body                { WhileStmt $3 $5 }                 
    | IF '(' expr ')' body                   { IfStmt $3 $5 }   
    | IF '(' expr ')' body ELSE body         { IfElseStmt $3 $5 $7 } 

expr
    : expr '+' expr		            { ExprPlus $1 $3 }
    | expr '-' expr		            { ExprMinus $1 $3 }
    | expr '*' expr		            { ExprMul $1 $3 }
    | expr '/' expr		            { ExprDiv $1 $3 }
    | expr '==' expr                { ExprEq $1 $3 }
    | expr '!=' expr                { ExprNeq $1 $3 }
    | expr '>=' expr	            { ExprGE $1 $3 }
    | expr '<=' expr	            { ExprLE $1 $3 }
    | expr '>' expr		            { ExprGT $1 $3 }
    | expr '<' expr		            { ExprLT $1 $3 }
    | '-' expr                      { ExprNeg $2 }
    | expr '&&' expr	            { ExprAnd $1 $3 }
    | expr '||'  expr 	            { ExprOr $1 $3 }
    | '!'  expr                     { ExprNot $2 }
    | '(' expr ')'       		    { ExprBracketed $2 }
    | NAME				            { ExprVar $1 }
    | fname '(' ')'                 { ExprFun0 $1 }
    | fname '(' expr ')'            { ExprFun1 $1 $3 }
    | fname '(' expr ',' expr ')'   { ExprFun2 $1 $3 $5 }
    | value                         { ExprVal $1 }

fname
    : NAME                          { ("", $1) }
    | NAME '::' NAME                { ($1, $3) }


value 
    : vbool                          { $1 }
    | vint                           { $1 }
    | vdouble                        { $1 } 
    | vstring                        { $1 }

vbool
	: TRUE                          { BoolValue True }			
	| FALSE	                        { BoolValue False }

vint
    : INT_VAL                       { IntValue $1 }                                      

vdouble
    : DOUBLE_VAL                    { DoubleValue $1 }                        

vstring
    : STRING_VAL                    { StringValue $1 }   

ftype
    : INT                           { FIntType }
    | DOUBLE                        { FDoubleType }
    | BOOL                          { FBoolType }
    | STRING                        { FStringType }
    | VOID                          { VoidType }

vtype 
    : INT                           { IntType }
    | DOUBLE                        { DoubleType }
    | BOOL                          { BoolType }
    | STRING                        { StringType }

{
parseError :: [Token] -> a
parseError arg = error $ "Parse error" <> show arg

}                        						