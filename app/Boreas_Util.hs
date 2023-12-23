module Boreas_Util where

data StudentInfo =
  StudentInfo
    { universityID :: String
    , githubID :: String
    }
  deriving (Read, Show)
