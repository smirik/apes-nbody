require 'yaml'
require 'tools/functions.rb'
require "integrators/nbody.rb"

CONFIG = YAML.load_file('config/config.yml')

planets_names     = CONFIG['constants']['planets_names'].to_a
path              = CONFIG['tests']['solar']['path']
number_of_planets = CONFIG['integration']['number_of_planets']

def analyze(nbody_file)
  planets_names     = CONFIG['constants']['planets_names'].to_a
  path              = CONFIG['tests']['solar']['path']
  number_of_planets = CONFIG['integration']['number_of_planets']

  planets_names.delete_at(0)

  # Open planets files
  planets_f = Array.new
  planets_names.each do |planet|
    planets_f.push(File.open(path+'/'+planet+'.dat', 'r'))
  end

  counter = 0
  File.open(nbody_file, 'r').each do |line|
    # Split line into float values
    data = line.split(';').map{|elem| elem.strip.to_f }
    data.delete_at(0)
  
    # 0-5 — Mercury (x,y,z,vx,vy,vz), 6-11 — Venus e.t.c.
    count = -1
    diff_x = Array.new
    diff_v = Array.new
    planets_f.each do |file|
      count+=1
      # f_data, p_data — arrays of 2 vectors: position and velocity
      f_data = (file.gets.split(';').map{|elem| elem.strip.to_f}/3).map{|elem| elem.to_v}
      p_data = []
      6.times do |i|
        p_data.push(data[count*6+i])
      end
      p_data = (p_data/3).map{|elem| elem.to_v}
    
      # Find difference: module of distance for position and velocity
      diff_x.push((f_data[0].module - p_data[0].module).abs)
      diff_v.push((f_data[1].module - p_data[1].module).abs)
    end
  
    printf("%d;", counter)
    number_of_planets.times do |i|
      printf("%24.16e;", diff_x[i])
    end
    printf("\n");
  
    counter+=1
  end

  # Close files
  planets_f.each do |file|
    file.close
  end

end

method = get_command_line_argument('method', false)
raise unless method

nbody_file = path+'/'+method+'.dat'
analyze(nbody_file)