-- Copyright (c) 2024, Kyle Ackerman
module Main where

import Boreas_Network
import Boreas_Util
import Options.Applicative
import Parse
import System.Process

type Config = String

type User = String

data Command
  = Run Config
  | Update Config

data Options =
  Options Command

main :: IO ()
main = run =<< execParser (parseOptions `withInfo` "Boreas Command")

parseOptions :: Parser Options
parseOptions = Options <$> parseCommand

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc

parseRun :: Parser Command
parseRun = Run <$> argument str (metavar "CONFIG")

parseUpdate :: Parser Command
parseUpdate = Update <$> argument str (metavar "CONFIG")

parseCommand :: Parser Command
parseCommand =
  subparser $
  command
    "run"
    (parseRun `withInfo` "Create accounts, scrape keys, give access.") <>
  command "update" (parseUpdate `withInfo` "Scrape keys, update access.")

run :: Options -> IO ()
run (Options cmd) = do
  case cmd of
    Run config -> cmdRun config
    Update config -> cmdUpdate config

cmdUpdate :: String -> IO ()
cmdUpdate config = undefined

cmdRun :: String -> IO ()
cmdRun config = do
  stds <- getStudents config
  mapM_ createUserAccount stds
  mapM_ (ensureInHF ".ssh") stds
  mapM_ writeKeys stds
  print stds

getStudents :: Config -> IO [StudentInfo]
getStudents file = do
  s <- parseFile parseStudents file
  ks <- getGithubKeys s
  return $ insertKeys s ks

-- ex :: IO ()
-- ex = do
--   args <- getArgs
--   text <- readFile $ head args
--   s <- collectInfo $ lines text
--   x <- sequence $ getGithubKeys s
--   let newStds = zipWith insertKeys s $ filterOK x
--   mapM_ createUserAccount newStds
--   mapM_ (ensureInHF ".ssh") newStds
--   mapM_ writeKeys newStds
--   print newStds
createUserAccount :: StudentInfo -> IO ()
createUserAccount user = callCommand $ "useradd -m " ++ universityID user

deleteUserAccount :: StudentInfo -> IO ()
deleteUserAccount user = callCommand $ "userdel -r " ++ universityID user

ensureInHF :: String -> StudentInfo -> IO ()
ensureInHF f user = callCommand $ "mkdir -p ~" ++ universityID user ++ "/" ++ f

writeKeys :: StudentInfo -> IO ()
writeKeys user = writeFile file $ keys user
  where
    file = "/home/" ++ universityID user ++ "/.ssh/authorized_keys"
