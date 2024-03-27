-- Copyright (c) 2024, Kyle Ackerman
module Boreas_Util where

import System.Process

type Flag = Bool

data StudentInfo =
  StudentInfo
    { universityID :: String
    , githubID :: String
    , keys :: String
    }
  deriving (Read, Show)

createUserAccount :: StudentInfo -> Flag -> IO ()
createUserAccount user True =
  callCommand $ "useradd -m " ++ universityID user ++ "-s /sbin/nologin"
createUserAccount user False = callCommand $ "useradd -m " ++ universityID user

deleteUserAccount :: StudentInfo -> IO ()
deleteUserAccount user = callCommand $ "userdel -r " ++ universityID user

ensureInHF :: String -> StudentInfo -> IO ()
ensureInHF f user = callCommand $ "mkdir -p ~" ++ universityID user ++ "/" ++ f

writeKeys :: StudentInfo -> IO ()
writeKeys user = writeFile file $ keys user
  where
    file = "/home/" ++ universityID user ++ "/.ssh/authorized_keys"
