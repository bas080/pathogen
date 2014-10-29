pathogen = { name = "pathogen", version = "0.1" } --global mod namespace
local debug = true

local dofiles = function(files) --load multiple lua files from the mod directory
  local modpath = minetest.get_modpath(pathogen.name)
  for _,file in pairs(files) do
    print("[pathogen] loading "..file..".lua")
    dofile(modpath.."/"..file..".lua")
  end
end

print("[pathogen] version: "..pathogen.version)

if debug then
  print("[pathogen] debug enabled")
  dofiles({"commands", "config", "functions", "pathogens" })
else
  dofiles({"commands", "config", "functions", "pathogens", "nodes"})
end

pathogen.init = function()
  local infections = pathogen.load("infections.json")
  print(infections)
  for infection in ipairs(infections) do
    print("[pathogen] infecting "..infecting.player.." with "..infection.pathogen)
    pathogen.update_infection(infection)
  end
end

pathogen.initiate_infection = function(params)
  pathogen.register_infection(params)
  pathogen.update_infection(params)
end

pathogen.register_infection = function(params)
  self = {}
  self.player = params.player
  self.pathogen = params.pathogen
  self.state = 'incubating'
  return self
end

pathogen.update_infection = function(params)
  
end

pathogen.update = function()
  --minetest.after(pathogen.interval, pathogen.update())
  --local players = minetest.get_connected_players()
end

pathogen.init()

print("[pathogen] Loaded!")
