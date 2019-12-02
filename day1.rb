#!/usr/bin/env ruby

# Load our input file
input = ARGF.readlines

# Part 1: Calculate the fuel needed for the modules
def part1(input)
    input.map{ |line| line.to_i/3-2 }.inject(:+)
end

# Part 2: Calculate the fuel needed for the modules + fuel
def part2(input)
    input.map{ |line| gasfor(line.to_i) }.inject(:+)
end

# More complicated gas-for-mass algorithm.
# Does the same /3-2 math as for part one, but
# also does that /3-2 math recursively for the 
# returned fuel until we hit bottom
def gasfor(mass)
    mass <= 0 ? 0 : [mass/3-2,0].max + gasfor(mass/3-2)
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
