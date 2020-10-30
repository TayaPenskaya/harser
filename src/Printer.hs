{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE InstanceSigs      #-}
{-# LANGUAGE TypeFamilies      #-}


module Printer
  ( Printer (toStr)
  , printProgram
  ) where

import           CDSL
import           Data.IORef
import           Data.Typeable
import           Debug.Trace   (trace)
import Data.List (intercalate)
import Translator (translateFunctions)
import Parser (parseCPP)
import Lexer (alexScanTokens)

type Indent = String

newtype Printer a = Printer { toStr :: Indent -> String }

printProgram :: String -> String
printProgram program = intercalate "\n" $ map (`toStr` "") (translateFunctions $ parseCPP $ alexScanTokens program)

data CVarToS a = CVarToS

instance CExpr Printer where
  type (VarWrap Printer) = CVarToS
  pur a = Printer $ const ""
  cVarWrap a = Printer $ \_ -> show a

  (@+) = showBinOp "+"
  (@*) = showBinOp "*"
  (@-) = showBinOp "-"
  (@/) = showBinOp "/"
  (@<) = showBinOp "<"
  (@<=) = showBinOp "<="
  (@>) = showBinOp ">"
  (@>=) = showBinOp ">="
  (@==) = showBinOp "=="
  (@/=) = showBinOp "/="

  (#) a b = Printer $ \pr -> toStr a pr <> ";\n" <> toStr b pr
  (@=) a b = Printer $ \pr -> pr <> toStr a pr  <> " = " <> toStr b pr
  cReturn a b = Printer $ \pr -> pr <> "return " <> toStr b pr <> ";\n"
  
  (@&&) = showBinOp "&&"
  (@||) = showBinOp "||"
  neg a = Printer $ \pr -> "-" <> toStr a pr
  not a = Printer $ \pr -> "!" <> toStr a pr

  cWithVar vType vName value func = Printer $ \pr ->
    pr <> vType <> " " <> vName <> " = " <> toStr value pr <> ";\n"
       <> toStr (func $ Printer $ const vName) pr

  cFun0 isCall fType fName func = Printer $ \pr ->
    if isCall
    then getFunStr True fType fName []
    else pr <> getFunStr False fType fName [] <> " {\n"
            <> pr <> toStr (func (Printer $ const "")) (pr <> "  ")
            <> pr <> "}\n"

  cFun1 isCall fType fName func argType argName arg = Printer $ \pr ->
    if isCall
    then getFunStr True fType fName [(argType, argName, "")]
    else do
      let arg' = toStr arg pr
      let f1 = toStr (func (Printer $ const "") (Printer $ const argName)) (pr <> "  ")
      pr <> getFunStr False fType fName [(argType, argName, arg')] <> " {\n"
                <> pr <> f1
                <> pr <> "}\n"

  cFun2 isCall fType fName func arg1Type arg1Name arg1 arg2Type arg2Name arg2 = Printer $ \pr ->
    if isCall
    then getFunStr True fType fName [(arg1Type, arg1Name, ""), (arg2Type, arg2Name, "")]
    else do
      let arg1' = toStr arg1 pr
      let arg2' = toStr arg2 pr
      let f1 = toStr (func (Printer $ const "")
                        (Printer $ const arg1Name)
                        (Printer $ const arg2Name)) (pr <> "  ")
      pr <> getFunStr False fType fName [(arg1Type, arg1Name, arg1'), (arg2Type, arg2Name, arg2')]  <> " {\n"
                <> pr <> f1
                <> pr <> "}\n"

  cWhile runPred runStmt runCont = Printer $ \pr ->
    pr <> "while " <> toStr (runPred ()) pr <> " {\n"
       <> toStr (runStmt ()) (pr <> "  ")
       <> pr <> "}\n"
       <> toStr (runCont ()) pr

  cIf pred runThen runCont = Printer $ \pr ->
    pr <> "if " <> toStr pred pr <> " {\n"
       <> toStr (runThen ()) (pr <> "  ")
       <> pr <> "}\n"
       <> toStr (runCont ()) pr

  cIfElse pred runThen runElse runCont = Printer $ \pr ->
    pr <> "if " <> toStr pred pr <> " {\n"
       <> toStr (runThen ()) (pr <> "  ")
       <> pr <> "} else {\n"
       <> toStr (runElse ()) (pr <> "  ")
       <> pr <> "}\n"
       <> toStr (runCont ()) pr

  cRead a = Printer $ \pr -> pr <> "std::cin >> " <> toStr a pr

  cWrite a = Printer $ \pr -> pr <> "std::cout << " <> toStr a pr

  cReadVar a = Printer $ \pr -> toStr a pr

showBinOp :: String -> Printer CVar -> Printer CVar -> Printer CVar
showBinOp op a b = Printer (\pr -> "(" <> toStr a pr  <> " " <> op <> " " <>toStr b pr <> ")")

getFunStr :: Bool -> String -> String -> [(String, String, String)] -> String
getFunStr isCall fType fName args =
   if isCall
   then fName <> "(" <> foldr joinerCall "" args <> ")"
   else fType <> " " <> fName <> "(" <> foldr joinerDef "" args <> ")"
    where
      joinerCall (_, _, arg) []   = arg
      joinerCall (_, _, arg) done = arg <> "," <> done
      joinerDef (argType, argName, _) [] = argType <> " " <> argName
      joinerDef  (argType, argName, _) done = argType <> " " <> argName  <> "," <> done
