#!/usr/bin/env ruby
require './intcode'

# Read in the file; Explode into an array
input_memory = ARGF.read.split(',').map { |value| value.to_i }

# Day 2 part 1: Replace memory locations 1 and 2 with 12 and 2 respectively; return output
def part1(input_memory)
    memory = input_memory.clone
    memory[1]=12
    memory[2]=2
    computor = Intcode.new(memory)
    computor.run
    computor.output
end

# Day 2 part 2: Find the replacements for memory locations 1 and 2 (which
# can each be between 0 and 99 inclusive) that results in the output 19690720
# (Which is the ISO8601 date for the Apollo 11 launch. Don't think I don't 
# see what you did there, Eric Wastl)
def part2(input_memory)
    noun = 0
    verb = 0
    desired_output = 19690720
    loop do
        memory = input_memory.clone
        memory[1]=noun
        memory[2]=verb
        computor = Intcode.new(memory)
        computor.run
        output = computor.output
        #puts "Noun #{noun}, verb #{verb} = #{output}"
        break if computor.output==desired_output || (noun==99 && verb==99)
        verb+=1 if (noun +=1 ) == 100
        noun %= 100
    end
    100 * noun + verb
end

puts part1(input_memory)
puts part2(input_memory)
