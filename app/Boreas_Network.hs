-- Copyright (c) 2024, Kyle Ackerman

module Boreas_Network where

import Boreas_Util
import Network.Curl

curlGithubKeys :: String -> IO (CurlCode, String)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

getGithubKeys :: [StudentInfo] -> [IO (CurlCode, String)]
getGithubKeys stds = do
  xs <- map (curlGithubKeys . githubID) stds
  return xs

filterOK :: [(CurlCode, String)] -> [String]
filterOK xs = map snd $ filter (\x -> CurlOK == fst x) xs

insertKeys :: StudentInfo -> String -> StudentInfo
insertKeys std k = StudentInfo u g k
  where
    u = universityID std
    g = githubID std
