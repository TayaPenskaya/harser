{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE RankNTypes                #-}
{-# LANGUAGE ScopedTypeVariables       #-}

module Interpreter
  ( interpretProgram
  ) where

import Grammar (Expr (..), Fun (..), FunType (..),
                Program (..), Stmt (..), ValType (..),
                Value (..), Name)
import CDSL (CExpr (..), CVar (..), Type, Ref)

import Control.Monad.State (StateT, get, evalStateT, modify)

import Control.Monad.Reader (Reader, runReader, ask)

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
    Fun0 fType fName stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      interpretStmts fName stmts
      pure $ cReadVar retVar
    Fun1 fType fName vType vName stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      modify $ insertVar vType vName
      interpretStmts fName stmts
      pure $ cReadVar retVar
    Fun2 fType fName v1Type v1Name v2Type v2Name stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      modify $ insertVar v1Type v1Name
      modify $ insertVar v2Type v2Name
      interpretStmts fName stmts
      pure $ cReadVar retVar

interpretCallFun :: CExpr expr => Fun -> [expr CVar] -> FunState expr (expr CVar)
interpretCallFun fun args =
  case fun of
    Fun0 fType fName stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      interpretStmts fName stmts
      pure $ cReadVar retVar
    Fun1 fType fName vType vName stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      let argRef = mkRef $ interpretValType vType
      pure $ argRef @= head args
      modify $ HM.insert vName argRef 
      interpretStmts fName stmts
      pure $ cReadVar retVar
    Fun2 fType fName v1Type v1Name v2Type v2Name stmts -> do
      let retVar = mkRef (interpretFunType fType)
      modify $ HM.insert fName retVar
      modify $ insertRetVar fType fName
      modify $ insertVar v1Type v1Name
      modify $ insertVar v2Type v1Name
      interpretStmts fName stmts
      pure $ cReadVar retVar

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
interpretExpr (ExprNeg expr) = fmap neg (interpretExpr expr)
interpretExpr (ExprAnd expr1 expr2) = liftA2 (@&&) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprOr expr1 expr2) = liftA2 (@||) (interpretExpr expr1) (interpretExpr expr2)
interpretExpr (ExprNot expr) = fmap CDSL.not (interpretExpr expr)
interpretExpr (ExprBracketed expr) = interpretExpr expr
interpretExpr (ExprVar vname) = do
  vars <- get
  let mvar = HM.lookup vname vars
  case mvar of 
    Nothing -> error "no such variable in scope"
    Just a -> pure $ cReadVar a
interpretExpr (ExprFun0 (namespace, fname)) = do
  funs <- ask
  let mfun = HM.lookup fname funs
  case mfun of 
    Nothing -> error "no such fun in scope"
    Just f -> do
      res <- interpretCallFun f []
      pure $ cCallFun fname res 
interpretExpr (ExprFun1 (namespace, fname) expr) = do
  funs <- ask
  let mfun = HM.lookup fname funs
  case mfun of 
    Nothing -> error "no such fun in scope"
    Just f -> do
      arg <- interpretExpr expr
      res <- interpretCallFun f [arg]
      pure $ cCallFun fname res 
interpretExpr (ExprFun2 (namespace, fname) expr1 expr2) = do
  funs <- ask
  let mfun = HM.lookup fname funs
  case mfun of 
    Nothing -> error "no such fun in scope"
    Just f -> do
      arg1 <- interpretExpr expr1
      arg2 <- interpretExpr expr2
      res <- interpretCallFun f [arg1, arg2]
      pure $ cCallFun fname res 
interpretExpr (ExprVal val) = pure $ interpretValue val


-- (a -> b -> b) -> b -> [a] -> b
interpretStmts :: CExpr expr => String -> [Stmt] -> FunState expr (expr ())
interpretStmts fName [x] = interpretStmt fName x
interpretStmts fName (x:xs) = interpretStmt fName x >> interpretStmts fName xs

interpretStmt :: CExpr expr => String -> Stmt -> FunState expr (expr ())
interpretStmt fName stmt = case stmt of
  AssignStmt vType vName expr -> do
    vars <- get
    dslExpr <- interpretExpr expr
    let maybeVar = HM.lookup vName vars
    case maybeVar of
      Just _ -> error $ "Variable `" ++ vName ++ "` already exists"
      Nothing -> pure $ cWithVar (interpretValType vType) vName dslExpr (@= dslExpr)
  AssignStmtWithoutType vName expr -> do
    vars <- get
    dslExpr <- interpretExpr expr
    let maybeVar = HM.lookup vName vars
    case maybeVar of
      Nothing -> error $ "Undefined variable `" ++ vName ++ "`"
      Just var -> pure $ var @= dslExpr
  ReturnStmt expr -> do
    vars <- get
    dslExpr <- interpretExpr expr
    let maybeRetVar = HM.lookup fName vars
    case maybeRetVar of
      Nothing -> error $ "Statement" ++ show stmt ++ "is outside the function"
      Just retVar -> pure $ retVar @= dslExpr
  Fun0Stmt (namespace, fName) -> do
    funs <- ask
    let maybeFun = HM.lookup fName funs
    case maybeFun of 
      Nothing -> error $ "Undefined function `" ++ show fName ++ "`"
      Just fun -> do
        res <- interpretCallFun fun []
        pure $ cCallFun fName res >> pure ()
  Fun1Stmt (namespace, fName) expr1 -> do
    funs <- ask
    let maybeFun = HM.lookup fName funs
    case maybeFun of 
      Nothing -> error $ "Undefined function `" ++ show fName ++ "`"
      Just fun -> do
        arg <- interpretExpr expr1
        res <- interpretCallFun fun [arg]
        pure $ cCallFun fName res >> pure ()  
  Fun2Stmt (namespace, fName) expr1 expr2 -> do
    funs <- ask
    let maybeFun = HM.lookup fName funs
    case maybeFun of 
      Nothing -> error $ "Undefined function `" ++ show fName ++ "`"
      Just fun -> do
        arg1 <- interpretExpr expr1
        arg2 <- interpretExpr expr2
        res <- interpretCallFun fun [arg1, arg2]
        pure $ cCallFun fName res >> pure () 

insertVar :: CExpr expr => ValType -> String -> Vars expr -> Vars expr
insertVar vType vName = HM.insert vName $ mkRef (interpretValType vType)

insertRetVar :: CExpr expr => FunType -> String -> Vars expr -> Vars expr
insertRetVar fType vName = HM.insert vName $ mkRef (interpretFunType fType)

showFName :: Grammar.Name -> String
showFName (namespace, fName) = namespace ++ "::" ++ fName 