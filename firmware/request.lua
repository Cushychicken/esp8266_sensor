-- Joins wifi address with SSID and PASSWORD 
function joinWifi(SSID, PASS)
    wifi.setmode(wifi.STATION)
    ipaddr = wifi.sta.getip()
    return ipaddr
end

-- HTTP GET Request 
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
function requestPost(HOST, PORT, data)
    conn=net.createConnection(net.TCP, 0)  
    conn:on("receive", function(conn, pl) payload=pl end) 
    conn:connect(PORT, HOST)
    conn:on("connection",function(conn) conn:send(data) end)
end


-- Main body of the program

if wifi.sta.getip() == nil then
    joinWifi("yourSSID", "yourPassword")
end

serverIP = "yourIP"

tmr.alarm(1, 100, 1, function() tmr.wdclr() end)
tmr.alarm(0, 1000, 1, function()
    payload = adcValPostReq()
    receipt = requestPost(serverIP, 5000, payload)
	data = cjson.decode(receipt)
	print(data)
end)

