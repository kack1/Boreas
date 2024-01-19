module Boreas_Network where

import Boreas_Util
import Network.Curl

curlGithubKeys :: String -> IO (CurlCode, String)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

getGithubKeys s = do
  (st, key) <- curlGithubKeys . githubID . s
  case st of
    CurlOK -> return Just key
    otherwise -> return Nothing
