local _pathogen = pathogen.register_pathogen("test", {
  description = "Pathogen for testing quickly",
  symptoms = 3,
  latent_period = 1,
  infection_period = 3,
  on_death = function( infection )
    print('on_death')
  end,
  on_infect = function( infection )
    print('on_infect')
  end,
  on_recover = function( infection )
    print('on_recover')
    local player_name = infection.player
    local player = minetest.get_player_by_name( player_name )
    print( player_name, player)
    local pos = player:getpos()
    pathogen.spawn_fluid( "blood", pos, infection.pathogen.name )
  end,
  on_symptom = function( infection )
    print('on_symptom')
  end
})

minetest.register_on_joinplayer( function( player )
  minetest.after( 2, function()
    print( player:getpos() )
    pathogen.infect( _pathogen, 'singleplayer' )
  end)
end)
