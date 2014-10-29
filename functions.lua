pathogen.register_pathogen = function(name, params)
  local incubation_time = params.incubation_time --in minutes
  local survival_rate   = params.survival_rate --0 being absolutly deadly and 1 being will survive for sure
  local survival_time   = params.survival_time --time after incubation time where symptoms are visible.
  local treatable = params.treatable --once infected the player will die.
  local preventable = params.preventable --requires preventative medication
  local infection_range = params.infection_range --range in which player could get infected
  local infection_rate  = params.infection_rate --chance that someone will get infected when within infection_range
  pathogen.pathogens[name] = params
end

pathogen.get_pathogen = function(name)
  return pathogen.pathogens[name]
end

pathogen.show_simptons = function(player)
  local pos = player:getpos()
  --spawn vomit particles
end

pathogen.load = function(file_name) --Write neater TODO
  local file_name = minetest.get_worldpath()..'/'..file_name
  local file_data = io.open(file_name, 'r')
  if file_data then
    local data_stri = file_data:read();
    local data_list = minetest.parse_json(data_stri)
    if data_list == nil then
      data_list = {}
    end
    data_file:close()
  else
    data_list = {}
  end
  return data_list
end

pathogen.save = function()
  local data_stri = minetest.write_json(pathogen.data)
  local data_file = io.open(pathogen.file, 'w')
  data_file:write(data_stri)
  data_file:close()
end

pathogen.player_is_connected = function(player_name)
  local players = minetest.get_connected_players()
  for i, v in pairs(players) do
    print(v)
    if v:get_player_name() == player_name then
      return true
    else
      return false
    end
  end
end
