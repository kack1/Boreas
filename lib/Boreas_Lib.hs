-- Copyright (c) 2024, Kyle Ackerman
module Boreas_Lib where

import Boreas_Network
import Boreas_Util
import Parse

type Config = String

cmdUpdate :: String -> IO ()
cmdUpdate config = do
  stds <- getStudents config
  mapM_ (ensureInHF ".ssh") stds
  mapM_ writeKeys stds
  print stds

cmdRun :: String -> IO ()
cmdRun config = do
  stds <- getStudents config
  mapM_ createUserAccount stds
  mapM_ (ensureInHF ".ssh") stds
  mapM_ writeKeys stds
  print stds

cmdPurge :: String -> IO ()
cmdPurge config = do
  stds <- getStudents config
  mapM_ deleteUserAccount stds

getStudents :: Config -> IO [StudentInfo]
getStudents file = do
  s <- parseFile parseStudents file
  ks <- getGithubKeys s
  return $ insertKeys s ks
