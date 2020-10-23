module TestUtil
  ( uTest
  , pTest
  ) where

import Test.Hspec
import Test.Hspec.LeanCheck as LC (Testable, property)

uTest ::
     (HasCallStack, Show a, Eq a)
  => String
  -> a
  -> a
  -> SpecWith (Arg Expectation)
uTest message expression expected = it message $ expression `shouldBe` expected

pTest :: Testable a => String -> a -> Spec
pTest message prop = it message $ property prop