require 'ephemeris/ephemeris.rb'
require "integrators/body.rb"

require "integrators/vector.rb"

@start_time = CONFIG['integration']['start_time']
@stop_time  = CONFIG['integration']['stop_time']
@step       = CONFIG['integration']['step'].to_f  
@method     = CONFIG['integration']['integrator']  

eph = Ephemeris.new;        
$planets = eph.getPlanets

# Initialize initial datas
eps = 0
dt = @step

# NASA datas

# creating initial conditions

b = Body.new
b.simple_read
b.pp

# find datas
b.evolve(@method, dt, @start_time, @stop_time)

diff = (b.pos - $planets[3][@stop_time][0])
dist = diff.module

# find distance between object and Earth                                                        
b.pp
puts "earth: "
puts $planets[3][@stop_time][0].pp
puts "\n distance #{dist} \n"
