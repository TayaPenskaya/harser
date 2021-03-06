module ParserSpec where

import           Test.Hspec
import           TestUtil

import           Grammar    (Expr (..), Fun (..), FunType (..), Program (..),
                             Stmt (..), ValType (..), Value (..))
import           Lexer      (Token (..), alexScanTokens)
import           Parser     (parseCPP)

spec :: Spec
spec = describe "tests for parser" $ do
    testParseFoo0WithoutStmt
    testParseFoo1WithStmt
    testParseFoo2WithFoo
    testParseFoo2WithStdFoo

testParseFoo0WithoutStmt :: SpecWith (Arg Expectation)
testParseFoo0WithoutStmt =
  uTest
    "parsing function without stmts"
    (parseCPP . alexScanTokens $ "int main() {}") $
    Program [Fun0 FIntType "main" []]

testParseFoo1WithStmt :: SpecWith (Arg Expectation)
testParseFoo1WithStmt =
   uTest
    "parsing function1 with stmts"
    (parseCPP . alexScanTokens $ "int a(int b) { return b; }") $
    Program [Fun1 FIntType "a" IntType "b" [ReturnStmt (ExprVar "b")]]

testParseFoo2WithFoo :: SpecWith (Arg Expectation)
testParseFoo2WithFoo =
   uTest
    "parsing function2 with foo without namespace"
    (parseCPP . alexScanTokens $ "int a(int b, string c) { return d(); }") $
    Program [Fun2 FIntType "a" IntType "b" StringType "c" [ReturnStmt (ExprFun0 ("","d"))]]

testParseFoo2WithStdFoo :: SpecWith (Arg Expectation)
testParseFoo2WithStdFoo =
   uTest
    "parsing function2 with foo with namespace"
    (parseCPP . alexScanTokens $ "int a(int b, string c) { return std::d(); }") $
    Program [Fun2 FIntType "a" IntType "b" StringType "c" [ReturnStmt (ExprFun0 ("std","d"))]]

testParseFooWithStmts :: SpecWith (Arg Expectation)
testParseFooWithStmts =
   uTest
    "parsing function with stmts"
    (parseCPP . alexScanTokens $ "int main() {int a = 5; b = 6; return a+b; }") $
    Program [Fun0 FIntType "main" [AssignStmt IntType "a" (ExprVal (IntValue 5)),AssignStmtWithoutType "b" (ExprVal (IntValue 6)),ReturnStmt (ExprPlus (ExprVar "a") (ExprVar "b"))]]
