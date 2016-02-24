-- file : application.lua
local module = {}  
m = nil

local function ReadInVdd()
    invddmv = adc.readvdd33();
    invddv = (invddmv / 1000);
    m:publish(config.ENDPOINT .. "vBat","vBat=" .. invddv,0,0)
    print("battery voltage: "..(invddv).." V");
    -- return battery voltage in Volts
end

-- Sends a simple ping to the broker
local function send_ping()  
    m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
    --print("Successfully published ping")
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
        register_myself()
        print("Successfully registered")
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 1000, 1, send_ping)
        tmr.alarm(5, 3000, 1, ReadInVdd)
    end) 

end

function module.start()  
  mqtt_start()
end

return module  