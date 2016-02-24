-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["xxxx"] = "xxxxxxxxxx"

module.HOST = "broker.exemple.org"  
module.PORT = 1883  
module.ID = node.chipid()

module.ENDPOINT = "nodemcu/"  
return module  
