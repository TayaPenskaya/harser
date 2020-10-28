{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CDSL
( CVar(..)
, CExpr(..)
, Type
, Name
, interpretCDSLWithST
, CVarW
) where

import Control.Applicative (liftA2)
import Control.Monad.Extra (ifM)
import Control.Monad.Loops (whileM_)
import Control.Monad.ST (runST)
import Control.Monad.ST.Strict (ST)
import Data.IORef (IORef, newIORef, readIORef, writeIORef)
import Data.STRef.Strict (STRef, newSTRef, readSTRef, writeSTRef)
import Data.Data (Typeable)
import Control.Monad.Fail (MonadFail)

type Type = String
type Name = String

data CVarW where
  CVarW :: (Typeable a, Show a) => CVar a -> CVarW

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
  (+) (CBool x) (CBool y)     = CBool $ x || y

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
nnot _         = undefined


{- 
* Конструкции для работы с переменными (присваивание, чтение
с клавиатуры, печать на стандартный вывод).
* Конструкции условных переходов и циклов (хотя бы один из циклов for, while,
 until на выбор).
* Функции, которые принимают от 0 до 2 аргументов и возвращают в качестве
результата одно значение.
-}

type Ref expr a = expr (VarWrap expr (CVar a))

class (Monad expr, MonadFail expr) => CExpr expr where
  type VarWrap expr :: * -> *  -- type synonym
  
  cVarWrap :: CVar a -> expr (CVar a)

  infix 4 @=
  (@=) :: Ref expr a -> expr (CVar a) -> expr ()

  infix 4 @>
  (@>) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infix 4 @>=
  (@>=) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infix 4 @<
  (@<) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infix 4 @<=
  (@<=) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infix 4 @==
  (@==) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infix 4 @/=
  (@/=) :: expr (CVar a) -> expr (CVar a) -> expr (CVar Bool)

  infixl 6 @+
  (@+) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

  infixl 6 @-
  (@-) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

  infixl 7 @*
  (@*) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

  infixl 7 @/
  (@/) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

  infixr 3 @&&
  (@&&) :: expr (CVar Bool) -> expr (CVar Bool) -> expr (CVar Bool)

  infixr 2 @||
  (@||) :: expr (CVar Bool) -> expr  (CVar Bool) -> expr (CVar Bool)

  infix 0 #
  (#) :: expr (CVar a) -> expr (CVar a) -> expr (CVar a)

  not :: expr (CVar Bool) -> expr (CVar Bool)

  neg :: expr (CVar a) -> expr (CVar a)

  cWhile :: expr (CVar Bool) -> expr a -> expr ()

  cIf :: expr (CVar Bool) -> expr a -> expr ()

  cIfElse :: expr (CVar Bool) -> expr a -> expr b -> expr ()

  cRead :: expr (VarWrap expr (CVar a)) -> expr (CVar a)

  cWrite :: expr (CVar a) -> expr ()

  cWithVar :: Type -> Name -> expr (CVar a) -> (expr (VarWrap expr (CVar a)) -> expr ()) -> expr ()

  cFun0 :: Type -> Name -> (Ref expr r -> expr ()) -> expr (CVar r)

  cFun1 :: Type -> Name -> (Ref expr r -> Ref expr a -> expr ()) -> expr (CVar a) -> expr (CVar r)

  cFun2 :: Type -> Name -> (Ref expr r -> Ref expr a -> Ref expr b -> expr ()) -> expr (CVar a) -> expr (CVar b) -> expr (CVar r)

  cReadVar :: Ref expr a -> expr (CVar a)

  cCallFun :: Name -> [Name] -> expr (CVar r) -> expr (CVar r)
  
  cVarWrap = pure
  (@>) = liftComp (>)
  (@>=) = liftComp (>=)
  (@<) = liftComp (<)
  (@<=) = liftComp (<=)
  (@==) = liftComp (==)
  (@/=) = liftComp (/=)
  (@+) = liftA2 (+)
  (@-) = liftA2 (-)
  (@*) = liftA2 (*)
  (@/) = liftA2 (/)
  (@&&) = liftBoolBinop (&&)
  (@||) = liftBoolBinop (||)
  neg = fmap negate
  not = fmap nnot
  cIf = cIfImpl
  cIfElse = cIfElseImpl
  cWhile = cWhileImpl
  a # b = a >> b
  cCallFun _ _ expr = expr

interpretCDSLWithST :: (forall s. ST s (CVar a)) -> CVar a
interpretCDSLWithST = runST

typeDefault :: Type -> CVar a
typeDefault "int"    = CInt 0
typeDefault "double" = CDouble 0
typeDefault "string" = CString ""
typeDefault "bool"   = CBool False
typeDefault _        = undefined

instance CExpr IO where
  type VarWrap IO = IORef
  (@=) = assignImpl writeIORef
  cFun0 = cFun0Impl newIORef readIORef
  cFun1 fType name func var = do
    let res = newIORef $ typeDefault fType
    res' <- res
    var' <- var
    let arg = newIORef var'
    arg' <- arg
    _ <- func (pure res') (pure arg')
    readIORef res'
  cFun2 fType name func var1 var2 = do
    let res = newIORef $ typeDefault fType
    res' <- res
    var1' <- var1
    var2' <- var2
    let arg1 = newIORef var1'
    arg1' <- arg1
    let arg2 = newIORef var2'
    arg2' <- arg2
    _ <- func (pure res') (pure arg1') (pure arg2')
    readIORef res'
  cWrite buf = buf >>= print
  cRead ref = ref >>= readIORef >>= readVar
  cReadVar a = a >>= readIORef
  cWithVar vType name value assign = do
    let newVarRef = newIORef $ typeDefault vType
    newVarRef' <- newVarRef
    assign (pure newVarRef')

instance CExpr (ST s) where
  type VarWrap (ST s) = STRef s
  (@=) = assignImpl writeSTRef
  cFun0 = cFun0Impl newSTRef readSTRef
  cFun1 fType name func var = do
    let res = newSTRef $ typeDefault fType
    res' <- res
    var' <- var
    let arg = newSTRef var'
    arg' <- arg
    _ <- func (pure res') (pure arg')
    readSTRef res'
  cFun2 fType name func var1 var2 = do
    let res = newSTRef $ typeDefault fType
    res' <- res
    var1' <- var1
    var2' <- var2
    let arg1 = newSTRef var1'
    arg1' <- arg1
    let arg2 = newSTRef var2'
    arg2' <- arg2
    _ <- func (pure res') (pure arg1') (pure arg2')
    readSTRef res'
  cReadVar a = a >>= readSTRef
  cWithVar vType name value assign = do
    let newVarRef = newSTRef $ typeDefault vType
    newVarRef' <- newVarRef
    assign (pure newVarRef')
  cRead = errorIO
  cWrite = errorIO

{-
* Helpers:
-}

infixr 8 .:
(.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
(f .: g) x y = f (g x y)

liftComp :: Applicative expr => (a -> a -> Bool) -> expr a -> expr a -> expr (CVar Bool)
liftComp op = (CBool <$>) .: liftA2 op

liftBoolBinop :: (Monad expr, MonadFail expr) => (Bool -> Bool -> Bool) -> expr (CVar Bool) -> expr (CVar Bool) -> expr (CVar Bool)
liftBoolBinop op x y = do
  (CBool x') <- x
  (CBool y') <- y
  pure $ CBool $ op x' y'

type WriteRef expr a = VarWrap expr (CVar a) -> CVar a -> expr ()
type NewRef expr a = CVar a -> expr (VarWrap expr (CVar a))
type ReadRef expr a = VarWrap expr (CVar a) -> expr (CVar a)

assignImpl :: Monad expr => WriteRef expr a -> Ref expr a -> expr (CVar a) -> expr ()
assignImpl writeRef ref val = do
  ref' <- ref
  val' <- val
  writeRef ref' val'

cFun0Impl :: Monad expr => NewRef expr r -> ReadRef expr r -> Type -> Name -> (Ref expr r -> expr ()) -> expr (CVar r)
cFun0Impl newRef readRef fType _ func = do
  let res = newRef $ typeDefault fType
  res' <- res
  _ <- func (pure res')
  readRef res'

cIfImpl :: (Monad expr, MonadFail expr) => expr (CVar Bool) -> expr a -> expr ()
cIfImpl pred expr = do
  (CBool pred') <- pred
  if pred'
  then expr >> pure ()
  else pure ()

cIfElseImpl :: (Monad expr, MonadFail expr) => expr (CVar Bool) -> expr a -> expr b -> expr ()
cIfElseImpl pred x y = do
  (CBool pred') <- pred
  if pred'
  then x >> pure ()
  else y >> pure ()

cWhileImpl :: (Monad expr, MonadFail expr) => expr (CVar Bool) -> expr a -> expr ()
cWhileImpl pred x = do
  (CBool pred') <- pred
  whileM_ (pure pred') x

readVar :: CVar a -> IO (CVar a)
readVar to =
  case to of
    CInt _    -> CInt <$> readLn
    CDouble _ -> CDouble <$> readLn
    CString _ -> CString <$> readLn
    CBool _   -> CBool <$> readLn

errorIO :: a
errorIO = error "unable to perform IO actions in ST interpreter"
