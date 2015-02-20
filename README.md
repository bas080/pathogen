# PATHOGEN

A minetest mod that enables users to get a pathogen.

# Features

- Easily define a new pathogen using the pathogen API
- Demo pathogens that are infectious and sometimes deadly.

# Diseases

## Gravititus
Occurs when ascending too quickly. Symptons include hiccups and random sense of
gravity. There is no known cure yet. ( any suggestions? stone soup anyone? )

## Influencia
Highly contagious as it is airborne. Being around someone that has the diseases
increases the chances of getting the virus drastically. It is advised to eat well
and keep your distance from players that are coughing. Death is very unlikely.

## Panola
Contagious through body fluids. It is ok to be near someone that has the disease.
Make sure that when cleaning up after someone that has expelled fluids, to
decontaminate the fluids first. This can be done with the Decontaminator
![Decontaminator](pathogen/textures/pathogen_decontaminator.png).

## Gosirea
Symptons include gas and burps. Occasionaly a shard.
Carrier contaminates nearby surfaces when symptoms show. These can intern infect
players that dig the infected nodes. Not deadly for those that have good health.

# Items
- Comes with nodes like vomit, blood and feces that are infectious when dug.
- A bio hazard warning fence, in case a quarantine is required.
- A decontaminater for removing infectious fluids.

# Crafts
```lua
pathogen.recipes['xpanes:fence_warning'] =  {
  {'group:stick', 'wool:red', 'group:stick'},
  {'group:stick', 'wool:red', 'group:stick'},
  {'group:stick', 'wool:red', 'group:stick'}
}

pathogen.recipes['pathogen:decontaminator'] = {
  {'xpanes:bar','',''},
  {'','default:steelblock',''},
  {'','',''}
}
```

# Commands
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

# API

Register pathogens
------------------
```lua
pathogen.register_pathogen("pathogenia", {
  description = "An example disease",
  symptoms = 12,
  latent_period = 240,
  infection_period = 740,
  on_infect = function( infection )
    minetest.sound_play( "pathogen_cough", { pos = pos, gain = 0.3 } )
  end,
  on_symptom = function( infection )
    minetest.sound_play( "pathogen_cough", { pos = pos, gain = 0.3 } )
  end
  on_death = function( infection )
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

# API Functions
---------
```lua

--PATHOGENS
pathogen.register_pathogen = function( pathogen_name, definition )
  --checks if pathogen is registererd and registers if not
  ----
pathogen.get_pathogen = function( pathogen_name )
  --get the table of a particular pathogen
  ----
pathogen.get_pathogens = function()
  --gives all the pathogens that are registered
  ----

--CONTAMINENTS
pathogen.spawn_fluid = function( name, pos, pathogen )
  --spawn the infectious juices
  ----
pathogen.register_fluid = function( name )
  --registering a fluid(juice). This assumes that all fluids are flat on the
  --floor
  ------
pathogen.contaminate = function( pos, pathogen_name )
  --contaminates a node which when dug infects the player that dug the node
  ----
pathogen.decontaminate = function( pos )
  --remove the contamination from the node
  ----
pathogen.get_contaminant = function( pos )
  --used to check if the node is infected and to get the name of the pathogen
  --with which it is infected
  ------

--INFECTIONS
pathogen.infect = function( _pathogen, player_name )
  --infects the player with a pathogen. If not able returns false
  ----
pathogen.perform_symptom = function( infection, symptom )
  --An infection can also be initiated without having to perform the on_infect.
  --you can can cut straight to a particular symptom by using this function
  --notice the symptom_n argument. This is a number that determines the state of
  --the infection.
  ----------
pathogen.immunize = function( infection )
  --immunize a player so the next symptom won"t show.
  ----
pathogen.remove_infection = function( infection )
  --removes the immunization and the infection all together
  ----
pathogen.get_infection = function( player_name,  pathogen_name )
  --get an infection of a certain player
  ----
pathogen.get_infections = function( )
  --gives all the infections of all the players
  ----
pathogen.get_player_infections = function( player_name )
  --helper function for getting the infections of a certain player
  ----

--PERSISTENCE (WIP)
pathogen.save = function( )
pathogen.load = function( )

--HELPERS
pathogen.get_players_in_radius = function( pos, radius )
  --helper to get players within the radius.
  ----

```

Roadmap
=======
- saving infections for persistence between server restarts
- more pathogens and cures
- make the API more flexible, consistent and forgiving
- register immunization with pathogen in seconds

Reference
=========
- https://en.wikipedia.org/wiki/Incubation_period#mediaviewer/File:Concept_of_incubation_period.svg
- https://www.freesound.org

License
=======
- Code	WTFPL
- Images	WTFPL
- Sounds	CC
