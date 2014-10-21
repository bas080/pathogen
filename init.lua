--[[NAMESPACES]]--
pathogen = {}
pathogen.file = minetest.get_worldpath()..'/pathogen.json'
pathogen.interval = 5
pathogen.infected = {}
pathogen.pathogens = {}

--[[NODES
  minetest.register_node('pathogen:centrifuge',{
    description = 'medical centrifuge',
    tiles = {'pathogen_centrifuge.png'},
    formspec = '',
    on_rightclick = function(pos, node, puncher)
      print('hello world')
    end
  })

  minetest.register_node('pathogen:sequencer',{
    description = 'genetic_sequencer',
  })

  minetest.register_node('pathogen:bodyly_fluids', {
    description = 'excretions',
    tiles = {'pathogen_excretions'},
  })

  minetest.register_node('pathogen:pathogen', {
    description = 'pathogen',
    tiles = {'pathogen_pathogen.png'},
    groups = {pathogen = 1},
  })
--
--[[FUNCTIONS]]--
  pathogen.init = function()  
    --pathogen.load()
    pathogen.register_pathogen('ebola', { --TODO make a seperate file containing the pathogen definitions
      incubation_time = 3600,
      survival_time = 1500,
      survival_rate = 0.5,
      infection_range = 2,
    })
  end

  pathogen.update = function()
    minetest.after(pathogen.interval, pathogen.update())
    local players = minetest.get_connected_players()
    print('update')
  end

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

  pathogen.infect_player = function(params)
    local player = params.player
    local pathogen_name = params.pathogen
    local pathogen = pathogen.get_pathogen(pathogen_name)
  end

  pathogen.get_pathogen = function(name)
    return pathogen.pathogens[name]
  end

  pathogen.cure_player = function()

  end

  pathogen.show_simptons = function(player)
    local pos = player:getpos()
    --spawn vomit particles
  end

  pathogen.load = function()
    local data_file = io.open(pathogen.file, 'r')
    if data_file then
      local data_stri = data_file:read();
      pathogen.data = minetest.parse_json(data_stri)
      if pathogen.data == nil then
        pathogen.data = {}
      end
      data_file:close()
    end
  end 

  pathogen.save = function()
    local data_stri = minetest.write_json(pathogen.data)
    local data_file = io.open(pathogen.file, 'w')
    data_file:write(data_stri)
    data_file:close()
  end

  pathogen.init()

--[[GLOBLA]]--
  minetest.register_on_joinplayer(function(player)
    minetest.after(5, function()
      hunger[name] = 0
      local pos = player:getpos()
      print(pos)
      pathogen.
      hunger.update(player, pos_one)
    end)
  end)

--[[Texture names /TEMPORARY TODO
  pathogen_centrifuge.png
  pathogen_syringe_antibody.png
  pathogen_syringe_blood.png
  pathogen_syringe_empty.png
  pathogen_vial_antibody.png
  pathogen_vial_empty.png
]]
