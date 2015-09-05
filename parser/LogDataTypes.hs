{-# LANGUAGE OverloadedStrings #-}

-- Format:
-- Remote IP | remote logname | remote user | time request received | "first line of request" | final status of request | size of response in bytes, excluding headers | time taken to serve request in microseconds

-- Example:
-- 127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] "GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1" 200 157 165169

module LogDataTypes where

import Data.Attoparsec.ByteString.Char8
import Data.ByteString.Char8 as S
import Data.Time
import Data.Time.Format

data LogEntry = LogEntry {
    remoteIP      :: S.ByteString
  , remoteLogname :: S.ByteString
  , remoteUser    :: S.ByteString
  , timeReceived  :: S.ByteString
  , requestLine   :: S.ByteString
  , finalStatus   :: S.ByteString
  , responseSize  :: S.ByteString
  , responseTime  :: S.ByteString
  } deriving Show

-- logTimeFormat = "%d/%m/&Y:%H:%M:%S %z" :: String

-- stringToDateTime :: S.ByteString -> UTCTime
-- stringToDateTime = parseTime defaultTimeLocale logTimeFormat

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

-- datetimeLogItem :: Parser S.ByteString
-- datetimeLogItem = do
--   leftBracket
--   content <- stringToDateTime(takeTill (== ']'))
--   rightBracket
--   return content

quotedLogItem :: Parser S.ByteString
quotedLogItem = do
  quote
  content <- takeTill (== '\"')
  quote
  return content
