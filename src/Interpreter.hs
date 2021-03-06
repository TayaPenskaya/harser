{-# LANGUAGE AllowAmbiguousTypes  #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE RankNTypes           #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE UndecidableInstances #-}

module Interpreter (
  interpretCDSLWithST
)where

import           CDSL                    (CExpr (..), CVar (..), Name, Ref,
                                          Type, VarWrap, typeDefault)
import           Control.Applicative     (liftA2)
import           Control.Monad.Fail      (MonadFail)
import           Control.Monad.ST.Strict (ST, runST)
import           Data.IORef              (IORef, newIORef, readIORef,
                                          writeIORef)
import           Data.STRef.Strict       (STRef, newSTRef, readSTRef,
                                          writeSTRef)

interpretCDSLWithST :: (forall s. ST s CVar) -> CVar
interpretCDSLWithST = runST

class (Monad expr, MonadFail expr) =>  Interpret expr where

  newRef :: CVar -> Ref expr
  readRef :: VarWrap expr CVar -> expr CVar
  writeRef :: VarWrap expr CVar -> CVar -> expr ()
  cVarWrap' :: CVar -> expr CVar
  cReturn' :: Ref expr -> expr CVar -> expr ()
  (@=@) :: Ref expr -> expr CVar -> expr ()
  (@>@) :: expr CVar -> expr CVar -> expr CVar
  (@>=@) :: expr CVar -> expr CVar -> expr CVar
  (@<@) :: expr CVar -> expr CVar -> expr CVar
  (@<=@) :: expr CVar -> expr CVar -> expr CVar
  (@==@) :: expr CVar -> expr CVar -> expr CVar
  (@/=@) :: expr CVar -> expr CVar -> expr CVar
  (@+@) :: expr CVar -> expr CVar -> expr CVar
  (@-@) :: expr CVar -> expr CVar -> expr CVar
  (@*@) :: expr CVar -> expr CVar -> expr CVar
  (@/@) :: expr CVar -> expr CVar -> expr CVar
  (@&&@) :: expr CVar -> expr CVar -> expr CVar
  (@||@) :: expr CVar -> expr  CVar -> expr CVar
  (#@) :: expr () -> expr () -> expr ()
  not' :: expr CVar -> expr CVar
  neg' :: expr CVar -> expr CVar
  cWhile' :: (() -> expr CVar) -> (() -> expr ()) -> (() -> expr ()) -> expr ()
  cIf' :: expr CVar -> (() -> expr ()) -> (() -> expr ()) -> expr ()
  cIfElse' :: expr CVar -> (() -> expr ()) -> (() -> expr ()) -> (() -> expr ()) -> expr ()
  cRead' :: Ref expr -> expr ()
  cWrite' :: expr CVar -> expr ()
  cWithVar' :: Type -> Name -> expr CVar -> (Ref expr -> expr ()) -> expr ()
  cFun0' :: Bool -> Type -> Name -> (Ref expr -> expr ()) -> expr CVar
  cFun1' :: Bool -> Type -> Name -> (Ref expr -> Ref expr -> expr ()) -> Type -> Name -> expr CVar -> expr CVar
  cFun2' :: Bool -> Type -> Name -> (Ref expr -> Ref expr -> Ref expr -> expr ()) -> Type -> Name -> expr CVar -> Type -> Name -> expr CVar  -> expr CVar
  cReadVar' :: Ref expr -> expr CVar

  mkRef :: String -> Ref expr
  mkRef vType = newRef $ typeDefault vType
  cVarWrap' = pure
  ref @=@ val = do
    ref' <- ref
    val' <- val
    writeRef ref' val'
  cReturn' = (@=@)
  (@>@) = liftComp (>)
  (@>=@) = liftComp (>=)
  (@<@) = liftComp (<)
  (@<=@) = liftComp (<=)
  (@==@) = liftComp (==)
  (@/=@) = liftComp (/=)
  (@+@) = liftA2 (+)
  (@-@) = liftA2 (-)
  (@*@) = liftA2 (*)
  (@/@) = liftA2 (/)
  (@&&@) = liftBoolBinop (&&)
  (@||@) = liftBoolBinop (||)
  neg' = fmap negate
  not' = fmap nnot

  cIf' pred runStmt runNext = do
    (CBool pred') <- pred
    if pred'
    then runStmt () >> runNext ()
    else runNext ()
  cIfElse' pred runThenStmt runElseStmt runNext = do
    (CBool pred') <- pred
    if pred'
    then runThenStmt () >> runNext ()
    else runElseStmt () >> runNext ()
  cWhile' runPred runStmt runNext = go
   where
      go = do
        (CBool pred') <- runPred ()
        if pred'
        then runStmt () >> go
        else runNext ()

  a #@ b = a >> b
  cWithVar' vType name value assign = do
    value' <- value
    let newVarRef = newRef value'
    newVarRef <- newVarRef
    assign (pure newVarRef)

  cFun0' _ fType _ func = do
    let res = mkRef fType
    res' <- res
    _ <- func (pure res')
    readRef res'

  cFun1' _ fType name func _ _ var = do
    let res = mkRef fType
    res' <- res
    var' <- var
    let arg = newRef var'
    arg' <- arg
    _ <- func (pure res') (pure arg')
    readRef res'

  cFun2' _ fType name func _ _ var1 _ _ var2 = do
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

  cReadVar' a = a >>= readRef


instance Interpret IO where
  newRef = newIORef
  readRef = readIORef
  writeRef = writeIORef
  cRead' ref = do
    ref' <- ref
    before <- readRef ref'
    var <- readVar before
    writeRef ref' var

  cWrite' buf = do
    buf' <- buf
    case buf' of
      CInt i    -> putStr $ show i
      CDouble d -> putStr $ show d
      CString s -> putStr s
      CBool b   -> putStr $ show b

instance Interpret (ST s) where
  newRef = newSTRef
  readRef = readSTRef
  writeRef = writeSTRef
  cRead' = errorIO
  cWrite' = errorIO

instance (Interpret expr) => CExpr expr where

  pur = pure
  cVarWrap = cVarWrap'
  cReturn = cReturn'
  (@=) = (@=@)
  (@>) = (@>@)
  (@>=) = (@>=@)
  (@<) = (@<@)
  (@<=) = (@<=@)
  (@==) = (@==@)
  (@/=) = (@/=@)
  (@+) = (@+@)
  (@-) = (@-@)
  (@*) = (@*@)
  (@/) = (@/@)
  (@&&) = (@&&@)
  (@||) = (@||@)
  (#) = (#@)
  not = not'
  neg = neg'
  cWhile = cWhile'
  cIf = cIf'
  cIfElse = cIfElse'
  cRead = cRead'
  cWrite = cWrite'
  cWithVar = cWithVar'
  cFun0 = cFun0'
  cFun1 = cFun1'
  cFun2 = cFun2'
  cReadVar = cReadVar'

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

nnot :: CVar -> CVar
nnot (CBool a) = CBool $ Prelude.not a
nnot _         = undefined

errorIO :: a
errorIO = error "unable to perform IO actions in ST interpreter"
