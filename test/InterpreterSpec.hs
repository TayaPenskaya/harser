module InterpreterSpec where

import Interpreter (interpretProgram)

import Test.Hspec
import TestUtil

spec :: Spec 

testInterpretEmpty :: SpecWith (Arg Expectation)
testInterpretEmpty = 
  uTest
    "interpreting empty program"
    (interpretProgram emptyProgram)
    CInt 0


testInterpretOneVar :: SpecWith (Arg Expectation)
testInterpretOneVar = 
  uTest
    "interpreting one var program"
    (interpretProgram oneVarProgram)
    CInt 0

testInterpretTwoVar :: SpecWith (Arg Expectation)
testInterpretTwoVar = 
  uTest
    "interpreting two vars program"
    (interpretProgram twoVarProgram)
    CInt 0

testInterpretArithmetic :: SpecWith (Arg Expectation)
testInterpretTwoVar = 
  uTest
    "interpreting arithmetic program"
    (interpretProgram arithmeticExprProgram)
    CInt 73