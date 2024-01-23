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
  let newStds = zipWith insertKeys s $ filterOK x
  mapM_ createUserAccount newStds
  mapM_ (ensureInHF ".ssh") newStds
  mapM_ writeKeys newStds
  print newStds

createUserAccount :: StudentInfo -> IO ()
createUserAccount user = callCommand $ "useradd -m " ++ universityID user

deleteUserAccount :: StudentInfo -> IO ()
deleteUserAccount user = callCommand $ "userdel -r " ++ universityID user

ensureInHF :: String -> StudentInfo -> IO ()
ensureInHF f user = callCommand $ "mkdir -p ~" ++ universityID user ++ "/" ++ f

writeKeys :: StudentInfo -> IO ()
writeKeys user = writeFile file $ keys user
  where
    file = "/home/" ++ universityID user ++ "/.ssh/authorized_keys"
