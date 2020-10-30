module Main where

import Lexer (Token(..), alexScanTokens)
import Parser (parseCPP)
import Grammar (Program(..))
import Translator (translateProgram)
import Interpreter (interpretCDSLWithST)
import CDSL (CVar(..))

import Options.Applicative
import Data.Semigroup ((<>))
import GHC.Base (returnIO)
import Control.Monad.IO.Class (liftIO)

data Command = IF String | IS String | PrintS String | PrintF String

interpretString :: Parser Command
interpretString = IS <$> argument str (metavar "STRING")

interpretFile :: Parser Command
interpretFile = IF <$> argument str (metavar "FILE")

pprintString :: Parser Command
pprintString = PrintS <$> argument str (metavar "STRING")

pprintFile :: Parser Command
pprintFile = PrintF <$> argument str (metavar "FILE")

parser :: Parser Command
parser = subparser
        (  command "iS" (info interpretString (progDesc "Interpret code taken from input string"))
        <> command "iF" (info interpretFile (progDesc "Interpret code taken from file"))
        <> command "printS" (info pprintString (progDesc "Print code taken from input string"))
        <> command "printF" (info pprintFile (progDesc "Print code taken from file"))
        )


runInterpret program =  translateProgram $ parseCPP $ alexScanTokens program

run :: Command -> IO ()
run (IS str) = do
  res <- runInterpret str
  print res
run (IF file) = do
  ctx <- readFile file
  res <- runInterpret ctx
  print res
run (PrintS str) = print str
run (PrintF file) = do
  ctx <- readFile file
  print ctx

opts :: ParserInfo Command
opts = info (parser <**> helper)
            ( fullDesc
            <> progDesc "Enter command..." 
            <> header "Program for pretty-printing and interpreting CPP code." )

main :: IO()
main = do
  args <- execParser opts 
  run args
