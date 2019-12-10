#!/usr/bin/env ruby
require './intcode'

# Get all permutations of the given array
def pa(array)
  return [array] if array.length==1
  # For each element in the array, pull it out and generate the permutations without it
  output = []
  array.each do |el|
    output += pa(array - [el]).map { |subperm| [el] + subperm }
  end
  output
end

def part1(memcore)
  # Get all permutations of [0,1,2,3,4] for the phase settings
  phase_set_options = pa([0,1,2,3,4])

  result = 0
  for phase_set in phase_set_options do
    output = [0]
    molestable_phase_set = phase_set.clone
    for amp in ['a','b','c','d','e'] do
      phase = molestable_phase_set.shift
      input = [phase, *output]

      ampcomp = Intcode.new(memcore)
      # binding.pry
      output = ampcomp.run(input)
    end
    result = output[0] if output[0] > result
  end

  result
end

def amplify_with_phase(phase_set, memcore)
  phase_set = phase_set.clone
  amps = {}
  # Set up our VMs
  ('a'..'e').each do |ltr|
    amps[ltr] = {
      vm: Intcode.new(memcore),
      name: ltr,
    }
    amps[ltr][:vm].continue(phase_set.shift)
  end

  output = 0
  while (amps['e'][:vm].status != Intcode::STATUS_HALT) do
    for ltr in 'a'..'e' do
      amps[ltr][:vm].continue(output)
      output = amps[ltr][:vm].output.pop
    end
  end
  output
end

def part2(memcore)
  phase_set_options = pa([5,6,7,8,9])

  maxwell = 0
  for phase_set in phase_set_options do
    maxwell = [maxwell, amplify_with_phase(phase_set, memcore)].max
  end
  maxwell
end

memcore = Intcode.file2mem(ARGF)

puts "Part 1: Highest we got was #{part1(memcore)} baby "
puts "Part 2: Let's say #{part2(memcore)}"
