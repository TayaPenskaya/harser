module InterpreterSpec where

import Interpreter (interpretProgram)
import CDSL
import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)

import Test.Hspec
import TestUtil

spec :: Spec 
spec = describe "tests for interpreter" $ do
    testInterpretEmpty
    testInterpretOneVar
    testInterpretTwoVar
    testInterpretArithmetic

testInterpretEmpty :: SpecWith (Arg Expectation)
testInterpretEmpty = 
  uTest
    "interpreting empty program"
    (interpretCDSLWithST $ interpretProgram $ parseCPP $ alexScanTokens emptyProgram)
    (CInt 0)


testInterpretOneVar :: SpecWith (Arg Expectation)
testInterpretOneVar = 
  uTest
    "interpreting one var program"
    (interpretCDSLWithST $ interpretProgram $ parseCPP $ alexScanTokens oneVarProgram)
    (CInt 0)

testInterpretTwoVar :: SpecWith (Arg Expectation)
testInterpretTwoVar = 
  uTest
    "interpreting two vars program"
    (interpretCDSLWithST $ interpretProgram $ parseCPP $ alexScanTokens twoVarProgram)
    (CInt 0)

testInterpretArithmetic :: SpecWith (Arg Expectation)
testInterpretArithmetic = 
  uTest
    "interpreting arithmetic program"
    (interpretCDSLWithST $ interpretProgram $ parseCPP $ alexScanTokens arithmeticExprProgram)
    (CInt 912)