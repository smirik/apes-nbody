require 'integrators/ephemeris.rb'
require "integrators/nbody.rb"

require "integrators/vector.rb"

def integrate

  @start_time = CONFIG['integration']['start_time']
  @stop_time  = CONFIG['integration']['stop_time']
  @step       = CONFIG['integration']['step'].to_f  
  @method     = CONFIG['integration']['integrator']  

  # Initialize initial datas
  eps = 0
  dt = @step
  dt_out = 10000000000000
  
  nb = Nbody.new
  nb.time    = @start_time
   
  # NASA datas
  data = [[0,-1.043406748756247E+00,3.125580257280309E-01,8.948500834246172E-02,-3.711057094315510E-03, -1.344966150998682E-02, -5.098876019078703E-03]]

  # creating initial conditions
  data.each_with_index{|elem, index| 
    nb.body[index] = Body.new
    nb.body[index].mass = elem[0]
    nb.body[index].pos = Vector.new([elem[1], elem[2], elem[3]])
    nb.body[index].vel = Vector.new([elem[4], elem[5], elem[6]])
  }            
  tmp = (nb.body[0].pos[0]-$planets[3][@start_time][0][0])**2 + (nb.body[0].pos[1]-$planets[3][@start_time][0][1])**2
  puts "\n distance #{tmp} \n"

  # find datas
  nb.evolve(@method, dt, @stop_time)

  # find distance between object and Earth                                                        
  tmp = (nb.body[0].pos[0]-$planets[3][@stop_time][0][0])**2 + (nb.body[0].pos[1]-$planets[3][@stop_time][0][1])**2
  tmp = (nb.body[0].pos-$planets[3][@stop_time][0]).module

  puts "\n distance #{tmp} \n"
  
end

eph = Ephemeris.new;        
$planets = eph.getPlanets
integrate
