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

testLine = '127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] "GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1" 200 157 165169' :: S.ByteString

main :: IO ()
main = do
  print $ parseLine testLine

