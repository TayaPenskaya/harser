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
import CDSL (CExpr (..), CVar (..), Type, CVarW)

import Control.Monad.State (StateT, get, evalStateT)

import Control.Monad.Reader (Reader, runReader)

import qualified Data.Map as HM (Map (..), lookup, insert, empty)
import Data.List (find)


type Funs = HM.Map String Fun
type Vars expr = HM.Map String (expr (VarWrap expr CVarW))

-- test :: String -> CVar a
-- test programText = runST (interpretProgram programText)

type FunState expr = StateT (Vars expr) (Reader Funs)

interpretProgram :: CExpr expr => Program -> expr (CVar a)
interpretProgram program = let mainMaybe = findMain program in
   case mainMaybe of
    Nothing -> error "no main"
    Just main -> runProgram program main

runProgram :: CExpr expr => Program -> Fun -> expr (CVar a)
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

initialState :: CExpr expr => Program -> FunState expr (CVar a)
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

interpretFun :: CExpr expr => Fun -> FunState expr (expr (CVar a))
interpretFun fun =
  case fun of
    Fun0 fType fName stmts -> do
      stmtsDsl <- interpretStmts stmts
      pure $ cFun0 (interpretFunType fType) fName (@= stmtsDsl)
    Fun1 fType fName vType vName stmts -> do
      vars <- get
      case HM.lookup vName vars of
        Nothing -> error $ "no such variable " ++ vName
        Just varRef -> do
          stmtsDsl <- interpretStmts stmts
          pure $ cFun0 (interpretFunType fType) fName (@= stmtsDsl)


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

interpretValue :: Value -> expr (CVar a)
interpretValue (IntValue v) = cVarWrap v
interpretValue (StringValue v) = cVarWrap v
interpretValue (DoubleValue v) = cVarWrap v
interpretValue (BoolValue v) = cVarWrap v

interpretExpr :: Expr -> FunState expr (expr (CVar a))
interpretExpr (ExprPlus expr1 expr2) = pure $ interpretExpr expr1 @+ interpretExpr expr2
interpretExpr (ExprMinus expr1 expr2) = pure $ interpretExpr expr1 @- interpretExpr expr2
interpretExpr (ExprMul expr1 expr2) = pure $ interpretExpr expr1 @* interpretExpr expr2
interpretExpr (ExprDiv expr1 expr2) = pure $ interpretExpr expr1 @/ interpretExpr expr2
interpretExpr (ExprEq expr1 expr2) = pure $ interpretExpr expr1 @== interpretExpr expr2
interpretExpr (ExprNeq expr1 expr2) = pure $ interpretExpr expr1 @/= interpretExpr expr2
interpretExpr (ExprGE expr1 expr2) = pure $ interpretExpr expr1 @>= interpretExpr expr2
interpretExpr (ExprLE expr1 expr2) = pure $ interpretExpr expr1 @<= interpretExpr expr2
interpretExpr (ExprGT expr1 expr2) = pure $ interpretExpr expr1 @> interpretExpr expr2
interpretExpr (ExprLT expr1 expr2) = pure $ interpretExpr expr1 @< interpretExpr expr2


interpretStmts :: [Stmt] -> FunState expr (expr (CVar a))
interpretStmts = undefined 