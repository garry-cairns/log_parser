{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Char8 as S
import Test.Hspec
import Test.Hspec.Attoparsec
import LogParser

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "LogParser success cases" $ do

    it "successfully parses '200' into 200" $
      ("200" :: S.ByteString) ~> intLogItem `shouldParse` 200

    it "successfully parses 'GET /this/' into GET /this/" $
      ("\"GET /this/\"" :: S.ByteString) ~> quotedLogItem `shouldParse` "GET /this/"

    it "successfully parses [30/Mar/2015:12:12:12 +0100]" $
      datetimeLogItem `shouldSucceedOn` ("[30/Mar/2015:12:12:12 +0100]" :: S.ByteString)

    it "successfully parses a complete log line" $
      parseLogEntry `shouldSucceedOn` ("127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] \"GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1\" 200 157 165169" :: S.ByteString)

