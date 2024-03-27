{-|
Module      : Parse
Description : Parsing functions for Boreas
Copyright   : (c) 2024, Kyle Ackerman
License     : BSD-2
Maintainer  : sample@email.com
Stability   : experimental
Portability : POSIX

		Configuration Parsing function for Boreas. Config files can be in the 
		formart "universityID : GitHubUsername". The universityID is the name of the 
		account to be created, or manipulated, on the machine. The GitHubUsername is the
		user on GitHub that their SSH keys will be scraped.
-}

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
