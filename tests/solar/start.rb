# Task for calculating
require 'yaml'
require 'tools/functions.rb'
require "integrators/nbody.rb"

config_file = 'config/config.yml'
CONFIG = YAML.load_file(config_file)

puts "Save config"
`cp config/config.yml config/config.yml.default`

planets_names     = CONFIG['constants']['planets_names'].to_a
path              = CONFIG['tests']['solar']['path']
output_path       = CONFIG['tests']['solar']['output_path']
tests_path        = CONFIG['tests']['path']
methods           = CONFIG['integration']['methods']

# Create ephemeris 
puts "Generate NASA DE405 ephemeris"
de405 = `ruby #{path}/de405.rb`

# Calculate dat files for integrator
methods.each do |method|
  CONFIG['integration']['method'] = method
  File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }
  puts "Calculate #{method}"
  tmp     = `ruby #{tests_path}/integrate.rb < input/solar.in > #{output_path}/#{method}.dat`
end

CONFIG['integration']['method'] = 'rk4'
File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }

# Analyze files

puts "Generate diff"
methods.each do |method|
  analyze = `ruby #{path}/analyze.rb --method=#{method} > #{output_path}/result_#{method}.dat`
end

puts "Restore default config"
`cp config/config.yml.default config/config.yml`