-- Joins wifi address with SSID and PASSWORD 
--      Working - 12/30/2015
function joinWifi(SSID, PASS)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,PASS)
    ipaddr = wifi.sta.getip()
    print("ESP8266 IP Addr: "..ipaddr)
end

-- HTTP GET Request 
--      Working - 1/2/2016
function requestGet(HOST, PORT)
    conn=net.createConnection(net.TCP, false) 
    conn:on("receive", function(conn, pl) payload=pl end)
    conn:connect(PORT,"10.0.1.8")
    conn:send("GET / HTTP/1.1\r\nHost: www.nodemcu.com\r\n"
        .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
    return payload
end

-- Reads ADC and generates post req text 
--      Working - 1/2/2016
--      Need to verify post req text formatting is right
function adcValPostReq()
    local data = { adcVal = adc.read(0) }
    request = "POST uri HTTP/1.1\r\n"..
      "Host: example.com\r\n"..
      "apiKey: e2sss3af-9ssd-43b0-bfdd-24a1dssssc46\r\n"..
      "Cache-Control: no-cache\r\n"..
      "Content-Type: application/x-www-form-urlencoded\r\n"..cjson.encode(data)
    return request
end

-- HTTP POST Request
--      Not working
--      Could be hardware issue (too much current draw)
--      Could be softwware issue (poor header format - see helper f'n)
function requestPost(HOST, PORT, data)
    conn=net.createConnection(net.TCP, 0)  
    conn:on("receive", display) 
    conn:connect(PORT, HOST)  
    conn:on("connection",function(conn) conn:send(data) end)
end


-- Main body of the program

if wifi.sta.getip() == nil then
    joinWifi("Montucky", "KerivanReilly")
end

print(adcValBundle())
tmr.alarm(0, 1000, 0, function() print(requestGet("10.0.1.8", 5000)) end)
