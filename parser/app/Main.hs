-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute
module Main where

import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString as B
import System.Environment
import LogParser

data Stats = Stats {
    successfulRequestsPerMinute :: Int
  , failingRequestsPerMinute    :: Int
  , meanResponseTime            :: Int
  , megabytesPerMinute          :: Int
  } deriving Show

countSuccesses :: Int -> Int
countSuccesses n
  | n < 300 = 1
  | otherwise = 0

-- prepareStats :: Result Log -> IO ()
-- prepareStats r =
--   case r of
--     Fail _ _ _ -> putStrLn $ "Parsing failed"
--     Done _ parsedLog -> putStrLn $ show parsedLog -- This now has a [LogEntry] array. Do something with it.

main :: IO ()
main = do
  [f] <- getArgs
  logFile <- B.readFile (f :: FilePath)
  let results = parseOnly parseLog logFile
  putStrLn "TBC"
