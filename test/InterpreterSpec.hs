module InterpreterSpec where

import Translator (translateProgram)
import Interpreter (interpretCDSLWithST)
import Lexer (alexScanTokens)
import Parser (parseCPP)
import CDSL (CVar(..))

import Test.Hspec
import TestUtil

spec :: Spec 
spec = describe "tests for interpreter" $ do
    testInterpretEmpty
    testInterpretOneVar
    testInterpretTwoVar
    testInterpretArithmetic
    testInterpretIfElse
    testWhileProgram
    testInterpretTwoFuncProgram
    testInterpretPassByValueProgram
    testDifferentScopeProgram

runProgram :: Program -> CVar
runProgram program = interpretCDSLWithST $ translateProgram $ parseCPP $ alexScanTokens program
                 
testInterpretEmpty :: SpecWith (Arg Expectation)
testInterpretEmpty = 
  uTest
    "interpreting empty program"
    (runProgram emptyProgram)
    (CInt 0)


testInterpretOneVar :: SpecWith (Arg Expectation)
testInterpretOneVar = 
  uTest
    "interpreting one var program"
    (runProgram oneVarProgram)
    (CInt 0)

testInterpretTwoVar :: SpecWith (Arg Expectation)
testInterpretTwoVar = 
  uTest
    "interpreting two vars program"
    (runProgram twoVarProgram)
    (CInt 1)

testInterpretArithmetic :: SpecWith (Arg Expectation)
testInterpretArithmetic = 
  uTest
    "interpreting arithmetic program"
    (runProgram arithmeticExprProgram)
    (CInt 912)
    
testInterpretIfElse :: SpecWith (Arg Expectation)
testInterpretIfElse = 
  uTest
    "interpreting if else program"
    (runProgram ifElseProgram)
    (CInt 5)

testWhileProgram :: SpecWith (Arg Expectation)
testWhileProgram = 
  uTest
    "interpreting while program"
    (runProgram whileProgram)
    (CInt 1) 
    
testInterpretTwoFuncProgram :: SpecWith (Arg Expectation)
testInterpretTwoFuncProgram = 
  uTest
    "interpreting two func program"
    (runProgram twoFuncProgram)
    (CInt 16)
    
testInterpretPassByValueProgram :: SpecWith (Arg Expectation)
testInterpretPassByValueProgram = 
  uTest
    "interpreting pass by value program"
    (runProgram passByValueProgram)
    (CInt 21)
    
testDifferentScopeProgram :: SpecWith (Arg Expectation)
testDifferentScopeProgram = 
  uTest
    "interpreting different scope program"
    (runProgram differentScopeProgram)
    (CInt 1)                   
        