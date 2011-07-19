# Task for calculating
require 'yaml'
require 'tools/functions.rb'
require "integrators/nbody.rb"

config_file = 'config/config.yml'
CONFIG = YAML.load_file(config_file)

planets_names     = CONFIG['constants']['planets_names'].to_a
path              = CONFIG['tests']['twobody']['path']
tests_path        = CONFIG['tests']['path']
methods           = CONFIG['integration']['methods']

# Calculate dat files for integrator
methods.each do |method|
  CONFIG['integration']['method'] = method
  File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }
  puts "Calculate #{method}"
  tmp     = `ruby #{tests_path}/integrate.rb < input/earth.in > #{path}/#{method}.dat`
end

CONFIG['integration']['method'] = 'rk4'
File.open(config_file, 'w+') { |out| YAML::dump(CONFIG, out) }

# Analyze files
puts "Restore default config"
`cp config/config.yml.default config/config.yml`