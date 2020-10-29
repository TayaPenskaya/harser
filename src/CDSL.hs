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
import Control.Monad.ST.Strict (ST, runST)
import Data.IORef (IORef, newIORef, readIORef, writeIORef)
import Data.STRef.Strict (STRef, newSTRef, readSTRef, writeSTRef)
import Data.Data (Typeable)
import Control.Monad.Fail (MonadFail)
import Debug.Trace (trace)

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
  
  newRef :: CVar -> Ref expr
  readRef :: VarWrap expr CVar -> expr CVar
  writeRef :: VarWrap expr CVar -> CVar -> expr ()
  mkRef :: String -> Ref expr
  mkRef vType = newRef $ typeDefault vType
  
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
  (#) :: expr () -> expr () -> expr ()

  not :: expr CVar -> expr CVar

  neg :: expr CVar -> expr CVar

  cWhile :: (() -> expr CVar) -> (() -> expr ()) -> (() -> expr ()) -> expr ()

  cIf :: expr CVar -> (() -> expr ()) -> expr ()

  cIfElse :: expr CVar -> (() -> expr ()) -> (() -> expr ()) -> expr ()

  cRead :: Ref expr -> expr CVar

  cWrite :: expr CVar -> expr ()

  cWithVar :: Type -> Name -> expr CVar -> (Ref expr -> expr ()) -> expr ()

  cFun0 :: Type -> Name -> (Ref expr -> expr ()) -> expr CVar

  cFun1 :: Type -> Name -> (Ref expr -> Ref expr -> expr ()) -> expr CVar -> expr CVar

  cFun2 :: Type -> Name -> (Ref expr -> Ref expr -> Ref expr -> expr ()) -> expr CVar -> expr CVar  -> expr CVar

  cReadVar :: Ref expr -> expr CVar

  cCallFun :: Name -> expr CVar -> expr CVar
  
  cVarWrap = pure
  ref @= val = do
    ref' <- ref
    val' <- val
    writeRef ref' val'
    
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
  
  cIf pred runStmt = do
    (CBool pred') <- pred
    if pred'
    then runStmt ()
    else pure ()
  cIfElse pred runThenStmt runElseStmt = do
    (CBool pred') <- pred
    if pred'
    then runThenStmt ()
    else runElseStmt ()
  cWhile runPred runStmt runNext = go
   where 
      go = do
        (CBool pred') <- runPred ()
        if pred'
        then runStmt () >> go
        else runNext ()
    
  a # b = a >> b
  cCallFun _ expr = expr
  cWithVar vType name value assign = trace ("cWithVar: " ++ name) $ do
    value' <- value
    let newVarRef = newRef value'
    newVarRef' <- newVarRef
    assign (pure newVarRef')
  
  cFun0 fType _ func = do
    let res = mkRef fType
    res' <- res
    _ <- func (pure res')
    readRef res'
  
  cFun1 fType name func var = do
    let res = mkRef fType
    res' <- res
    var' <- var
    let arg = newRef var'
    arg' <- arg
    _ <- func (pure res') (pure arg')
    readRef res'  
    
  cFun2 fType name func var1 var2 = do
    let res = mkRef fType
    res' <- res
    var1' <- var1
    var2' <- var2
    let arg1 = newRef var1'
    arg1' <- arg1
    let arg2 = newRef var2'
    arg2' <- arg2
    _ <- func (pure res') (pure arg1') (pure arg2')
    readRef res' 
    
  cReadVar a = a >>= readRef
    
typeDefault :: Type -> CVar
typeDefault "int"    = CInt 0
typeDefault "double" = CDouble 0
typeDefault "string" = CString ""
typeDefault "bool"   = CBool False
typeDefault _        = undefined

instance CExpr IO where
  type VarWrap IO = IORef
  newRef = newIORef
  readRef = readIORef
  writeRef = writeIORef
  cRead ref = ref >>= readRef >>= readVar
  cWrite buf = buf >>= print

instance CExpr (ST s) where
  type VarWrap (ST s) = STRef s
  newRef = newSTRef
  readRef = readSTRef
  writeRef = writeSTRef
  cRead = errorIO
  cWrite = errorIO
  
interpretCDSLWithST :: (forall s. ST s CVar) -> CVar
interpretCDSLWithST = runST  

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

readVar :: CVar -> IO CVar
readVar to =
  case to of
    CInt _    -> CInt <$> readLn
    CDouble _ -> CDouble <$> readLn
    CString _ -> CString <$> readLn
    CBool _   -> CBool <$> readLn

errorIO :: a
errorIO = error "unable to perform IO actions in ST interpreter"
