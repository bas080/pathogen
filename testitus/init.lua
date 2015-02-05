pathogen.register_pathogen("test", {
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
  end,
  on_symptom = function( infection )
    print('on_symptom')
  end
})
