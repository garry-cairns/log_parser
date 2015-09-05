-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute

module LogParser where

import LogDataTypes
import Data.Attoparsec.ByteString.Char8

parseLine :: Parser LogEntry
parseLine = do
  remoteIP <- logItem
  space'
  remoteLogName <- logItem
  space'
  remoteUser <- logItem
  space'
  timeReceived <- bracketedLogItem
  space'
  firstLine <- quotedLogItem
  space'
  finalStatus <- logItem
  space'
  responseSize <- logItem
  space'
  timeTaken <- logItem
  return $ LogEntry remoteIP remoteLogName remoteUser timeReceived firstLine finalStatus responseSize timeTaken

main :: IO ()
main = do
  print $ "hello"

