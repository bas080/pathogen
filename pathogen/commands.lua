minetest.register_privilege('pathogen', "infect and cure players of pathogens")
--TODO Check if player exists and then perform an infect or immunize

minetest.register_chatcommand("infect", {
  params = "pathogen player",
  description = "infect a player with a pathogen",
  privs = { pathogen=true },
  func = function(name, params)
    local params = params:split(' ')
    local player_name = params[1]
    local pathogen_name = params[2]
    if not minetest.get_player_by_name( player_name ) then
      minetest.chat_send_player(name, 'could not infect: player '..player_name..' does not exist')
    end
    local _pathogen = pathogen.get_pathogen( pathogen_name )
    if _pathogen then
      if pathogen.infect( _pathogen, player_name ) then
        minetest.chat_send_player(name, 'infected '..player_name..' with '..pathogen_name )
      end
    else
      minetest.chat_send_player(name, 'could not infect: pathogen '..pathogen_name..' does not exist')
    end
  end
})

minetest.register_chatcommand("pathogens", {
  params = "",
  description = "list all available pathogens",
  privs = {},
  func = function(name, params)
    local pathogens = pathogen.get_pathogens()
    for key, _pathogen in pairs( pathogens ) do
      print( key, _pathogen.description )
      minetest.chat_send_player( name, _pathogen.name..' - '.._pathogen.description )
    end
  end
})

minetest.register_chatcommand("immunize", {
  params = "pathogen player",
  description = "cure a player from an infection",
  privs = { pathogen=true },
  func = function(name, params)
    local params = params:split(' ')
    local player_name = _params[1]
    local pathogen_name = _params[2]
    local infection = pathogen.get_infection( pathogen_name, player_name )
    if infection then
      if not minetest.get_player_by_name( player_name ) then
        minetest.chat_send_player(name, 'could not immunize: player '..player_name..' does not exist')
      else
        if pathogen.immunize( infection ) then
          minetest.chat_send_player(name, 'infected '..player_name..' from '..pathogen_name )
        end
      end
    else
        minetest.chat_send_player(name, 'could not immunize: player '..player_name..' does not exist')
    end
  end
})
