module Boreas_Util where

data StudentInfo =
  StudentInfo
    { universityID :: String
    , githubID :: String
    , keys :: String
    }
  deriving (Read, Show)
