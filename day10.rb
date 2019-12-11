#!/usr/bin/env ruby

require './asteroidfield'

field = AsteroidField.new(ARGF)

puts "Highest visibility: #{field.highest_visibility}"
