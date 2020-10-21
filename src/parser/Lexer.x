{
    module Lexer where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

    $white+                                     ;

    while                                       { \_ -> TWhile }
    return                                      { \_ -> TReturn }
    True                                        { \_ -> TTrue }
    False                                       { \_ -> TFalse }
    def                                         { \_ -> TDef }
    and                                         { \_ -> TAnd }
    or                                          { \_ -> TOr }
    not                                         { \_ -> TNot }

    \:                                          { \_ -> TColon }
    \;                                          { \_ -> TSemi }
    \,                                          { \_ -> TComma }

    \+                                          { \_ -> TPlus }
    \-                                          { \_ -> TMinus }
    \*                                          { \_ -> TMul }
    \/                                          { \_ -> TDiv }

    \=\=                                        { \_ -> TEq }
    \!\=                                        { \_ -> TNEq }
    \>\=                                        { \_ -> TGE }
    \<\=                                        { \_ -> TLE }
    \>                                          { \_ -> TG }
    \<                                          { \_ -> TL }

    \&\&                                        { \_ -> TAnd }
    \|\|                                        { \_ -> TOr }
    \!                                          { \_ -> TNot }

    \(                                          { \_ -> TLPar }
    \)                                          { \_ -> TRPar }

    \{                                          { \_ -> TLBr }
    \}                                          { \_ -> TRbr }

    \=                                          { \_ -> TAssign }

    $digit+                                     { \s -> TInt (read s) }
    $digit+ \. $digit+                          { \s -> TDouble (read s) }
    $alpha ([a-za-z0-9_])*                      { \s -> TName s }
    \'[^\']*\'                                  { \s -> TString s }

{
data Token = TWhile | TReturn | TTrue | TFalse | TDef | TAnd | TOr | TNot
    | TColon | TSemi | TComma 
    | TPlus | TMinus | TMul | TDiv 
    | TEq | TNEq | TGE | TLE | TG | TL 
    | TAnd | TOr | TNot 
    | TLPar | TRPar | TLBr | TRbr | TAssign
    | TInt Int | TDouble Double | TName String | TString String
    deriving (Eq, Show)
}