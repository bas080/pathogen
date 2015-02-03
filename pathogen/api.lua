pathogen.register_pathogen = function( pathogen_name, definition )
  --the command that is used to register pathogens
  ----
  if not pathogen.get_pathogen( pathogen_name ) then
    definition.name = pathogen_name;
    pathogen.pathogens[pathogen_name] = definition
  else
    print( " pathogen already registered" )
  end
end

pathogen.spawn_fluid = function( name, pos, pathogen_name )
  --spawn the infectious juices
  ----
  if minetest.get_node( pos ).name == "air" then
    local node_name = "pathogen:fluid_"..name
    minetest.set_node( pos, { name = node_name, param2=1 } )
    local meta = minetest.get_meta( pos )
    meta:set_string( "pathogen", pathogen_name )
  end
end

pathogen.register_fluid = function( name )
  --registering a fluid(juice). This assumes that all fluids are flat on the
  --floor
  ------
  local texture = "pathogen_fluid_"..name..".png"
  local node_name = "pathogen:fluid_"..name
  pathogen.fluids[ name ] = node_name
  minetest.register_node( node_name, {
    description= name,
    drawtype = "signlike",
    inventory_image = texture,
    tiles = { texture },
    paramtype = "light",
    paramtype2 = "wallmounted",
    walkable = false,
    sunlight_propagates = true,
    drop = "",
    groups = { oddly_breakable_by_hand = 2, crumbly = 2 },
    on_punch = function(pos, node, puncher, pointed_thing)
      local meta = minetest.get_meta( pos )
      local pathogen_name = meta:get_string( "pathogen" )
      local player_name = puncher:get_player_name()
      pathogen.infect( pathogen_name, player_name )
    end,
    selection_box = {
      type = "fixed",
      fixed = {-0.5, -0.5, -0.5, 0.5, -7.9/16, 0.5},
    },
  })
end

pathogen.decontaminate_fluid = function( pos )
  if not pos then return end
  local _meta = minetest.get_meta( pos )
  local _pathogen = _meta:get_string( 'pathogen' )
  if #_pathogen ~= 0 then
    _meta:set_string( 'pathogen', '' )
  end
end

pathogen.infect = function( pathogen_name, player_name )
  --notice that all parameters are strings. Threwout the mod the arguments are
  --all primitive strings. is that good practice or should i use complex types?
  --infect a player with a pathogen
  --------

  local _pathogen = pathogen.get_pathogen( pathogen_name, player_name )
  if not _pathogen then return end
    --do not perform infection if infection has already occured
    ----
  local _player = minetest.get_player_by_name( player_name )

  if _pathogen == nil then return false end
    --check if pathogen exists
    ------

  local _infection = {
    --The table containing all the data that a infection cinsists out of. See
    --the README.md for a more extensive explanation
    ------
    symptom = 0,
    pathogen = pathogen_name,
    player = player_name,
    immune = false
  }

  pathogen.infections[ player_name..pathogen_name ] = _infection
  print( "infected: "..player_name.." with "..pathogen_name )
    --store the infection in a table for later use. This table is also saved and
    --loaded if the persistent option is set
    ------
  if _pathogen.on_infect then
    --check if on_infect has been registered
    ----
    _pathogen.on_infect( _infection )
  end
    --perform the on_infect command that is defined in the regsiter function
    --this is not the same as the on_symptoms. It is called only once at the
    --beginning of the infection
    --------
  minetest.after( _pathogen.latent_period, function()
    --latent perios is the time till the first symptom shows
    ----
    pathogen.perform_symptom( pathogen_name, player_name, 1 )
      --show the first symptom
      ----
  end)
end

pathogen.get_players_in_radius = function( pos, radius )
  local objects = minetest.get_objects_inside_radius(pos, 5)
  local players = {}
  for index, object in ipairs(objects) do
    if object:is_player() then
      players[#players+1] = object
    end
  end
  return players
end

pathogen.perform_symptom = function( pathogen_name, player_name, symptom_n )
  --An infection can also be initiated without having to perform the on_infect.
  --you can can cut straight to a particular symptom by using this function
  --notice the symptom_n argument.
  --------
  local _infection = pathogen.infections[ player_name..pathogen_name ]
  local _pathogen = pathogen.pathogens[pathogen_name]
  if not _infection.immune then
    --only keep showing symptoms if there is no immunity against the pathogen
    ----
    local symptom_n = symptom_n + 1
    if ( _pathogen.symptoms > symptom_n ) then --check if all symptoms have occured
      --only show symptoms not all symptoms have occured.
      _infection.symptom = symptom_n
      _pathogen.on_symptom( _infection )
      local _interval = ( ( _pathogen.infection_period - _pathogen.latent_period ) / _pathogen.symptoms )
      minetest.after(  _interval , function()
        --set the time till the next symptom and then perfrom it again
        ----
        pathogen.perform_symptom( pathogen_name, player_name, symptom_n )
      end)
    else
      --survives and is now immunized, immunization lasts till the server is
      --restarted
      ------
      pathogen.immunize( pathogen_name, player_name )
    end
  end
end

pathogen.get_pathogen = function( pathogen_name )
  --get the datat of a particular pathogen
  ----
  return pathogen.pathogens[pathogen_name]
end

pathogen.get_infection = function( player_name, pathogen_name )
  --get an infection of a certain player
  ----
  return pathogen.infections[ player_name..pathogen_name ]
end

pathogen.immunize = function( pathogen_name, player_name )
  --immunize a player so the next symptom won"t show.
  ----
  print( "immunized: "..player_name.." from "..pathogen_name )
  local _infection = pathogen.get_infection( player_name, pathogen_name )
  if _infection.on_immunize then _infection.on_immunize( _infection ) end
  if _infection then
    _infection.immune = true
    return true
  else
    return false
  end
end

pathogen.remove_infection = function( pathogen_name, player_name )
  --removes the immunization and the infection all together
  ----
  if pathogen.infections[player_name..pathogen_name] then
    pathogen.infections[player_name..pathogen_name] = nil
  end
end

pathogen.save = function( infections )
  --TODO save the infections so it won"t get lost between server reloads
  local serialized = minetest.serialize( infections )
  return serialized
end

pathogen.load = function( run )
  --TODO if run is true the loaded pathogens will run immediatly
  local deserialized = minetest.deserialize(string)
  return deserialized
end

pathogen.get_infections = function()
  return pathogen.infections
end

pathogen.get_pathogens = function()
  return pathogen.pathogens
end

pathogen.get_player_infections = function( player_name )
  local _infections = pathogen.get_infections()
  local _output = {}
  for index, infection in pairs(_infections) do
    if infection.player == player_name then
      _output[#_output+1] = infection
    end
  end
  return _output
end

minetest.register_on_dieplayer( function( player )
  --when dying while having a pathogen it will trigger the on_death and it will
  --remove the current infections
  ------
  local player_name = player:get_player_name()
  local _infections = pathogen.get_player_infections( player_name )
  for index, infection in pairs(_infections) do
    local _pathogen = pathogen.get_pathogen( infection.pathogen )
    local on_death = _pathogen.on_death
    if on_death then
      on_death( infection )
      pathogen.remove_infection( pathogen_name, player_name )
    end
  end
end)

