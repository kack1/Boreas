module Boreas_Network where

import Network.Curl

curlGithubKeys :: String -> IO (CurlCode, String)
curlGithubKeys gh = curlGetString userkeys []
  where
    userkeys = "https://github.com/" ++ gh ++ ".keys"

getGithubKeys :: String -> Maybe String
getGithubKeys gh = do
    (st, keys) <-
  case curlGithubKeys gh of
    (CurlOK, keys) -> Just keys
    _ -> Nothing
