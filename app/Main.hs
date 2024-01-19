module Main where

import Boreas_Network
import Parse
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  text <- readFile $ head args
  s <- collectInfo $ lines text
  print s
  -- keys <- map curlGithubKeys s
