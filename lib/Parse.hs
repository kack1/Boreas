-- Copyright (c) 2024, Kyle Ackerman
module Parse where

import Boreas_Util
import Control.Monad
import System.Exit
import System.IO
import Text.Parsec
import Text.Parsec.String

whitespace :: Parser ()
whitespace = void $ many $ oneOf " \n\t"

studentConfig :: Parser StudentInfo
studentConfig = do
  whitespace
  uni <- many1 alphaNum
  whitespace
  void $ char ':'
  whitespace
  gh <- many1 alphaNum
  whitespace
  return (StudentInfo uni gh "")

parseStudents :: Parser [StudentInfo]
parseStudents = do
  x <- many1 studentConfig
  return x

parseFile :: Parser a -> String -> IO a
parseFile p fileName = parseFromFile p fileName >>= either report return
  where
    report err = do
      hPutStrLn stderr $ "Error: " ++ show err
      exitFailure
