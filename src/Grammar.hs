module Grammar 
    (
    ) where 

-- Типы данных: числа целые и с плавающей точкой, строки и булы.
class (Ord a, Show a) => PyVar a where

instance PyVar Int where
instance PyVar Float where
instance PyVar String where
instance PyVar Bool where

{- 
* Конструкции для работы с переменными (присваивание, чтение
с клавиатуры, печать на стандартный вывод).
* Конструкции условных переходов и циклов (хотя бы один из циклов for, while,
 until на выбор).
* Функции, которые принимают от 0 до 2 аргументов и возвращают в качестве
результата одно значение.
-}

class PyExpr expr where
    type VarWrap expr :: * -> *  -- type synonym 

    infix 4 @=
    (@=) :: PyVar a => (VarWrap expr) a -> a -> expr ()  -- a = b (a - (VarWrap expr) a, b - a, return - expr ())

    infix 4 @>
    (@>) :: PyVar a => expr a -> expr a -> expr Bool

    infix 4 @>=
    (@>=) :: PyVar a => expr a -> expr a -> expr Bool

    infix 4 @<
    (@<) :: PyVar a => expr a -> expr a -> expr Bool

    infix 4 @<=
    (@<=) :: PyVar a => expr a -> expr a -> expr Bool

    infix 4 @==
    (@==) :: PyVar a => expr a -> expr a -> expr Bool

    infixl 6 @+
    (@+) :: PyVar a => expr a -> expr a -> expr a

    infixl 6 @-
    (@-) :: PyVar a => expr a -> expr a -> expr a

    infixl 7 @*
    (@*) :: PyVar a => expr a -> expr a -> expr a

    infixl 7 @/
    (@/) :: PyVar a => expr a -> expr a -> expr a

    infixr 3 @&&
    (@&&) :: expr Bool -> expr Bool -> expr Bool

    infixr 2 @||
    (@||) :: expr Bool -> expr Bool -> expr Bool

    pyWhile :: expr Bool -> expr a -> expr ()

    pyRead1 :: PyVar a => (VarWrap expr) a -> 

    pyRead2 :: (PyVar a, PyVar b) => 

    -- In progress
    -- pyFun0 :: expr a 

    -- pyFun1 :: expr a -> expr b

    -- pyFun2 :: expr a -> expr b -> expr c 


