module Main where

import Lexer(Token(..), alexScanTokens)
import Parser(parseCPP)
import Grammar(Program(..))
import CDSL(Interpret(..), test)

main :: IO()
-- main = do
--   s <-  getLine
--   print (parseCPP . alexScanTokens $ s) 
main = print (interpret test)