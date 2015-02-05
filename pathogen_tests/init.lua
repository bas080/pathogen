--[[ For testing without gui
while [ 0 ]; do ./bin/minetest --server --quiet --address '' --worldname miniol
--go --name test; read -p "Press any key to continue... " -n1 -s; done
]]--

minetest.get_player_by_name = function()
  return ''
end

lunit.tests( 'pathogen', function( unit )

  --PATHOGENS
  local _pathogen = unit.ok( pathogen.register_pathogen('apathogen', { 
    symptoms = 2,
    latent_period = 10,
    infection_period = 100,
    description = 'apathogen description',
    on_symptom = function()
    end,
    on_recover = function()
      return true
    end,
  }), 'register pathogen' )

  unit.ok( pathogen.get_pathogen( 'apathogen' ) , 'get pathogen' )
  unit.equal( pathogen.get_pathogen( 'npathogen' ),   nil, 'get not pathogen' )
  unit.ok( type( pathogen.get_pathogens() ) , 'get all pathogens')

  --INFECTIONS
  local infection = unit.ok( pathogen.infect( _pathogen, 'aplayer' ), 'infect player with pathogen' )
  unit.equal( type( pathogen.get_infection( 'aplayer', 'apathogen' ) ), 'table', 'get infection' )
  unit.equal( type( pathogen.get_infections( ) ), 'table', 'get all infections' )
  unit.equal( type( pathogen.get_player_infections( 'aplayer' ) ), 'table', 'get all player infections' )

  unit.ok( pathogen.perform_symptom( infection, 0 ), 'symptom within the max amount of symptoms' )
  unit.ok( not pathogen.perform_symptom( infection, 3 ), 'symptom out of bounds' )

  unit.equal( pathogen.immunize( infection ), true, 'immunize player' )

  unit.ok( pathogen.remove_infection( infection ), 'remove an infection' )
  unit.ok( not pathogen.get_infection( 'aplayer', 'aplayer'), 'player is removed')

  --repeat these tests after the infection has been removed
  unit.ok( not pathogen.perform_symptom( infection, 0 ), 'symptom within the max amount of symptoms' )
  unit.ok( not pathogen.perform_symptom( infection, 1 ), 'symptom out of bounds' )

end)

--shutdown the server
minetest.after( 0, function()
  print('request_shutdown')
  minetest.request_shutdown()
end)
