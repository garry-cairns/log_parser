{-# LANGUAGE OverloadedStrings #-}
-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute

-- Format:
-- Remote IP | remote logname | remote user | time request received | "first line of request" | final status of request | size of response in bytes, excluding headers | time taken to serve request in microseconds

-- Example:
-- 127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] "GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1" 200 157 165169

module LogDataTypes where

import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString.Char8 as S
import Data.Time

data LogEntry = LogEntry {
    remoteIP      :: S.ByteString
  , remoteLogname :: S.ByteString
  , remoteUser    :: S.ByteString
  , timeReceived  :: LocalTime
  , requestLine   :: S.ByteString
  , finalStatus   :: S.ByteString
  , responseSize  :: S.ByteString
  , responseTime  :: S.ByteString
  } deriving Show

type Log = [LogEntry]

quote, leftBracket, rightBracket, space' :: Parser Char
quote        = satisfy (== '\"')
leftBracket  = satisfy (== '[')
rightBracket = satisfy (== ']')
space'       = satisfy (== ' ')

logItem :: Parser S.ByteString
logItem = takeTill (== ' ')

bracketedLogItem :: Parser S.ByteString
bracketedLogItem = do
  leftBracket
  content <- takeTill (== ']')
  rightBracket
  return content

datetimeLogItem :: Parser LocalTime
datetimeLogItem = do
  leftBracket
  day <- count 2 digit
  char '/'
  month <- count 3 anyChar
  char '/'
  year <- count 2 digit
  char ':'
  hour <- count 2 digit
  char ':'
  minute <- count 2 digit
  char ':'
  second <- count 2 digit
  space'
  tz <- count 5 anyChar
  rightBracket
  return $ LocalTime { localDay = fromGregorian (read year) (read month) (read day)
                     , localTimeOfDay = TimeOfDay (read hour) (read minute) (read second)
                     }

quotedLogItem :: Parser S.ByteString
quotedLogItem = do
  quote
  content <- takeTill (== '\"')
  quote
  return content

parseLogEntry :: Parser LogEntry
parseLogEntry = do
  ip <- logItem
  space'
  logName <- logItem
  space'
  user <- logItem
  space'
  time <- datetimeLogItem
  space'
  firstLogLine <- quotedLogItem
  space'
  finalRequestStatus <- logItem
  space'
  responseSizeB <- logItem
  space'
  timeToResponse <- logItem
  return $ LogEntry ip logName user time firstLogLine finalRequestStatus responseSizeB timeToResponse
