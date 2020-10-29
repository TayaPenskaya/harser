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
, Ref
, interpretCDSLWithST
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

-- Типы данных: числа целые и с плавающей точкой, строки и булы.
data CVar
  = CInt Int
  | CDouble Double
  | CString String
  | CBool Bool
  deriving (Eq, Ord, Show)

instance Num CVar where
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

instance Fractional CVar where
  fromRational a = CDouble $ fromRational a

  (/) (CInt    x) (CInt    y) = CInt $ x `div` y
  (/) (CInt    x) (CDouble y) = CDouble $ fromIntegral x / y
  (/) (CDouble x) (CDouble y) = CDouble $ x / y
  (/) (CDouble x) (CInt    y) = CDouble $ x / fromIntegral y

nnot :: CVar -> CVar
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

type Ref expr = expr (VarWrap expr CVar)

class (Monad expr, MonadFail expr) => CExpr expr where
  type VarWrap expr :: * -> *  -- type synonym
  
  mkRef :: Type -> Ref expr  
  
  cVarWrap :: CVar -> expr CVar

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
  (#) :: expr CVar -> expr CVar -> expr CVar

  not :: expr CVar -> expr CVar

  neg :: expr CVar -> expr CVar

  cWhile :: expr CVar -> expr a -> expr ()

  cIf :: expr CVar -> expr a -> expr ()

  cIfElse :: expr CVar -> expr a -> expr b -> expr ()

  cRead :: expr (VarWrap expr CVar) -> expr CVar

  cWrite :: expr CVar -> expr ()

  cWithVar :: Type -> Name -> expr CVar -> (expr (VarWrap expr CVar) -> expr ()) -> expr ()

  cFun0 :: Type -> Name -> (Ref expr -> expr ()) -> expr CVar

  cFun1 :: Type -> Name -> (Ref expr -> Ref expr -> expr ()) -> expr CVar -> expr CVar

  cFun2 :: Type -> Name -> (Ref expr -> Ref expr -> Ref expr -> expr ()) -> expr CVar -> expr CVar  -> expr CVar

  cReadVar :: Ref expr -> expr CVar

  cCallFun :: Name -> expr CVar -> expr CVar
  
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
  cCallFun _ expr = expr

interpretCDSLWithST :: (forall s. ST s CVar) -> CVar
interpretCDSLWithST = runST

typeDefault :: Type -> CVar
typeDefault "int"    = CInt 0
typeDefault "double" = CDouble 0
typeDefault "string" = CString ""
typeDefault "bool"   = CBool False
typeDefault _        = undefined

instance CExpr IO where
  type VarWrap IO = IORef
  mkRef vType = newIORef $ typeDefault vType
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
    let res = mkRef fType
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
  mkRef vType = newSTRef $ typeDefault vType
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
    let res = mkRef fType
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

liftComp :: Applicative expr => (a -> a -> Bool) -> expr a -> expr a -> expr CVar
liftComp op = (CBool <$>) .: liftA2 op

liftBoolBinop :: (Monad expr, MonadFail expr) => (Bool -> Bool -> Bool) -> expr CVar -> expr CVar -> expr CVar
liftBoolBinop op x y = do
  (CBool x') <- x
  (CBool y') <- y
  pure $ CBool $ op x' y'

type WriteRef expr = VarWrap expr CVar -> CVar -> expr ()
type NewRef expr = CVar -> expr (VarWrap expr CVar)
type ReadRef expr = VarWrap expr CVar -> expr CVar

assignImpl :: Monad expr => WriteRef expr -> Ref expr -> expr CVar -> expr ()
assignImpl writeRef ref val = do
  ref' <- ref
  val' <- val
  writeRef ref' val'

cFun0Impl :: Monad expr => NewRef expr -> ReadRef expr -> Type -> Name -> (Ref expr -> expr ()) -> expr CVar
cFun0Impl newRef readRef fType _ func = do
  let res = newRef $ typeDefault fType
  res' <- res
  _ <- func (pure res')
  readRef res'

cIfImpl :: (Monad expr, MonadFail expr) => expr CVar -> expr a -> expr ()
cIfImpl pred expr = do
  (CBool pred') <- pred
  if pred'
  then expr >> pure ()
  else pure ()

cIfElseImpl :: (Monad expr, MonadFail expr) => expr CVar -> expr a -> expr b -> expr ()
cIfElseImpl pred x y = do
  (CBool pred') <- pred
  if pred'
  then x >> pure ()
  else y >> pure ()

cWhileImpl :: (Monad expr, MonadFail expr) => expr CVar -> expr a -> expr ()
cWhileImpl pred x = do
  (CBool pred') <- pred
  whileM_ (pure pred') x

readVar :: CVar -> IO CVar
readVar to =
  case to of
    CInt _    -> CInt <$> readLn
    CDouble _ -> CDouble <$> readLn
    CString _ -> CString <$> readLn
    CBool _   -> CBool <$> readLn

errorIO :: a
errorIO = error "unable to perform IO actions in ST interpreter"
