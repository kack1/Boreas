module Main where

import Boreas_Util
import Parse
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  text <- readFile $ head args
  print $ lines text
