{-# LANGUAGE DerivingStrategies #-}

module Grammar
  ( Value(..)
  , ValType(..)
  , FunType(..)
  , Expr(..)
  , Stmt(..)
  , Fun(..)
  , Program(..)
  ) where

data Value
  = StringValue String
  | IntValue Int
  | DoubleValue Double
  | BoolValue Bool
  deriving (Eq, Show) 

data ValType
  = IntType 
  | DoubleType 
  | BoolType 
  | StringType
  deriving (Eq, Show)

data FunType 
  = ValType
  | VoidType
  deriving (Eq, Show)

data Expr
  = ExprPlus Expr Expr
  | ExprMinus Expr Expr
  | ExprMul Expr Expr
  | ExprDiv Expr Expr
  | ExprEq Expr Expr
  | ExprNeq Expr Expr
  | ExprGE Expr Expr
  | ExprLE Expr Expr
  | ExprGT Expr Expr
  | ExprLT Expr Expr
  | ExprNeg Expr
  | ExprAnd Expr Expr
  | ExprOr Expr Expr
  | ExprNot Expr
  | ExprBracketed Expr
  | ExprVar String
  | ExprFun0 String
  | ExprFun1 String Expr
  | ExprFun2 String Expr Expr
  | ExprVal Value
  deriving (Eq, Show)

data Stmt 
  = AssignStmt ValType String Expr
  | ReturnStmt Expr
  | Fun0Stmt String 
  | Fun1Stmt String Expr
  | Fun2Stmt String Expr Expr
  | ReadStmt Expr
  | WriteStmt Expr
  | WhileStmt Expr [Stmt]
  | IfStmt Expr [Stmt]
  | IfElseStmt Expr [Stmt] [Stmt]
  deriving (Eq, Show)

data Fun
  = Fun0 FunType String [Stmt]
  | Fun1 FunType String ValType String [Stmt]
  | Fun2 FunType String ValType String ValType String [Stmt]
  deriving (Eq, Show)

newtype Program = Program [Fun]
  deriving (Eq, Show)