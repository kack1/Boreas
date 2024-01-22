module Main where

import Boreas_Network
import Boreas_Util
import Parse
import System.Command
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  text <- readFile $ head args
  s <- collectInfo $ lines text
  x <- sequence $ getGithubKeys s
  putStrLn . unlines $
    map (\z -> show $ uncurry insertKeys z) $ zip s $ filterOK x
  -- putStrLn . unlines $ map snd x
