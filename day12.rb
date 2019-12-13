#!/usr/bin/env ruby
require './moon'
rawmoons = ARGF.readlines

moons = []
rawmoons.each do |rawmoon|
  moons << Moon.new(rawmoon)
end

moons.each do |moon|
  puts "Found moon, #{moon.x}, #{moon.y}, #{moon.z}"
end

for step in 1..1000 do
  puts "Step #{step}" unless step % 100 > 0
  # Work out the new velocities for each moon
  moons.each do |andrea|
    moons.each do |michelle|
      andrea.gravitate(michelle) if andrea != michelle
    end
  end

  # Loose 'em
  moons.each do |moon|
    moon.orbit
  end

  # puts "After #{step} step#{step != 1 ? 's' : ''}:"
  # moons.each  {|moon| puts moon.to_s}
end

total = moons.map{ |m| m.totalenergy }.inject(:+)
puts "Total energy after 1000 steps: #{total}"
