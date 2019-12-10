#!/usr/bin/env ruby

def has_double?(num)
  num.to_s.match(/([0-9])\1/)
end

# Figure out if there's a double-digit that's
# not part of a larger group of digits.
# I'm sure there's a way to do this with a pure regex
# match or some kind of math, but... meh. This works.
# Replace any groups of three or more of a digit with _,
# then check for any remaining doubles.
def has_strict_double?(num)
  has_double?(num.to_s.gsub(/([0-9])\1{2,}/, '_'))
end

def increasing?(num)
  last = num.to_s[0]
  num.to_s[1..-1].split('').each do |digit|
    return false unless last <= digit
    last = digit
  end
  true
end

def part1(from, to)
  candidates = []
  for candidate in from..to do
    candidates << candidate if has_double?(candidate) && increasing?(candidate)
  end
  candidates.length
end

def part2(from,to)
  candidates = []
  for candidate in from..to do
    candidates << candidate if increasing?(candidate) && has_strict_double?(candidate)
  end
  candidates.length
end

puts "Part 1: #{part1(273025,767253)}"
puts "Part 2: #{part2(273025,767253)}"
