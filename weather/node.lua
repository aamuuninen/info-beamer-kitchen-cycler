gl.setup(1024, 768)

local json = require"json"

util.auto_loader(_G)

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


util.file_watch("current", function(content)
    local newcurrent = secure_json_decode(content)
    if newcurrent ~= nil then
        current = newcurrent
    end
end)

util.file_watch("forecast", function(content)
    local newforecast = secure_json_decode(content)
    if newforecast ~= nil then
        forecast = newforecast
    end
end)

util.file_watch("weather_background.jpg", function(content)
    background = resource.load_image("weather_background.jpg")
end)

background = resource.load_image("weather_background.jpg")
font = resource.load_font("font.ttf")
webfont = resource.load_font("silkscreen.ttf")
function node.render()

    font:write(100, 100, "Wetter", 100, 1,0,0,1)
    font:write(100,250, "Temperatur: ",50,0,1,0,1) 
    font:write(100,350, "Luftfeuchte: %",50,0,1,0,1) 
    font:write(100,450, "Luftdruck: hPa",50,0,1,0,1) 
    font:write(100,550, "Niederschlag: ",50,0,1,0,1) 
    font:write(100,680, "Wetterdaten via ", 20,0,1,0,1) 
    font:write(100,720, "Aktualisiert um " ,20,0,1,0,1)
end
