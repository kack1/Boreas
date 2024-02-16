{-|
Module      : Boreas_Lib
Description : Top-level bindings for Boreas
Copyright   : (c) 2024, Kyle Ackerman 
License     : BSD-2
Maintainer  : sample@email.com
Stability   : experimental
Portability : POSIX

                   Top-level bindings for Boreas. Contains main cmd function.
                   such as, cmdRun, cmdUpdate, cmdPurge.
-}
module Boreas_Lib where

import Boreas_Network
import Boreas_Util
import Parse

-- | Config file location 
type Config = String

-- | Top level cmd call to update update accounts
cmdUpdate :: String -> IO ()
cmdUpdate config = do
  stds <- getStudents config
  mapM_ (ensureInHF ".ssh") stds
  mapM_ writeKeys stds
  print stds

-- | Top level cmd call to run Boreas
cmdRun :: String -> IO ()
cmdRun config = do
  stds <- getStudents config
  mapM_ createUserAccount stds
  mapM_ (ensureInHF ".ssh") stds
  mapM_ writeKeys stds
  print stds

-- | Top level cmd call to purge/remove accounts
cmdPurge :: String -> IO ()
cmdPurge config = do
  stds <- getStudents config
  mapM_ deleteUserAccount stds

{-|
    The function 'getStudents' takes in a
    config and returns a list of StudentInfo
    with their SSH keys populated
-}
getStudents :: Config -> IO [StudentInfo]
getStudents file = do
  s <- parseFile parseStudents file
  ks <- getGithubKeys s
  return $ insertKeys s ks
