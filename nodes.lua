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
