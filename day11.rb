#!/usr/bin/env ruby
require './intcode'
require './paintbot'

memcore = Intcode.file2mem(ARGF)
mechalangelo = Paintbot.new(memcore)

mechalangelo.run

puts "Part 1: We painted #{mechalangelo.visited} squares"

puts mechalangelo.to_s


robotticelli = Paintbot.new(memcore, [[0,0]])
robotticelli.run
puts "Part 2: \n#{robotticelli.to_s}"
