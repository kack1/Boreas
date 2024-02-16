{-|
Module      : Boreas_Util
Description : General utility functions for Boreas
Copyright   : (c) 2024, Kyle Ackerman
License     : BSD-2
Maintainer  : kackerman0102@gmail.com
Stability   : experimental
Portability : POSIX

		Utility Functions for Boreas. Contains the main StudentInfo ADT.
		It also n contains the functions to run bash commands.
-}
module Boreas_Util where

import System.Process

data StudentInfo =
  StudentInfo -- ^ StudentInfo Constructor
    { universityID :: String -- ^ The name of the account the student
    , githubID :: String     -- ^ The GitHub username of the student (where keys will be scraped)
    , keys :: String         -- ^ Entry for SSH keys
    }
  deriving (Read, Show)

-- | Creates user account with username universityID from supplied StudentInfo
createUserAccount :: StudentInfo -> IO ()
createUserAccount user = callCommand $ "useradd -m " ++ universityID user

-- | Delete user account with username universityID from supplied StudentInfo
deleteUserAccount :: StudentInfo -> IO ()
deleteUserAccount user = callCommand $ "userdel -r " ++ universityID user

-- | Ensure that directory is in user's home folder
ensureInHF :: String -> StudentInfo -> IO ()
ensureInHF f user = callCommand $ "mkdir -p ~" ++ universityID user ++ "/" ++ f

-- | Writes keys to user's authorized keys file
writeKeys :: StudentInfo -> IO ()
writeKeys user = writeFile file $ keys user
  where
    file = "/home/" ++ universityID user ++ "/.ssh/authorized_keys"
