module Main where

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar(Program(..))
import CDSL(test2, test, test3, test4)

main :: IO()
-- main = do
--   s <-  getLine
--   print (parseCPP . alexScanTokens $ s) 
main = do
  res <- test
  res2 <- test2
  res3 <- test3
  res4 <- test4
  print(res)
  print(res2)
  print(res3)
  print(res4)
  pure ()