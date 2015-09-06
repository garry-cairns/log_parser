{-# LANGUAGE OverloadedStrings #-}
-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute

module LogParser where

import Control.Applicative
import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString.Char8 as S
import Data.Time
import System.Locale

data LogEntry = LogEntry {
    remoteIP      :: S.ByteString
  , remoteLogname :: S.ByteString
  , remoteUser    :: S.ByteString
  , timeReceived  :: UTCTime
  , requestLine   :: S.ByteString
  , finalStatus   :: S.ByteString
  , responseSize  :: Int
  , responseTime  :: Int
  } deriving Show

type Log = [LogEntry]

logItem :: Parser S.ByteString
logItem = takeTill (== ' ')

strToDate :: String -> UTCTime
strToDate = readTime defaultTimeLocale "%d/%b/%Y:%T"

datetimeLogItem :: Parser UTCTime
datetimeLogItem = do
  char '['
  date <- takeTill (== ' ')
  char ' '
  tz <- count 5 anyChar
  char ']'
  return $ strToDate $ S.unpack date

intLogItem :: Parser Int
intLogItem = do
  n <- decimal
  return n

quotedLogItem :: Parser S.ByteString
quotedLogItem = do
  char '\"'
  content <- takeTill (== '\"')
  char '\"'
  return content


-- Log entry format:
-- Remote IP | remote logname | remote user | time request received | "first line of request" | final status of request | size of response in bytes, excluding headers | time taken to serve request in microseconds

-- Example:
-- 127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] "GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1" 200 157 165169
parseLogEntry :: Parser LogEntry
parseLogEntry = do
  ip <- logItem
  char ' '
  logName <- logItem
  char ' '
  user <- logItem
  char ' '
  time <- datetimeLogItem
  char ' '
  firstLogLine <- quotedLogItem
  char ' '
  finalRequestStatus <- logItem
  char ' '
  responseSizeB <- intLogItem
  char ' '
  timeToResponse <- intLogItem
  return $ LogEntry ip logName user time firstLogLine finalRequestStatus responseSizeB timeToResponse

parseLog :: Parser Log
parseLog = many $ parseLogEntry <* endOfLine
