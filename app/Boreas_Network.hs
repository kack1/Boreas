-- Copyright (c) 2024, Kyle Ackerman
module Boreas_Network where

import Boreas_Util
import Network.Curl

curlGithubKeys :: String -> IO (CurlCode, String)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

getGithubKeys :: [StudentInfo] -> IO [(CurlCode, String)]
getGithubKeys stds = do
  sequence $ map (curlGithubKeys . githubID) stds

insertKeys :: [StudentInfo] -> [(CurlCode, String)] -> [StudentInfo]
insertKeys stds ks = zipWith insertKey ks stds

insertKey :: (CurlCode, String) -> StudentInfo -> StudentInfo
insertKey k s =
  case k of
    (CurlOK, key) -> StudentInfo u g key
    _ -> StudentInfo u g ""
  where
    u = universityID s
    g = githubID s
