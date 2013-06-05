gl.setup(1024, 768)
util.auto_loader(_G)

background = resource.load_image("weather_background.jpg")
font = resource.load_font("font.ttf")
webfont = resource.load_font("silkscreen.ttf")

temperature = 1
wind = 1
rain = 1
humidity = 1
dateTime = 0


-- prevent bugs due to the json files not being written in time
function secure_json_decode(content)
    local success, returnvalue = pcall(function(content)
        return json.decode(content)
    end, content)
    if success == true then
        return returnvalue
    end
    return nil
end

-- round numbers so we dont have loads of unnecessary decimals
function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end


util.file_watch("temperature", function(content)
    newtemperature = string.match(content,"%d+.%d*%s°C")
	newtemperature = string.gsub(newtemperature, "°", "")
    if newtemperature ~= nil then
        temperature = newtemperature
    end
	
	s3  = string.match(content, '<td valign="middle" align="center">%d+.%d+.%d+<br>');
	s3  = string.gsub(s3 , "<td valign=\"middle\" align=\"center\">", "");
	s3  = string.gsub(s3 , "%s*", "");
	s3  = string.gsub(s3 , "<br>", " ");

	
	s5 = string.match(s3, '^%d+.%d+.%d+');
	
	
	s6  = string.match(content, '%d+:%d+%s*MEZ');
	s6  = string.gsub(s6 , "%s*MEZ", "");

	dateTime = s6 .. " " .. s5
	
end)

util.file_watch("wind", function(content)
    newwind = string.match(content,"%d+.%d*%sm/s")
    if newwind ~= nil then
        wind = newwind
    end
end)

util.file_watch("rain", function(content)
    rain = string.match(content,"%d+.%d*%smm")
    if newrain ~= nil then
        rain = newrain
	end
end)

util.file_watch("humidity", function(content)
    humidity = string.match(content,"%d+.%d*%s%%")
    if newhumidity ~= nil then
        humidity = newhumidity
	end
end)


util.file_watch("weather_background.jpg", function(content)
    background = resource.load_image("weather_background.jpg")
end)

function node.render()

	background:draw(0,0,WIDTH,HEIGHT)
	
    font:write(100, 100, "Wetter", 100, 1,0,0,1)
    font:write(100,250, "Temperatur: " .. temperature,50,0,1,0,1) 
    font:write(100,350, "Windgeschwindigkeit: " .. wind,50,0,1,0,1) 
    font:write(100,450, "Luftfeuchte: "..humidity,50,0,1,0,1) 
    font:write(100,550, "Niederschlag: " .. rain,50,0,1,0,1) 
    font:write(100,720, "Aktualisiert um "..dateTime ,20,0,1,0,1)
end
