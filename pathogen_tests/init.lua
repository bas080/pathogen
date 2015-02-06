--while [ 0 ]; do ./bin/minetest --server --quiet --address '' --worldname miniol --go --name test; read -p "Press any key to continue... " -n1 -s; done

local _pathogen

local shutdown = function()
  minetest.after( 0, function()
    --shutdown the server
    ----
    print('request_shutdown')
    minetest.request_shutdown()
  end)
end

lunit.tests( 'pathogen', function( unit )
  --PATHOGENS
  _pathogen = unit.ok( pathogen.register_pathogen('apathogen', {
    symptoms = 2,
    latent_period = 1,
    infection_period = 3,
    description = 'apathogen description',
    on_death = function( infection )
    end,
    on_infect = function( infection )
    end,
    on_recover = function( infection )
    end,
    on_symptom = function( infection )
    end
  }), 'register pathogen' )

  unit.ok( pathogen.get_pathogen( 'apathogen' ) , 'get pathogen' )
  unit.equal( pathogen.get_pathogen( 'npathogen' ),   nil, 'get not pathogen' )
  unit.ok( type( pathogen.get_pathogens() ) , 'get all pathogens' )

  --INFECTIONS
  local infection = unit.ok( pathogen.infect( _pathogen, 'aplayer' ), 'infect player with pathogen' )
  unit.ok( pathogen.infect( _pathogen, 'nplayer'), 'infect non existing player' )
  unit.equal( type( pathogen.get_infection( 'aplayer', 'apathogen' ) ), 'table', 'get infection' )
  unit.equal( type( pathogen.get_infections( ) ), 'table', 'get all infections' )
  unit.equal( type( pathogen.get_player_infections( 'aplayer' ) ), 'table', 'get all player infections' )

  unit.ok( pathogen.perform_symptom( infection, 0 ), 'symptom within the max amount of symptoms' )
  unit.ok( not pathogen.perform_symptom( infection, 400 ), 'symptom out of bounds' )

  unit.equal( pathogen.immunize( infection ), true, 'immunize player' )

  unit.ok( pathogen.remove_infection( infection ), 'remove an infection' )
  unit.ok( not pathogen.get_infection( 'aplayer', 'apathogen'), 'get removed infection')

  --repeat these tests after the infection has been removed
  unit.ok( not pathogen.perform_symptom( infection, 0 ), 'symptom within the max amount of symptoms' )
  unit.ok( not pathogen.perform_symptom( infection, 1 ), 'symptom out of bounds' )

  --CONTAMINATION
  minetest.after( 0, function()
    --waits till the time starts on the server. This is required to get the
    --world nodes
    ----
    local pos = { x = 62, y = -2, z = 120}
    unit.ok( pathogen.contaminate( pos, 'apathogen'), 'contaminate node' )
    unit.equal( pathogen.get_contaminant( pos ), 'apathogen', 'get contaminated node')
    unit.ok( pathogen.decontaminate( pos ), 'decontaminate the node')
    unit.equal( pathogen.get_contaminant( pos ), false, 'get contaminated node')
  end)

  minetest.register_on_joinplayer( function( player )
    --tests that occur when the player joins
    ----
    local player_name = player:get_player_name()
    pathogen.infect( _pathogen, player_name )
    minetest.after( 2, function()
    end)
  end)

end)


