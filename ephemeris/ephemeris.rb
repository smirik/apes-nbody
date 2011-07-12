require 'yaml'
include Math

CONFIG = YAML.load_file('config/config.yml')

class Ephemeris 
   
  attr_accessor :eph_path, :datas_path, :eph_file

  def initialize
    @eph_path   = CONFIG['ephemeris']['execute_path']
    @datas_path = CONFIG['ephemeris']['datas_path']
    @eph_file   = CONFIG['ephemeris']['file']
  end
  
  def getPosVel(start_time, end_time, step = 1, target = 3, center = 11)
    end_time += step
    coords = `#{@eph_path}/ephem #{@datas_path}/#{@eph_file} #{start_time} #{end_time} #{step} #{target} #{center};`
    res = coords.split("\n")     
    str = Hash.new   
    current = start_time
    c_step  = (end_time - start_time)/step
    res.each do |elem|
      tmp = elem.split(";")               
      str[current] = [Vector.new([tmp[0].to_f, tmp[1].to_f, tmp[2].to_f]), Vector.new([tmp[3].to_f, tmp[4].to_f, tmp[5].to_f])]
      current += step
    end 
    str
  end
  
  def getPlanets()
    planet = Array.new
    for i in 1..CONFIG['integration']['number_of_planets'] do
      planet[i] = self.getPosVel(CONFIG['integration']['start_time'], CONFIG['integration']['stop_time'], CONFIG['integration']['step'], i)
    end
    planet
  end

  def getPlanetsCoordsForTime(time)
    planet = Array.new
    for i in 1..CONFIG['integration']['number_of_planets'] do
      tmp = self.getCoordsForTime(i, time)
      planet[i] = tmp[time]
    end
    planet
  end

  def self.getCoordsForTime(planet, time)
    #planet = self.getPosVel(time, time, CONFIG['integration']['step'], planet)
    if ($planets[planet][time])
      $planets[planet][time]
    else
      false
    end
  end
  

end      


