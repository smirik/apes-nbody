require 'yaml'
require 'tools/functions.rb'
require "integrators/nbody.rb"

CONFIG = YAML.load_file('config/config.yml')

planets_names     = CONFIG['constants']['planets_names'].to_a
path              = CONFIG['tests']['solar']['output_path']
number_of_planets = CONFIG['integration']['number_of_planets']

def analyze_mercury()
  planets_names     = CONFIG['constants']['planets_names'].to_a
  planets_names.delete_at(0)
  planets_names_b = planets_names.clone
  planets_names[2]   = "Earthmoo"
  planets_names_b[2] = "Earth"
  path              = CONFIG['tests']['solar']['output_path']
  number_of_planets = CONFIG['integration']['number_of_planets']


  # Open planets files
  planets_f = Array.new
  planets_e = Array.new
  
  planets_names.each_with_index do |planet, key|
    planets_f.push(File.open('vendor/mercury6'+'/'+planet.upcase+'.AEI', 'r'))
    planets_e.push(File.open('output/solar'+'/'+planets_names_b[key].capitalize+'.dat', 'r'))
  end
  
  # Header
  planets_f.each do |file|
    5.times do |i|
      file.gets
    end
  end

  counter = 0
  File.open('output/solar'+'/'+planets_names_b[0].capitalize+'.dat', 'r').each do |line|
    # Split line into float values

    #data1 = line.split(';').map{|elem| elem.strip.to_f }
    #data.delete_at(0)
    
    for i in 1..(planets_names_b.count-1)
      line = line + planets_e[i].gets
    end
    data = line.gsub("\n", '').split(';').map{|elem| elem.strip.to_f }
    
    # 0-5 — Mercury (x,y,z,vx,vy,vz), 6-11 — Venus e.t.c.
    count = -1
    diff_x = Array.new
    diff_v = Array.new
    planets_f.each do |file|
      count+=1
      # f_data, p_data — arrays of 2 vectors: position and velocity
      f_data = file.gets.split(' ')
      f_data.delete_at(0)
      f_data = (f_data.map{|elem| elem.strip.to_f}/3).map{|elem| elem.to_v}
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

analyze_mercury()