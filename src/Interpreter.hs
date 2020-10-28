{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE RankNTypes                #-}
{-# LANGUAGE ScopedTypeVariables       #-}

module Interpreter
  ( interpretProgram
  ) where

import Grammar (Expr (..), Fun (..), FunType (..),
                Program (..), Stmt (..), ValType (..),
                Value (..))
import CDSL (CExpr (..), CVar (..), Type, Ref)

import Control.Monad.State (StateT, get, evalStateT, modify)

import Control.Monad.Reader (Reader, runReader)

import qualified Data.Map as HM (Map (..), lookup, insert, empty)
import Data.List (find)
import Data.Maybe (fromMaybe, fromJust)
import Control.Applicative (liftA2)


type Funs = HM.Map String Fun

type Vars expr = HM.Map String (Ref expr)

type FunState expr = StateT (Vars expr) (Reader Funs)

interpretProgram :: CExpr expr => Program -> expr CVar
interpretProgram program = let mainMaybe = findMain program in
   case mainMaybe of
    Nothing -> error "no main"
    Just main -> runProgram program main

runProgram :: CExpr expr => Program -> Fun -> expr CVar
runProgram program main =
  runReader
    (evalStateT (interpretFun main) initialVars)
    (initialFuns program)

initialVars :: CExpr expr => Vars expr
initialVars = HM.empty

initialFuns :: Program -> Funs
initialFuns (Program funs) = foldr helper HM.empty $ takeWhile (Prelude.not . isNameMain) funs
  where
    helper fun = HM.insert (funName fun) fun

initialState :: CExpr expr => Program -> FunState expr CVar
initialState program = undefined

findMain :: Program -> Maybe Fun
findMain (Program funs) = find isNameMain funs

isNameMain :: Fun -> Bool
isNameMain fun = funName fun == "main"

funName :: Fun -> String
funName (Fun0 _ name _) = name
funName (Fun1 _ name _ _ _) = name
funName (Fun2 _ name _ _ _ _ _) = name

--
-- Grammar -> CDSL
--

interpretFun :: CExpr expr => Fun -> FunState expr (expr CVar)
interpretFun fun =
  case fun of
    Fun0 _ _ stmts -> interpretStmts stmts
    Fun1 fType fName vType vName stmts -> do
      modify $ insertVar vType vName
      interpretStmts stmts
    Fun2 fType fName v1Type v1Name v2Type v2Name stmts -> do
      modify $ insertVar v1Type v1Name
      modify $ insertVar v2Type v1Name
      interpretStmts stmts
  where
    insertVar vType vName = HM.insert vName $ mkRef (interpretValType vType)

interpretValType :: ValType -> String
interpretValType IntType = "int"
interpretValType DoubleType = "double"
interpretValType BoolType = "bool"
interpretValType StringType = "string"
      
interpretFunType :: FunType -> String
interpretFunType FIntType = "int"
interpretFunType FDoubleType = "double"
interpretFunType FBoolType = "bool"
interpretFunType FStringType = "string"
interpretFunType VoidType = "void"

interpretValue :: CExpr expr => Value -> expr CVar
interpretValue (IntValue v) = cVarWrap (CInt v)
interpretValue (StringValue v) = cVarWrap (CString v)
interpretValue (DoubleValue v) = cVarWrap (CDouble v)
interpretValue (BoolValue v) = cVarWrap (CBool v)

interpretExpr :: CExpr expr => Expr -> FunState expr (expr CVar)
interpretExpr (ExprPlus expr1 expr2) = liftA2 (@+) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprMinus expr1 expr2) = liftA2 (@-) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprMul expr1 expr2) = liftA2 (@*) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprDiv expr1 expr2) = liftA2 (@/) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprEq expr1 expr2) = liftA2 (@==) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprNeq expr1 expr2) = liftA2 (@/=) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprGE expr1 expr2) = liftA2 (@>=) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprLE expr1 expr2) = liftA2 (@<=) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprGT expr1 expr2) = liftA2 (@>) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprLT expr1 expr2) = liftA2 (@<) (interpretExpr expr1) (interpretExpr expr2)

interpretStmts :: [Stmt] -> FunState expr (expr CVar)
interpretStmts = undefined 