#!/usr/bin/env ruby
require './sif'

def test
    input = '123456789012'.split('').map { |pixel| pixel.to_i }
    sif = Sif.new(3,2)
    sif.load(input)
    puts sif.to_s
    puts "Checksum: #{sif.checksum}"
end

def test2
    input = '0222112222120000'.split('').map { |pixel| pixel.to_i }
    sif = Sif.new(2,2)
    sif.load(input)
    puts sif.to_s

    puts sif.render
end

input = ARGF.read.chomp.split('').map { |pixel| pixel.to_i }

sif = Sif.new(25, 6)
sif.load(input)

# puts sif.to_s
# puts "Part 1: #{sif.checksum}"
#puts sif.to_s
puts "Part 2: \n#{sif.render}"

# test2
