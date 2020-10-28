module Main where

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar(Program(..), FunType(..), ValType(..))
import System.IO

main :: IO()
main = pure ()
  
-- main = do
  -- res <- test
  -- res2 <- test2
  -- res3 <- test3
  -- res4 <- test4
  -- print res
  -- print res2
  -- print res3
  -- print res4
  -- pure ()

-- main = print (parseCPP . alexScanTokens $ "int p(int a, int b) {return (a + b);}")

-- main = do
--   contents <- readFile "test.txt"
--   let parsed_contents = parseCPP . alexScanTokens $ contents
--   print parsed_contents