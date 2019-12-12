#!/usr/bin/env ruby
require './asteroidfield'

field = AsteroidField.new(ARGF)

base, targets = field.highest_visibility
puts "Highest visibility: #{targets} seen by #{base}"

targets = field.targets(base)

puts "Zappin' 'roids"
counter = 1
while counter <= 200 && targets.length > 0 do
    # Aim for the next target
    target = targets.shift
    # Zap the victim
    field.zap(target[:real])
    # Refresh our target list if necessary
    targets = field.targets(base) unless targets.length > 0
    counter += 1
end

puts "Last target is #{target[:real]}, so our answer is #{target[:real][0]*100 + target[:real][1]}"
