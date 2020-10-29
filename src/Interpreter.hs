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

import Control.Monad.State.Strict (StateT, get, evalStateT, modify)

import Control.Monad.Reader (Reader, runReader, ask)

import qualified Data.Map as HM (Map (..), lookup, insert, empty, keys, assocs)
import Data.List (find)
import Data.Maybe (fromMaybe, fromJust)
import Control.Applicative (liftA2)
import Debug.Trace (trace)
import Data.Map.Strict (assocs)

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
initialFuns (Program funs) = foldr helper HM.empty $ takeWhileInc (Prelude.not . isNameMain) funs
  where
    helper fun = HM.insert (funName fun) fun

takeWhileInc :: (a -> Bool) -> [a] -> [a]
takeWhileInc p = foldr (\x ys -> if p x then x:ys else [x]) []

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

runStmts :: CExpr expr => String -> Funs -> Vars expr -> [Stmt] -> expr ()
runStmts fName funs vars stmts | trace ("runStmts: " ++ (show $ HM.keys vars)) False = undefined
runStmts fName funs vars stmts =
  runReader
    (evalStateT (interpretStmts fName stmts) vars)
    funs

runExpr :: CExpr expr => Funs -> Vars expr -> Expr -> expr CVar
runExpr funs vars expr =
  runReader
    (evalStateT (interpretExpr expr) vars)
    funs

insertVar :: CExpr expr => String -> Ref expr -> Vars expr -> Vars expr
insertVar vName vRef = insertVars [(vName, vRef)]

insertVars :: CExpr expr => [(String, Ref expr)] -> Vars expr -> Vars expr
insertVars = flip $ foldr $ uncurry HM.insert

interpretFun :: CExpr expr => Fun -> FunState expr (expr CVar)
interpretFun fun = case fun of
  Fun0 fType fName stmts -> interpretFunExpr (ExprFun0 ("", fName))
  Fun1 _ fName _ _ _ -> errorNoArgs fName
  Fun2 _ fName _ _ _ _ _ -> errorNoArgs fName

interpretFunStmt :: CExpr expr => Stmt -> FunState expr (expr ())
interpretFunStmt funStmt = case funStmt of
  Fun0Stmt fName -> interpretFunExpr (ExprFun0 fName) >> pure (pure ())
  Fun1Stmt fName arg -> interpretFunExpr (ExprFun1 fName arg) >> pure (pure ())
  Fun2Stmt fName arg1 arg2 -> interpretFunExpr (ExprFun2 fName arg1 arg2) >> pure (pure ())

interpretFunExpr :: CExpr expr => Expr -> FunState expr (expr CVar)
interpretFunExpr exprFun = do
  vars <- get
  funs <- ask
  case exprFun of
    ExprFun0 (namespace, fName) -> do
      let maybeFun = HM.lookup fName funs
      case maybeFun of
        Nothing -> errorNoFunction fName
        Just fun ->
          case fun of
            Fun1 {} -> errorTooFewArguments fName
            Fun2 {} -> errorTooFewArguments fName
            Fun0 fType _ stmts -> pure $
              cFun0
                (interpretFunType fType)
                fName
                (\r -> runStmts fName funs (insertVar fName r vars) stmts)

    ExprFun1 (namespace, fName)  arg -> do
      let maybeFun = HM.lookup fName funs
      case maybeFun of
        Nothing -> errorNoFunction fName
        Just fun ->
          case fun of
            Fun0 {} -> errorTooManyArguments fName
            Fun2 {} -> errorTooFewArguments fName
            Fun1 fType _ argType argName stmts -> do
              arg' <- interpretExpr arg
              pure $ cFun1
                (interpretFunType fType)
                fName
                (\r argRef -> runStmts fName funs (insertVars [(fName, r), (argName, argRef)] vars) stmts)
                arg'

    ExprFun2 (namespace, fName)  arg1 arg2 -> do
      let maybeFun = HM.lookup fName funs
      case maybeFun of
        Nothing -> errorNoFunction fName
        Just fun ->
          case fun of
            Fun0 {} -> errorTooFewArguments fName
            Fun1 {} -> errorTooFewArguments fName
            Fun2 fType _ arg1Type arg1Name arg2Type arg2Name stmts -> do
              arg1' <- interpretExpr arg1
              arg2' <- interpretExpr arg2
              pure $ cFun2
                (interpretFunType fType)
                fName
                (\r arg1Ref arg2Ref -> runStmts fName funs (
                    insertVars [(fName, r), (arg1Name, arg1Ref), (arg2Name, arg2Ref)] vars) stmts)
                arg1'
                arg2'

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
interpretValue value | trace ("interpretValue: " ++ (show value)) False = undefined
interpretValue (IntValue v) = cVarWrap (CInt v)
interpretValue (StringValue v) = cVarWrap (CString v)
interpretValue (DoubleValue v) = cVarWrap (CDouble v)
interpretValue (BoolValue v) = cVarWrap (CBool v)

interpretExpr :: CExpr expr => Expr -> FunState expr (expr CVar)
interpretExpr expr | trace ("interpretExpr: " ++ show expr) False = undefined
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
interpretExpr expr@ExprFun0{} = interpretFunExpr expr
interpretExpr expr@ExprFun1{} = interpretFunExpr expr
interpretExpr expr@ExprFun2{} = interpretFunExpr expr
interpretExpr (ExprVal val) = pure $ interpretValue val


-- (a -> b -> b) -> b -> [a] -> b
interpretStmts :: CExpr expr => String -> [Stmt] -> FunState expr (expr ())
interpretStmts fName [] = pure (pure ())
interpretStmts fName (x:xs) = interpretStmt fName x xs

interpretStmt :: CExpr expr => String -> Stmt -> [Stmt] -> FunState expr (expr ())
interpretStmt fName stmt stmts
  | trace ("interpretStmt: " ++ show stmt) False = undefined
interpretStmt fName stmt stmts = do
  vars <- get
  funs <- ask
  case stmt of
    AssignStmt vType vName expr -> do
      rhs <- interpretExpr expr
      let maybeVar = HM.lookup vName vars
      case maybeVar of
        Just _ -> error $ "Variable `" ++ vName ++ "` already exists"
        Nothing -> pure $
          cWithVar
            (interpretValType vType)
            vName
            rhs
            (\vRef -> runStmts fName funs (HM.insert vName vRef vars) stmts)
    AssignStmtWithoutType vName expr -> do
      rhs <- interpretExpr expr
      let maybeVar = HM.lookup vName vars
      case maybeVar of
        Nothing -> error $ "Undefined variable `" ++ vName ++ "`"
        Just var -> pure (var @= rhs # runStmts fName funs vars stmts)
    ReturnStmt expr -> do
        rhs <- interpretExpr expr
        let maybeRetVar = HM.lookup fName vars
        case maybeRetVar of
          Nothing -> error $ "Statement" ++ show stmt ++ "is outside the function"
          Just retVar -> pure $ retVar @= rhs
    Fun0Stmt {} -> interpretFunStmt stmt
    Fun1Stmt {} -> interpretFunStmt stmt
    Fun2Stmt {} -> interpretFunStmt stmt

    IfStmt expr ifStmts -> do
      expr' <- interpretExpr expr
      pure $ cIf expr' (\_ -> runStmts fName funs vars (ifStmts ++ stmts))
    IfElseStmt expr thenStmts elseStmts -> do
      expr' <- interpretExpr expr
      pure $ cIfElse expr' 
        (\_ ->  runStmts fName funs vars (thenStmts ++ stmts)) 
        (\_ ->  runStmts fName funs vars (elseStmts ++ stmts))
    WhileStmt expr whileStmts -> pure $ cWhile
       (\_ -> runExpr funs vars expr) 
       (\_ -> runStmts fName funs vars whileStmts) 
       (\_ -> runStmts fName funs vars stmts) 

showFName :: Grammar.Name -> String
showFName (namespace, fName) = namespace ++ "::" ++ fName

traceVars :: CExpr expr => Vars expr -> expr a -> expr a
traceVars vars ret =
  let refs = assocs vars
   in trace "vars: " (go refs ret)
  where
    go :: CExpr expr => [(String, Ref expr)] -> expr a -> expr a
    go [] ret = ret
    go ((vName, vRef):xs) ret = do
      value <- cReadVar vRef
      trace ("{" ++ vName ++ ": " ++ show value ++ "}, ") (go xs ret)
--
-- ERRORS
--

errorNoArgs :: String -> a
errorNoArgs fName = error $ "Can't run program with start function `" ++ fName ++ "`"

errorNoFunction :: String -> a
errorNoFunction fName = error $ "Function `" ++ fName ++ "` was not declared in this scope"

errorTooFewArguments :: String -> a
errorTooFewArguments fName = error $ "Too few arguments to function `"  ++ fName ++ "`"

errorTooManyArguments :: String -> a
errorTooManyArguments fName = error $ "Too many arguments to function `"  ++ fName ++ "`"