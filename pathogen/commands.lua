minetest.register_privilege('pathogen', "infect and cure players of pathogens")

minetest.register_chatcommand("infect", {
  params = "pathogen player",
  description = "infect a player with a pathogen",
  privs = { pathogen=true },
  func = function(name, params)
    local params = params:split(' ')
    local player_name = params[1]
    local pathogen_name = params[2]
    if minetest.get_player_by_name( player_name ) then
      pathogen.infect( pathogen_name, player_name )
      minetest.chat_send_player(name, 'infected '..player_name..' with '..pathogen_name)
    else
      minetest.chat_send_player(name, 'player does not exist')
    end
  end
})

minetest.register_chatcommand("pathogens", {
  params = "",
  description = "list all available pathogens",
  privs = {},
  func = function(name, params)
    local _pathogens = pathogen.get_pathogens()
    for key, pathogen in pairs(_pathogens ) do
      minetest.chat_send_player( name, pathogen.name..' - '..pathogen.description )
    end
  end
})

minetest.register_chatcommand("immunize", {
  params = "pathogen player",
  description = "cure a player from an infection",
  privs = { pathogen=true },
  func = function(name, params)
    local _params = params:split(' ')
    local _player_name = _params[1]
    local _pathogen_name = _params[2]
    local _infection = pathogen.infections[ _player_name.._pathogen_name ]
    if pathogen.immunize( _pathogen_name, _player_name ) then
      minetest.chat_send_player( name, 'succesfully immunized '.._player_name..' against '.._pathogen_name)
      return true
    else
      minetest.chat_send_player( name, 'immunization failed: requires player name and the pathogen name to work' )
      return false
    end
  end
})
