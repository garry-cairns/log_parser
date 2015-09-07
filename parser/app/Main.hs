-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute
module Main where

import Control.Applicative
import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString as B
import System.Environment
import LogParser

data Stats = Stats {
    successfulRequestsPerMinute :: String
  , failingRequestsPerMinute    :: String
  , meanResponseTime            :: String
  , megabytesPerMinute          :: String
  } deriving Show

prepareStats :: Result Log -> IO ()
prepareStats r =
  case r of
    Fail _ _ _ -> putStrLn $ "Parsing failed"
    Done _ log -> putStrLn $ "Parsing succeeded"

main :: IO ()
main = do
  [f] <- getArgs
  logFile <- B.readFile (f :: FilePath)
  x <- prepareStats $ parse parseLog logFile
  print x
