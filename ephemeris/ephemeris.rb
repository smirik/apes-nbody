require 'yaml'
include Math

CONFIG = YAML.load_file('config/config.yml')

class Ephemeris 
   
  attr_accessor :eph_path, :datas_path, :eph_file, :planets_names

  def initialize
    @eph_path      = CONFIG['ephemeris']['execute_path']
    @datas_path    = CONFIG['ephemeris']['datas_path']
    @eph_file      = CONFIG['ephemeris']['file']
    @planets_names = CONFIG['constants']['planets_names']
  end
  
  def getPosVel(start_time, end_time, step = 1, target = 3, center = 11)
    end_time += step
    coords = `#{@eph_path}/ephem #{@datas_path}/#{@eph_file} #{start_time} #{end_time} #{step} #{target} #{center} > tests/solar/#{@planets_names[target]}.dat;`
  end
  
  def getPlanets()
    for i in 1..CONFIG['integration']['number_of_planets'] do
      self.getPosVel(CONFIG['integration']['start_time'], CONFIG['integration']['stop_time'], CONFIG['integration']['step'], i)
    end
    true
  end

end      


