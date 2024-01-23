-- Copyright (c) 2024, Kyle Ackerman

module Main where

import Boreas_Network
import Boreas_Util
import Parse
import System.Environment
import System.Process

main :: IO ()
main = do
  args <- getArgs
  text <- readFile $ head args
  s <- collectInfo $ lines text
  x <- sequence $ getGithubKeys s
  putStrLn . unlines $
    map (\z -> show $ uncurry insertKeys z) $ zip s $ filterOK x

createUserAccount :: StudentInfo -> IO ()
createUserAccount user = callCommand $ "useradd -m " ++ universityID user

deleteUserAccount :: StudentInfo -> IO ()
deleteUserAccount user = callCommand $ "userdel -r " ++ universityID user
