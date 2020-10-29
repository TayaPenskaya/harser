{-# LANGUAGE QuasiQuotes #-}

module TestUtil
  ( uTest
  , Program
  , validPrograms
  , emptyProgram
  , oneVarProgram
  , twoVarProgram
  , arithmeticExprProgram
  , ifElseProgram
  , whileProgram
  , ioProgram
  , twoFuncProgram
  , passByValueProgram
  , differentScopeProgram
  , eulerFuncProgram
  , gcdProgram
  ) where

import Test.Hspec
import Test.Hspec.LeanCheck as LC (Testable, property)
import Text.RawString.QQ (r)

uTest :: (HasCallStack, Show a, Eq a) => String -> a -> a -> SpecWith (Arg Expectation)
uTest message expression expected = it message $ expression `shouldBe` expected

pTest :: Testable a => String -> a -> Spec
pTest message prop = it message $ property prop

type Program = String

validPrograms :: [Program]
validPrograms =
  [ emptyProgram
  , oneVarProgram
  , twoVarProgram
  , arithmeticExprProgram
  , ifElseProgram
  , whileProgram
  , ioProgram
  , twoFuncProgram
  , passByValueProgram
  , differentScopeProgram
  , eulerFuncProgram
  , gcdProgram
  ]

emptyProgram :: Program
emptyProgram =
  [r|
int main() {
  return 0;
}
|]

oneVarProgram :: Program
oneVarProgram =
  [r|
int main() {
  int a = 0;
  return a;
}
|]

twoVarProgram :: Program
twoVarProgram =
  [r|
int main() {
  int a = 0;
  int b = a;
  a = 1;
  return b;
}
|]

-- Returns 912
arithmeticExprProgram :: Program
arithmeticExprProgram =
  [r|
int main() {
  int a = (10 + 1) * (255 - 3) / 3 - (10 + 2);
  return a;
}
|]

ifElseProgram :: Program
ifElseProgram =
  [r|
int main() {
  int res = -1;
  if (1 == 2) {
      res = 1;
  } else {
      if (3 > 2) {
          res = 2;
      }
      if (res == 2) {
          res = 0;
      } else {
          res = -1;
      }
  }
  return res;
}
|]

whileProgram :: Program
whileProgram =
  [r|
int main() {
  int cnt = 10;
  while (cnt > 0) {
      cnt--;
  }
  return cnt;
}
|]

ioProgram :: Program
ioProgram =
  [r|
int main() {
  int a;
  cin >> a;
  a *= 2;
  cout << "2 * a = " << a;
  return 0;
}
|]

-- Returns 73
twoFuncProgram :: Program
twoFuncProgram =
  [r|
int f(int x) {
  return x * 2;
}

int main() {
  int a = 10;
  a += f(3); // 16
  return a;
}
|]

-- Returns 21
passByValueProgram :: Program
passByValueProgram =
  [r|
int f(int x) {
  return ++x;
}

int main() {
  int a = 10;
  int b = f(a);
  return a + b; // 21
}
|]

-- Returns 21
differentScopeProgram :: Program
differentScopeProgram =
  [r|
void f() {
    int x = 1;
}

int main() {
  int x = 0;
  f();
  return x;
}
|]

eulerFuncProgram :: Program
eulerFuncProgram =
  [r|
int phi (int n) {
  int result = n;
  for (int i = 2; i * i <=n; ++i)
    if (n % i == 0) {
      while (n % i == 0)
        n /= i;
      result -= result / i;
    }
  if (n > 1)
    result -= result / n;
  return result;
}

int main() {
  int n;
  cin >> n;
  cout << phi(n);
}
 |]

gcdProgram :: Program
gcdProgram =
  [r|
int gcd (int a, int b) {
	if (b == 0)
		return a;
	else
		return gcd (b, a % b);
}

int main() {
  int a, b;
  cin >> a >> b;
  cout << gcd(a, b);
}
 |]
