# Fluvial - Simple Datalogging for NodeMCU

This is a simple demonstration app for logging embedded data using 
the ESP8266 wireless microcontroller and a companion server running 
on a laptop computer. 

All firmware for the ESP8266 is written in Lua. It depends on the 
NodeMCU firmware distribution.

All server side software is written in Python. It uses the Flask module, 
as well as the Flask-Restful addon for ease of making a REST API. 

## Requirements
* Python 2.7 (Originally built on Python 2.7.9), and the following:
	* The Flask framework
	* The Flask-Restful plugin
* The [ESPTool](https://github.com/themadinventor/esptool) Python script, to upload code to the ESP8266
* For ease of developing, the [ESPlorer](http://esp8266.ru/esplorer/) code editor/uploader tool bundles the ESPTool script with a GUI Text Editor and console window for ease of use.
