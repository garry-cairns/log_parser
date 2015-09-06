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

-- successesPerMinute :: 
-- getStats :: Log -> IO Stats
-- getStats = 1

main :: IO ()
main = do
  [f] <- getArgs
  B.readFile (f :: FilePath) >>= print . parse parseLog

-- main :: IO ()
-- main = do
--   file <- B.readFile filePath
--   let parsedLog = do pl <- parse parseLog file
--                      return pl
--   print parsedLog
