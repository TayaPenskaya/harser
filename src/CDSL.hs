{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}

module CDSL 
( CVar(..)
, CExpr(..)
, Interpret (..)
, test
) where

type Type = String
type Name = String

-- data Stmt 
--   = AssignStmt ValType String Expr
--   | ReturnStmt Expr
--   | Fun0Stmt Name 
--   | Fun1Stmt Name Expr
--   | Fun2Stmt Name Expr Expr
--   | ReadStmt Expr
--   | WriteStmt Expr
--   | WhileStmt Expr [Stmt]
--   | IfStmt Expr [Stmt]
--   | IfElseStmt Expr [Stmt] [Stmt]
--   deriving (Eq, Show)

-- Типы данных: числа целые и с плавающей точкой, строки и булы.
data CVar a
    = CInt Int 
    | CDouble Double
    | CString String
    | CBool Bool 
    deriving (Eq, Ord, Show)

instance Num (CVar a) where
    (+) (CInt    x) (CInt    y) = CInt $ x + y
    (+) (CInt    x) (CDouble y) = CDouble $ fromIntegral x + y
    (+) (CDouble x) (CInt    y) = CDouble $ x + fromIntegral y
    (+) (CDouble x) (CDouble y) = CDouble $ x + y
    (+) (CString x) (CString y) = CString $ x ++ y

    (*) (CInt    x) (CInt    y) = CInt $ x * y
    (*) (CInt    x) (CDouble y) = CDouble $ fromIntegral x * y
    (*) (CDouble x) (CInt    y) = CDouble $ x * fromIntegral y
    (*) (CDouble x) (CDouble y) = CDouble $ x * y

    (-) (CInt    x) (CInt    y) = CInt $ x - y
    (-) (CInt    x) (CDouble y) = CDouble $ fromIntegral x - y
    (-) (CDouble x) (CInt    y) = CDouble $ x - fromIntegral y
    (-) (CDouble x) (CDouble y) = CDouble $ x - y

    fromInteger x = CInt $ fromInteger x

    abs = undefined
    signum = undefined

{- 
* Конструкции для работы с переменными (присваивание, чтение
с клавиатуры, печать на стандартный вывод).
* Конструкции условных переходов и циклов (хотя бы один из циклов for, while,
 until на выбор).
* Функции, которые принимают от 0 до 2 аргументов и возвращают в качестве
результата одно значение.
-}

class CExpr expr where
    type VarWrap expr :: * -> *  -- type synonym 

    cVarWrap :: CVar a -> expr (CVar a)

    -- infix 4 @=
    -- (@=) :: CVar a => (VarWrap expr) a -> a -> expr ()  -- a = b (a - (VarWrap expr) a, b - a, return - expr ())

    infix 4 @>
    (@>) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    -- infix 4 @>=
    -- (@>=) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    -- infix 4 @<
    -- (@<) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    -- infix 4 @<=
    -- (@<=) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    -- infix 4 @==
    -- (@==) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infixl 6 @+
    (@+) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    -- infixl 6 @-
    -- (@-) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    -- infixl 7 @*
    -- (@*) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    -- infixl 7 @/
    -- (@/) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    -- infixr 3 @&&
    -- (@&&) :: expr Bool -> expr Bool -> expr Bool

    -- infixr 2 @||
    -- (@||) :: expr Bool -> expr Bool -> expr Bool

    -- cWhile :: expr Bool -> expr a -> expr ()

    -- cIf :: expr Bool -> expr a -> expr a 

    -- cIfElse :: expr Bool -> expr a -> expr a -> expr a

    -- cRead :: CVar a => (VarWrap expr) a -> expr a -> expr ()

    -- cWrite :: CVar a => expr a -> expr ()

    cFun0 :: Type -> Name -> (expr (VarWrap expr) -> expr ()) -> expr (CVar a)

    -- cFun1 :: (CVar a, CVar b) => expr a -> expr b

    -- cFun2 :: (CVar a, CVar b, CVar c) => expr a -> expr b -> expr c 

test :: CExpr expr => expr (CVar Int)
test = cVarWrap (CInt 5) @+ cVarWrap (CInt 7)

newtype Interpret a =
    Interpret { interpret :: a }

instance CExpr Interpret where
    cVarWrap = Interpret
    (@+) a b = Interpret $
        interpret a + interpret b
    (@>) a b = Interpret $
        interpret a > interpret b
