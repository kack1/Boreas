-- Copyright (c) 2024, Kyle Ackerman
module Boreas_Network where

import Boreas_Util
import Network.Curl

type Key = String

-- | Takes in a GitHub username and scapes that user's keys.
curlGithubKeys :: String -> IO (CurlCode, Key)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

getGithubKeys :: [StudentInfo] -> IO [(CurlCode, Key)]
getGithubKeys stds = do
  sequence $ map (curlGithubKeys . githubID) stds

insertKeys :: [StudentInfo] -> [(CurlCode, Key)] -> [StudentInfo]
insertKeys stds ks = zipWith insertKey ks stds

-- | Inserts/Creates StudentInfo with the supplied Key and
-- inserts it depending on the supplied CurlCode.
insertKey :: (CurlCode, Key) -> StudentInfo -> StudentInfo
insertKey k s =
  case k of
    (CurlOK, key) -> StudentInfo u g key
    _ -> StudentInfo u g ""
  where
    u = universityID s
    g = githubID s
