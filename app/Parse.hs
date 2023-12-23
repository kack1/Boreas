module Parse where

import Boreas_Util
import Control.Monad
import Text.Parsec
import Text.Parsec.String

whitespace :: Parser ()
whitespace = void $ many $ oneOf " \n\t"

parseLine :: Parser StudentInfo
parseLine = do
  whitespace
  uni <- many1 alphaNum
  whitespace
  void $ char ':'
  whitespace
  gh <- many1 alphaNum
  whitespace
  return (StudentInfo uni gh)
