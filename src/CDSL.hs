{-# LANGUAGE FlexibleInstances   #-}
{-# LANGUAGE GADTs               #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}

module CDSL
( CVar(..)
, CExpr(..)
, Type
, Name
, VarWrap
, Ref
, Printer (..)
, typeDefault
) where

import           Control.Applicative     (liftA2)
import           Control.Monad.Extra     (ifM)
import           Control.Monad.Fail      (MonadFail)
import           Control.Monad.ST.Strict (ST, runST)
import           Data.Data               (Typeable)
import           Data.IORef              (IORef, newIORef, readIORef,
                                          writeIORef)
import           Data.STRef.Strict       (STRef, newSTRef, readSTRef,
                                          writeSTRef)

type Type = String
type Name = String

-- Типы данных: числа целые и с плавающей точкой, строки и булы.
data CVar
  = CInt Int
  | CDouble Double
  | CString String
  | CBool Bool
  deriving (Eq, Ord)

instance Show CVar where
  show cVar = case cVar of
    CInt i    -> show i
    CDouble d -> show d
    CString s -> s
    CBool b   -> show b

instance Num CVar where
  (+) (CInt    x) (CInt    y) = CInt $ x + y
  (+) (CInt    x) (CDouble y) = CDouble $ fromIntegral x + y
  (+) (CDouble x) (CInt    y) = CDouble $ x + fromIntegral y
  (+) (CDouble x) (CDouble y) = CDouble $ x + y
  (+) (CString x) (CString y) = CString $ x ++ y
  (+) (CBool x) (CBool y)     = CBool $ x || y
  (+) _ _                     = errorNonmatchingTypes

  (*) (CInt    x) (CInt    y) = CInt $ x * y
  (*) (CInt    x) (CDouble y) = CDouble $ fromIntegral x * y
  (*) (CDouble x) (CInt    y) = CDouble $ x * fromIntegral y
  (*) (CDouble x) (CDouble y) = CDouble $ x * y
  (*) _ _                     = errorNonmatchingTypes

  (-) (CInt    x) (CInt    y) = CInt $ x - y
  (-) (CInt    x) (CDouble y) = CDouble $ fromIntegral x - y
  (-) (CDouble x) (CInt    y) = CDouble $ x - fromIntegral y
  (-) (CDouble x) (CDouble y) = CDouble $ x - y
  (-) _ _                     = errorNonmatchingTypes

  fromInteger x = CInt $ fromInteger x

  abs = undefined
  signum = undefined

instance Fractional CVar where
  fromRational a = CDouble $ fromRational a

  (/) (CInt    x) (CInt    y) = CInt $ x `div` y
  (/) (CInt    x) (CDouble y) = CDouble $ fromIntegral x / y
  (/) (CDouble x) (CDouble y) = CDouble $ x / y
  (/) (CDouble x) (CInt    y) = CDouble $ x / fromIntegral y
  (/) _ _                     = errorNonmatchingTypes

{-
* Конструкции для работы с переменными (присваивание, чтение
с клавиатуры, печать на стандартный вывод).
* Конструкции условных переходов и циклов (хотя бы один из циклов for, while,
 until на выбор).
* Функции, которые принимают от 0 до 2 аргументов и возвращают в качестве
результата одно значение.
-}

type Indent = String
newtype Printer a = Printer { toStr :: Indent -> String }
data CVarToS a = CVarToS

type family VarWrap (expr :: * -> *) :: * -> *
type instance VarWrap (ST s) = STRef s
type instance VarWrap IO = IORef
type instance VarWrap Printer = CVarToS

type Ref expr = expr (VarWrap expr CVar)

class CExpr expr where
  pur :: a -> expr a

  cVarWrap :: CVar -> expr CVar

  cReturn :: Ref expr -> expr CVar -> expr ()

  infix 4 @=
  (@=) :: Ref expr -> expr CVar -> expr ()

  infix 4 @>
  (@>) :: expr CVar -> expr CVar -> expr CVar

  infix 4 @>=
  (@>=) :: expr CVar -> expr CVar -> expr CVar

  infix 4 @<
  (@<) :: expr CVar -> expr CVar -> expr CVar

  infix 4 @<=
  (@<=) :: expr CVar -> expr CVar -> expr CVar

  infix 4 @==
  (@==) :: expr CVar -> expr CVar -> expr CVar

  infix 4 @/=
  (@/=) :: expr CVar -> expr CVar -> expr CVar

  infixl 6 @+
  (@+) :: expr CVar -> expr CVar -> expr CVar

  infixl 6 @-
  (@-) :: expr CVar -> expr CVar -> expr CVar

  infixl 7 @*
  (@*) :: expr CVar -> expr CVar -> expr CVar

  infixl 7 @/
  (@/) :: expr CVar -> expr CVar -> expr CVar

  infixr 3 @&&
  (@&&) :: expr CVar -> expr CVar -> expr CVar

  infixr 2 @||
  (@||) :: expr CVar -> expr  CVar -> expr CVar

  infix 0 #
  (#) :: expr () -> expr () -> expr ()

  not :: expr CVar -> expr CVar

  neg :: expr CVar -> expr CVar

  cWhile :: (() -> expr CVar) -> (() -> expr ()) -> (() -> expr ()) -> expr ()

  cIf :: expr CVar -> (() -> expr ()) -> (() -> expr ()) -> expr ()

  cIfElse :: expr CVar -> (() -> expr ()) -> (() -> expr ()) -> (() -> expr ()) -> expr ()

  cRead :: Ref expr -> expr ()

  cWrite :: expr CVar -> expr ()

  cWithVar :: Type -> Name -> expr CVar -> (Ref expr -> expr ()) -> expr ()

  cFun0 :: Bool -> Type -> Name -> (Ref expr -> expr ()) -> expr CVar

  cFun1 :: Bool -> Type -> Name -> (Ref expr -> Ref expr -> expr ()) -> Type -> Name -> expr CVar -> expr CVar

  cFun2 :: Bool -> Type -> Name -> (Ref expr -> Ref expr -> Ref expr -> expr ()) -> Type -> Name -> expr CVar -> Type -> Name -> expr CVar -> expr CVar

  cReadVar :: Ref expr -> expr CVar

typeDefault :: Type -> CVar
typeDefault t =
  case t of
    "int"    -> CInt 0
    "double" -> CDouble 0
    "string" -> CString ""
    "bool"   -> CBool False
    _        -> undefined

errorNonmatchingTypes :: a
errorNonmatchingTypes = error "Unable to perform operation cause nonmatching types for operation"
