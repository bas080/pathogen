PATHOGEN
========
A minetest mod that enables users to get a pathogen.

Features
========
- Easily define a new pathogen using the pathogen API
- Demo pathogens that are infectious and sometimes deadly.

Diseases
========

Influencia
----------
Highly contagious as it is airborne. Being around someone that has the diseases
increases the chances of getting the virus drastically. It is advised to eat well
and keep your distance from players that are coughing. Death is very unlikely.

Panola
------
Contagious threw body fluids. It is ok to be near someone that has the diseases.
Make sure that when cleaning up after someone that has expelled fluids, to
decontaminate the fluids first. This can be done with the Decontaminator.

Items
=====
- Comes with nodes like vomit, blood and feces that are infectious when dug.
- A bio hazard warning fence, in case a quarantine is required.
- A decontaminater for removing infectious fluids.

Crafts
======
**Decontaminater**
{'xpanes:bar','',''},
{'','default:steelblock',''},
{'','',''}

API
===

Register pathogens
------------------
```lua
pathogen.register_pathogen("influencia", {
  description = "Highly contagious and possibly deadly for those with low health.",
  symptoms = 12,
  latent_period = 240,
  infection_period = 740,
  on_infect = function( infection )
    minetest.sound_play( "pathogen_cough", { pos = pos, gain = 0.3 } )
  end,
  on_symptom = function( infection )
    local player = minetest.get_player_by_name( infection.player )
    local pos = player:getpos()
    local players_nearby = pathogen.get_players_in_radius(pos, 5)
    local hp = player:get_hp()
    if hp <= 14 then
      player:set_hp( hp - 1 ) 
      if math.random(10) == 1 then
        player:set_hp( 6 ) 
      end
    end
    if math.random(2) == 1 then
    minetest.sound_play( "pathogen_sneeze", { pos = pos, gain = 0.3 } )
    else
    minetest.sound_play( "pathogen_cough", { pos = pos, gain = 0.3 } )
    end
    for index, player_nearby in ipairs(players_nearby) do
      local player_nearby_name = player_nearby:get_player_name()
      if player_nearby_name ~= infection.player then
        if math.random(3) == 1 then
          pathogen.infect( infection.pathogen, player_nearby_name )
        end
      end
    end
  end
})
```

Pathogen definition
-------------------
|key|type|description|
|---|----|-----------|
|symptom|number|the amount of times symptoms are shown|
|latent_period|number|seconds before the symptoms start showing|
|infection_period|number|seconds from infection till last symptom|
|on_infect( infection )|function|actions to perform when infected ( this happens as soon as the infection takes place )|
|on_symptom( infection )|function|happens as many times as the defined symptom amount|
|on_death( infection )|function|called when the player dies while having the pathogen|

###infection
All function in the pathogen definition give an infection table as callback.
The infection table includes.

|key|type|description|
|---|----|-----------|
|symptom|number|an integer that represents the index of current symptom|
|player|string|the name of the player|
|immune|bool|when true the infection has stopped. For now it does not mean that the player cant be reinfected|
|pathogen|string|the name of the pathogen|

Functions
---------
```lua
--pathogens
pathogen.register_pathogen( pathogen_name, definition )

--getters
pathogen.get_pathogen( pathogen_name )
pathogen.get_pathogens()
pathogen.get_infection( player_name, pathogen_name )
pathogen.get_infections()
pathogen.get_players_in_radius( pos, radius )
pathogen.get_player_infections( player_name )

--actions
pathogen.infect( pathogen_name, player_name )
pathogen.perform_symptom( pathogen_name, player_name, faze )
  --this function allows to add a pathogen that is already in a certain face.
  --Fade is a number that represents the id of the state of the infection
  ------
pathogen.immunize( pathogen_name, player_name )
pathogen.remove_infection( pathogen_name, player_name )
  --the difference between immunize and remove is that immunize makes the player
  --never get sick of the same sickness again and remove removes the current
  --infection but also it's immunization, thus allowing the player to get
  --infected again.
  ----------

--fluids (flat node boxes that represent contaminated fluids)
pathogen.register_fluid( name )
pathogen.spawn_fluid( name, pos, pathogen_name )
pathogen.decontaminate_fluid( pos )
  --fluids are contaminated nodes that will infect a player that punches that
  --node. Considering making this more generic by allowing to have a function
  --that allows making any node contaminable. Something like.
  --pathogen.contaminate( pos ).
  ----------

--makes the data persistent between server reloads (not yet implemented)
pathogen.save( infections )
pathogen.load( run )
```
Commands
========
Infections can be initiated by using commands. It requires the "pathogen"
privilege. /grant <playername> pathogen.

```lua
/pathogens
--list all pathogens and their descriptions

/infect <player name> <pathogen name>
--infect the player

/immunize <player name> <pathogen name>
--make player immune to particular pathogen
```

Roadmap
=======
- saving infections for persistence between server restarts
- more pathogens and cures
- make the API more flexible, consistent and forgiving
- consider immunization mechanic. Immunity is not indefinite...
- pathogen.contaminate( pos ) function

Reference
=========
- https://en.wikipedia.org/wiki/Incubation_period#mediaviewer/File:Concept_of_incubation_period.svg
- https://www.freesound.org
