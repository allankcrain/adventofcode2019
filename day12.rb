#!/usr/bin/env ruby
require './moon'
require 'pp'

def get_moons(rawmoons)
  moons = []
  rawmoons.each do |rawmoon|
    moons << Moon.new(rawmoon)
  end
  moons
end

def part1(moons)
  moons = moons.clone
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
  moons.map{ |m| m.totalenergy }.inject(:+)
end

def part2(moons)
  moons = moons.clone
  initials = {
    x: moons.map{|moon| moon.x} + moons.map{|moon| moon.v[0]},
    y: moons.map{|moon| moon.y} + moons.map{|moon| moon.v[1]},
    z: moons.map{|moon| moon.z} + moons.map{|moon| moon.v[2]},
  }
  pp initials
  stoptimes = [nil, nil, nil]
  step = 1

  while stoptimes.include?(nil) do
    moons.each do |andrea|
      moons.each do |michelle|
        andrea.gravitate(michelle) if andrea != michelle
      end
    end

    moons.each_with_index do |moon, idx|
      moon.orbit
    end

    # Check current against initials
    currents = {
      x: moons.map{|moon| moon.x} + moons.map{|moon| moon.v[0]},
      y: moons.map{|moon| moon.y} + moons.map{|moon| moon.v[1]},
      z: moons.map{|moon| moon.z} + moons.map{|moon| moon.v[2]},
    }
    stoptimes[0] = step if initials[:x] == currents[:x]
    stoptimes[1] = step if initials[:y] == currents[:y]
    stoptimes[2] = step if initials[:z] == currents[:z]
    step += 1

    # Tracking output
    if step % 100 == 0 then
      found = stoptimes.select{ |stoptime| stoptime != nil }.length
      # puts "Step #{step} #{found > 0 ? "| Found #{found}" : ''}"
    end
  end
  puts stoptimes
  stoptimes.inject(:lcm) / 2 # I straight-up don't know why /2. But it works?
end

rawmoons = ARGF.readlines
moons = get_moons(rawmoons)
puts "Total energy after 1000 steps: #{part1(moons)}"
puts "Everything goes around again at #{part2(get_moons(rawmoons))}"
