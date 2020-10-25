module Main where

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar(Program(..))
import CDSL(test2, test)

main :: IO()
-- main = do
--   s <-  getLine
--   print (parseCPP . alexScanTokens $ s) 
main = do
  res <- test
  res2 <- test2
  print(res)
  print(res2)
  pure ()