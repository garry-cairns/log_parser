{-# LANGUAGE OverloadedStrings #-}

module LogParser where

import Control.Applicative
import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString.Char8 as S
import Data.Time
import System.Locale

logItem :: Parser S.ByteString
logItem = takeTill (== ' ')

strToDate :: String -> UTCTime
strToDate = readTime defaultTimeLocale "%d/%b/%Y:%T %z"

datetimeLogItem :: Parser UTCTime
datetimeLogItem = do
  _ <- char '['
  date <- takeTill (== ']')
  _ <- char ']'
  return $ strToDate $ S.unpack date

intLogItem :: Parser Int
intLogItem = do
  n <- decimal
  return n

quotedLogItem :: Parser S.ByteString
quotedLogItem = do
  _ <- char '\"'
  content <- takeTill (== '\"')
  _ <- char '\"'
  return content

data LogEntry = LogEntry {
    remoteIP      :: S.ByteString
  , remoteLogname :: S.ByteString
  , remoteUser    :: S.ByteString
  , timeReceived  :: UTCTime
  , requestLine   :: S.ByteString
  , finalStatus   :: Int
  , responseSize  :: Int
  , responseTime  :: Int
  } deriving Show

parseLogEntry :: Parser LogEntry
parseLogEntry = do
  ip <- logItem
  _ <- char ' '
  logName <- logItem
  _ <- char ' '
  user <- logItem
  _ <- char ' '
  time <- datetimeLogItem
  _ <- char ' '
  firstLogLine <- quotedLogItem
  _ <- char ' '
  finalRequestStatus <- intLogItem
  _ <- char ' '
  responseSizeB <- intLogItem
  _ <- char ' '
  timeToResponse <- intLogItem
  return $ LogEntry ip logName user time firstLogLine finalRequestStatus responseSizeB timeToResponse

type Log = [LogEntry]

parseLog :: Parser Log
parseLog = many $ parseLogEntry <* endOfLine
