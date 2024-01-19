module Boreas_Network where

import Boreas_Util
import Network.Curl

curlGithubKeys :: String -> IO (CurlCode, String)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

-- getGithubKeys :: [StudentInfo] -> [String]
getGithubKeys stds = do
  xs <- map (curlGithubKeys . githubID) stds
  return xs
