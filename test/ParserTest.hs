module ParserTest where

import Test.Hspec
import TestUtil

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar
    ( Value(..)
    , ValType(..)
    , FunType(..)
    , Expr(..)
    , Stmt(..)
    , Fun(..)
    , Program(..)
    )

spec :: Spec
spec = do
    describe "test" $ do
        testParseFoo0WithoutStmt
        testParseFoo1WithStmt

testParseFoo0WithoutStmt ::  SpecWith (Arg Expectation)
testParseFooWithoutStmt =
  uTest
    "parsing function without stmts"
    parseCPP . alexScanTokens $ "int main() {}"
    Program [Fun0 ValType "main" []]

testParseFoo1WithStmt ::  SpecWith (Arg Expectation)
testParseFoo1WithStmt =
   uTest
    "parsing function1 with stmts"
    parseCPP . alexScanTokens $ "int a(int b) { return b; }"
    Program [Fun1 ValType "a" IntType "b" [ReturnStmt (ExprVar "b")]]

    