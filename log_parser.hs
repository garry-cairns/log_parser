-- We seek-- :
-- total successful requests per minute;
-- total error requests per minute;
-- mean response time per minute; and
-- MBs sent per minute

-- Format:
-- Remote IP | remote logname | remote user | time request received | "first line of request" | final status of request | size of response in bytes, excluding headers | time taken to serve request in microseconds

-- Example:
-- 127.0.0.1 - - [30/Mar/2015:05:04:20 +0100] "GET /render/?from=-11minutes&until=-5mins&uniq=1427688307512&format=json&target=alias%28movingAverage%28divideSeries%28sum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalMillis.count%29%29%2Csum%28nonNegativeDerivative%28collector.uk1.rou.*rou*.svc.*.RoutesService.routedate.total.processingLatency.totalCalls.count%29%29%29%2C%275minutes%27%29%2C%22Latency%22%29 HTTP/1.1" 200 157 165169