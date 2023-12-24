module Parse where

import Boreas_Util
import Control.Monad
import Data.Either
import Text.Parsec
import Text.Parsec.String

whitespace :: Parser ()
whitespace = void $ many $ oneOf " \n\t"

parseInfo :: Parser StudentInfo
parseInfo = do
  whitespace
  uni <- many1 alphaNum
  whitespace
  void $ char ':'
  whitespace
  gh <- many1 alphaNum
  whitespace
  return (StudentInfo uni gh)

parseLine :: String -> Either ParseError StudentInfo
parseLine = parse parseInfo ""

collectInfo :: [String] -> IO ([StudentInfo])
collectInfo = checkParseErrors . partitionEithers . map parseLine

checkParseErrors :: ([ParseError], [StudentInfo]) -> IO ([StudentInfo])
checkParseErrors (e, s) = do
  putStrLn . unlines $ map show e
  return s
