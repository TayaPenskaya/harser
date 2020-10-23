module Main where

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar(Program(..))

main :: IO()
main = do
  s <-  getLine
  print (parseCPP . alexScanTokens $ s) 
