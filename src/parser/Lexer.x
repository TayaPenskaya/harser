{
module Lexer 
( Token(..)
, alexScanTokens
) where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

    $white+                                     ;
    \\n                                         ;

    while                                       { \_ -> TWhile }
    if                                          { \_ -> TIf }
    else                                        { \_ -> TElse }
    return                                      { \_ -> TReturn }

    cin                                         { \_ -> TCin }
    cout                                        { \_ -> TCout }
    \>\>                                        { \_ -> TRShift }
    \<\<                                        { \_ -> TLShift }

    int                                         { \_ -> TIntType }
    double                                      { \_ -> TDoubleType }
    bool                                        { \_ -> TBoolType }
    string                                      { \_ -> TStringType }
    void                                        { \_ -> TVoidType }
    
    true                                        { \_ -> TTrue }
    false                                       { \_ -> TFalse }

    \:\:                                        { \_ -> TDColon }
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

    and                                         { \_ -> TAnd }
    or                                          { \_ -> TOr }
    not                                         { \_ -> TNot }

    \&\&                                        { \_ -> TAnd }
    \|\|                                        { \_ -> TOr }
    \!                                          { \_ -> TNot }

    \(                                          { \_ -> TLPar }
    \)                                          { \_ -> TRPar }

    \{                                          { \_ -> TLBr }
    \}                                          { \_ -> TRBr }

    \=                                          { \_ -> TAssign }

    $digit+                                     { \s -> TInt (read s :: Int) }
    $digit+ \. $digit+                          { \s -> TDouble (read s :: Double) }
    \"[^\"]*\"                                  { \s -> TString s }
    $alpha ([a-zA-Z0-9_])*                      { \s -> TName s }

{
data Token = TFun | TWhile | TIf | TElse | TReturn 
    | TCin | TCout | TRShift | TLShift
    | TIntType | TDoubleType | TBoolType | TStringType | TVoidType
    | TTrue | TFalse 
    | TDColon | TSemi | TComma 
    | TPlus | TMinus | TMul | TDiv 
    | TEq | TNEq | TGE | TLE | TG | TL 
    | TAnd | TOr | TNot 
    | TLPar | TRPar 
    | TLBr | TRBr 
    | TAssign
    | TInt Int | TDouble Double | TString String | TName String 
    deriving (Eq, Show)
}