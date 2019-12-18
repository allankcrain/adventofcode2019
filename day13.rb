#!/usr/bin/env ruby

require './arcade'
require './intcode'
memcore = Intcode.file2mem(ARGF)

nintendo = Arcade.new(memcore)

screen = nintendo.play

blox = screen.select{ |pixel| pixel[2] == 2}.length
puts "Part 1: Painted #{blox} blocks"
