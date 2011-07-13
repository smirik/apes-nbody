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
  
end

integrate
