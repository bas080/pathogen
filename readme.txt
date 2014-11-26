PATHOGEN
--------
         BY:    Bas080
DESCRIPTION:    Infect and cure players from infections
    VERSION:    0.1
    LICENSE:    WTFPL
      FORUM:    http://TODO

DOCUMENTATION CONTENTS
----------------------
1.0 FEATURES
2.0 API
  2.1 pathogens
  2.2 infections

1.0 FEATURES
------------
* Register pathogens with the use of an API (see api documentation)
* Demonstration pathogen named "ebola" and another named "cold"
* Infect a player with a pathogen which results in the consequences of the pathogen

2.0 API
-------

2.1 pathogens
-------------

   FUNCTION:    pathogen.register_pathogen( name , params )
DESCRIPTION:    register pathogen in table pathogen.pathogens which is global
    EXAMPLE:    pathogen.register_pathogen('cold', {
                    description = "The common cold which results in sneezing and a slight fever.",
                    incubation_time = 10, --time elapsed before becoming infectious
                    infection_time = 100, --time before infection stops
                    survival_rate = 0.95, --chance of survival 0 to 1=will always survive
                    sympton_time = 10, --average intervals between on_sympton
                    on_exposure = function(player, infected, pathogen) --when player gets
                        print('exposed')
                    end,
                    on_infection = function(player, pathogen) --
                        print('infectious')
                    end,
                    on_sympton = function(player, pathogen)
                        print('cough or poop')
                    end,
                    on_cured = function(player, pathogen)
                        print('survives')
                    end,
                    on_death = function(player, pathogen)
                        print('died')
                    end
                })
     OUTPUT:    returns table of the registered pathogen

   FUNCTION:    pathogen.get_pathogen_by_name( name )
DESCRIPTION:    returns table containing pathogen properties. If pathogen not registered it returns false
    EXAMPLE:    pathogen.get_pathogen_by_name( 'abola' )
     OUTPUT:    returns false because ebola was spelled wrong,
                if spelled correctly it would return ebola pathogen properties

2.2 infections
--------------

   FUNCTION:    pathogen.register_infection( player_name, pathogen_name )
DESCRIPTION:    infect a player with a certain pathogen
    EXAMPLE:    pathogen.register_infection( 'singleplayer', 'cold' )
     OUTPUT:    returns an infection table { player = player_name , pathogen = pathogen_name },
                and registers the infection in pathogen.infections table

   FUNCTION:    pathogen.terminate_infection( player_name, pathogen_name )
DESCRIPTION:    can be used to stop an infection. Can be used to make the use of an item cure an infection
    EXAMPLE:    pathogen.terminate_infection( 'bas080' , 'ebola' ) --player bas080 now no longer has ebola.
     OUTPUT:    returns false if such infection does not exist, and true if termination was succesfull

   FUNCTION:    pathogen.treat_infection( player_name, pathogen_name )
DESCRIPTION:    start the treatment. Triggers the on_treatment function
    EXAMPLE:    pathogen.treat_infection( player_name, pathogen_name )
     OUTPUT:    false if such infection does not exist else returns infection table
