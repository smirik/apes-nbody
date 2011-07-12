require 'yaml'
require "integrators/nbody.rb"

CONFIG = YAML.load_file('config/config.yml')

def integrate

  @start_time = CONFIG['integration']['start_time']
  @stop_time  = CONFIG['integration']['stop_time']
  @step       = CONFIG['integration']['step'].to_f  
  @method     = CONFIG['integration']['integrator']  

  # Initialize initial datas
  eps = 0
  
  nb = Nbody.new
  nb.time = @start_time
  nb.simple_read
  nb.evolve(@method, @step)
  
  raise
   
  # find datas

  # find distance between object and Earth                                                        
  tmp = (nb.body[0].pos[0]-$planets[3][@stop_time][0][0])**2 + (nb.body[0].pos[1]-$planets[3][@stop_time][0][1])**2
  tmp = (nb.body[0].pos-$planets[3][@stop_time][0]).module

  puts "\n distance #{tmp} \n"
  
end

integrate
