-- Copyright (c) 2024, Kyle Ackerman
module Main where

import Boreas_Lib
import Options.Applicative

type User = String

data Command
  = Run Config
  | Update Config
  | Purge Config

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

parsePurge :: Parser Command
parsePurge = Purge <$> argument str (metavar "CONFIG")

parseCommand :: Parser Command
parseCommand =
  subparser $
  command
    "run"
    (parseRun `withInfo` "Create accounts, scrape keys, give access.") <>
  command "update" (parseUpdate `withInfo` "Scrape keys, update access.") <>
  command
    "purge"
    (parsePurge `withInfo` "Purge keys and accounts, remove access.")

run :: Options -> IO ()
run (Options cmd) = do
  case cmd of
    Run config -> cmdRun config
    Update config -> cmdUpdate config
    Purge config -> cmdPurge config
