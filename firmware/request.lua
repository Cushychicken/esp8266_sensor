-- Joins wifi address with SSID and PASSWORD 
--      Working - 12/30/2015
function joinWifi(SSID, PASS)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,PASS)
    ipaddr = wifi.sta.getip()
    return ipaddr
end

-- HTTP GET Request 
--      Working - 1/2/2016
function requestGet(HOST, PORT)
    conn=net.createConnection(net.TCP, false) 
    conn:on("receive", function(conn, pl) payload=pl end)
    conn:connect(PORT, HOST)
    conn:send("GET / HTTP/1.1\r\n"..
              "Host: "..HOST.."\r\n"..
              "Connection: keep-alive\r\n"..
              "Accept: */*\r\n\r\n")
    return payload
end

-- Reads ADC and generates post req text 
--      Working - 1/2/2016
--      Need to verify post req text formatting is right
function adcValPostReq()
    data = { meas=tostring(adc.read(0)) }
    data = cjson.encode(data)
    request = "POST /data HTTP/1.1\r\n"..
              "Host: 10.0.1.8:5000\r\n"..
              "User-Agent: NodeMCU\r\n"..
              "Accept: */*\r\n"..
              "Content-Type: application/json\r\n"..
              "Content-Length: "..string.len(data).."\r\n\r\n"..
			  data
    return request
end


-- HTTP POST Request
--      Working - 1/2/2016
--      Earlier missed communications unclear source
--      Not passing data value correctly - "None" on srvr
function requestPost(HOST, PORT, data)
    conn=net.createConnection(net.TCP, 0)  
    conn:on("receive", function(conn, pl) payload=pl end) 
    conn:connect(PORT, HOST)
    conn:on("connection",function(conn) conn:send(data) end)
end


-- Main body of the program

if wifi.sta.getip() == nil then
    joinWifi("Montucky", "KerivanReilly")
end

tmr.alarm(1, 100, 1, function() tmr.wdclr() end)

tmr.alarm(0, 1000, 1, function()
    payload = adcValPostReq()
    requestPost("10.0.1.8", 5000, payload)
end)

