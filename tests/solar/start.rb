# Task for calculating
require 'yaml'
require 'tools/functions.rb'
require "integrators/nbody.rb"

config_file = 'config/config.yml'
CONFIG = YAML.load_file(config_file)

planets_names     = CONFIG['constants']['planets_names'].to_a
path              = CONFIG['tests']['solar']['path']
methods           = CONFIG['integration']['methods']

# Create ephemeris 
puts "Generate NASA DE405 ephemeris"
de405 = `ruby #{path}/de405.rb`

# Calculate dat files for integrator
methods.each do |method|
  CONFIG['integration']['method'] = method
  File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }
  puts "Calculate #{method}"
  tmp     = `ruby #{path}/integrate.rb < input/solar.in > #{path}/#{method}.dat`
end

CONFIG['integration']['method'] = 'rk4'
File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }

# Analyze files

puts "Generate diff"
methods.each do |method|
  analyze = `ruby #{path}/analyze.rb --method=#{method} > #{path}/result_#{method}.dat`
end

puts "Restore default config"
`mv config/config.yml.default config/config.yml`