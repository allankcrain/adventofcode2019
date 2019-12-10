#!/usr/bin/env ruby
require './intcode'

# Read in our input memory
input_memory = ARGF.read.split(',').map { |value| value.to_i }

def part1(input_memory)
  computor = Intcode.new(input_memory)
  output = computor.run
  output.each { |line| puts line }
end

part1(input_memory)
