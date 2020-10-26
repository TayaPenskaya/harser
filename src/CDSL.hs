{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}

module CDSL 
( CVar(..)
, CExpr(..)
, test
, test2
, test3
, test4
, Type
, Name
) where


import  Control.Applicative (liftA2)
import  Control.Monad.ST.Strict (ST, runST)
import  Data.IORef (IORef, newIORef, readIORef, writeIORef)
import  Control.Monad.Extra (ifM)
import  Control.Monad.Loops (whileM_)


type Type = String
type Name = String

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
    (+) (CBool x) (CBool y) = CBool $ x || y

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

instance Fractional (CVar a) where
  fromRational a = CDouble $ fromRational a

  (/) (CInt    x) (CInt    y) = CInt $ x `div` y
  (/) (CInt    x) (CDouble y) = CDouble $ fromIntegral x / y
  (/) (CDouble x) (CDouble y) = CDouble $ x / y
  (/) (CDouble x) (CInt    y) = CDouble $ x / fromIntegral y

nnot :: CVar a -> CVar a
nnot (CBool a) = CBool $ Prelude.not a
nnot _ = undefined


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

    infix 4 @=
    (@=) :: expr (VarWrap expr (CVar a)) -> expr (CVar a) -> expr ()  

    infix 4 @>
    (@>) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infix 4 @>=
    (@>=) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infix 4 @<
    (@<) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infix 4 @<=
    (@<=) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infix 4 @==
    (@==) :: expr (CVar a) -> expr (CVar a) -> expr Bool

    infixl 6 @+
    (@+) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    infixl 6 @-
    (@-) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    infixl 7 @*
    (@*) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    infixl 7 @/
    (@/) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    infixr 3 @&&
    (@&&) :: expr Bool -> expr Bool -> expr Bool

    infixr 2 @||
    (@||) :: expr Bool -> expr Bool -> expr Bool

    not :: expr (CVar Bool) -> expr (CVar Bool) 

    neg :: expr (CVar a) -> expr (CVar a)  

    cWhile :: expr Bool -> expr a -> expr ()

    cIf :: expr Bool -> expr a -> expr a 

    cIfElse :: expr Bool -> expr a -> expr a -> expr a

    cRead :: expr (VarWrap expr (CVar a)) -> expr (CVar a)

    cWrite :: expr (CVar a) -> expr ()

    cWithVar :: Type -> Name -> expr (CVar a) -> (expr (VarWrap expr (CVar a)) -> expr ()) -> expr ()
 
    cFun0 :: Type -> Name -> (expr (VarWrap expr (CVar a)) -> expr ()) -> expr (CVar a)

    cFun1 :: Type -> Name -> (expr (VarWrap expr (CVar a)) -> expr (VarWrap expr (CVar a)) -> expr ()) -> expr (CVar a) -> expr (CVar a) 

    cFun2 :: Type -> Name -> (expr (VarWrap expr (CVar a)) -> expr (VarWrap expr (CVar a)) -> expr (VarWrap expr (CVar a)) -> expr ()) -> expr (CVar a) -> expr (CVar a) -> expr (CVar a)

    cReadVar :: expr (VarWrap expr (CVar a)) -> expr (CVar a)

test :: CExpr expr => expr (CVar Int)
test = cVarWrap (CDouble 8.8) @/ cVarWrap (CDouble 2)

test2 :: CExpr expr => expr (CVar Int)
test2 = cFun0 "int" "main" (\r -> r @= cVarWrap (CInt 2))

test3 :: CExpr expr => expr (CVar Int)
test3 = cFun1 "int" "main" (\r a -> r @= cReadVar a) (cVarWrap (CInt 1))

test4 :: CExpr expr => expr (CVar Int)
test4 = cFun2 "int" "main" (\r a b -> r @= cReadVar b) (cVarWrap (CInt 1)) (cVarWrap (CInt 10))

defaultValue :: Type -> CVar a
defaultValue "int"    = CInt 0
defaultValue "double" = CDouble 0
defaultValue "string" = CString ""
defaultValue "bool"   = CBool False
defaultValue _        = undefined

instance CExpr IO where
    type VarWrap IO = IORef
    cVarWrap = pure
    (@>) = liftA2 (>)
    (@>=) = liftA2 (>=)
    (@<) = liftA2 (<)
    (@<=) = liftA2 (<=)
    (@==) = liftA2 (==)
    (@+) = liftA2 (+)
    (@-) = liftA2 (-)
    (@*) = liftA2 (*)
    (@/) = liftA2 (/)
    (@&&) = liftA2 (&&)
    (@||) = liftA2 (||)
    neg = fmap (negate)
    not = fmap nnot
    ref @= val = do
        v <- val
        r <- ref
        writeIORef r v
    cFun0 fType name func = do
        let res = newIORef $ defaultValue fType
        res' <- res
        _ <- func (pure res')
        readIORef res'
    cFun1 fType name func var = do
        let res = newIORef $ defaultValue fType
        res' <- res
        var' <- var
        let arg = newIORef var'
        arg' <- arg
        _ <- func (pure res') (pure arg')
        readIORef res'
    cFun2 fType name func var1 var2 = do
        let res = newIORef $ defaultValue fType
        res' <- res
        var1' <- var1
        var2' <- var2
        let arg1 = newIORef var1'
        arg1' <- arg1
        let arg2 = newIORef var2'
        arg2' <- arg2
        _ <- func (pure res') (pure arg1') (pure arg2')
        readIORef res'
    cIf pred x = ifM pred x x
    cIfElse = ifM
    cWhile = whileM_
    cWrite buf = buf >>= print
    cRead ref = ref >>= readIORef >>= readVar
    cReadVar a = a >>= readIORef
        
        
readVar :: CVar a -> IO (CVar a)
readVar to = case to of
    CInt _ -> CInt <$> readLn
    CDouble _ -> CDouble <$> readLn
    CString _ -> CString <$> readLn
    CBool _ -> CBool <$> readLn
