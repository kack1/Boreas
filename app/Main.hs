-- Copyright (c) 2024, Kyle Ackerman
module Main where

import Boreas_Lib
import Boreas_Util
import Options.Applicative

type User = String

data Commands
  = Purge !Config
  | Update !Config
  | Run !Flag !Config

newtype Options =
  Options Commands

main :: IO ()
main = run =<< execParser (parseOptions `withInfo` "Boreas Command")

parseOptions :: Parser Options
parseOptions = Options <$> parseCommand

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc

parseNoLoginShell :: Parser Bool
parseNoLoginShell = switch (long "no-login" <> short 'n')

parseRun :: Parser Commands
parseRun = Run <$> parseNoLoginShell <*> argument str (metavar "CONFIG")

parseUpdate :: Parser Commands
parseUpdate = Update <$> argument str (metavar "CONFIG")

parsePurge :: Parser Commands
parsePurge = Purge <$> argument str (metavar "CONFIG")

parseCommand :: Parser Commands
parseCommand =
  subparser $
  command
    "run"
    (parseRun `withInfo` "Create accounts, scrape keys, give access.") <>
  command "update" (parseUpdate `withInfo` "Scrape keys, update access.") <>
  command
    "purge"
    (parsePurge `withInfo` "Purge keys and accounts, remove access.")

--
run :: Options -> IO ()
run (Options cmd) = do
  case cmd of
    Run flg config -> cmdRun flg config
    Update config -> cmdUpdate config
    Purge config -> cmdPurge config
