-- Loading libs
conf = require("config0")
-- var config
mv = 0

function connect_wifi()
  wifi.setmode(wifi.STATION)
  wifi.sta.config(conf.wifiSSID(),conf.wifiPassword())
  wifi.sta.connect()
end

-- connects to the MQTT broker and publishes the moisture value
function mqtt_send()
 m = mqtt.Client(conf.wiotClientID(), 120, conf.wiotUserID(), conf.wiotPassword())
 m:on("offline", function(conn) print ("offline")  end)

 m:connect(conf.wiotBroker() , conf.wiotMQTTPort(), 0,
 function(conn)
            print("Connected to MQTT")
            d=getMoisture()
            m:publish(conf.wiotTopic() ,'{"d": {"data":'..d..'}}', 0, 0,
                function(client)
                    print("Message sent")
                end)
        end,
        function(client, reason)
            print("Connection failed, reason: " .. reason)
        end)

 m:close()
end

-- reads 3 moisture values within 4 seconds and returns the average value
function getMoisture()
  mv=adc.read(0)
  tmr.delay(2000000)
  mv=mv + adc.read(0)
  tmr.delay(2000000)
  mv=mv + adc.read(0)
  mv = mv / 3
  print("Moisture: "..mv)
  return mv
end

connect_wifi()
getMoisture()
mqtt_send(conf)
