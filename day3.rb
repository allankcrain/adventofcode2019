#!/usr/bin/env ruby

# This is really messy and I'm not proud of it.
# I hate doing spacial geometry code.

# Load the input file
raw_wires = ARGF.readlines

require 'pp'
def path2segments(raw_wire, endpoint=nil)
    # Explode the line
    steps = raw_wire.split(',')
    segments = []
    x=0
    y=0
    steps.each do |vector|
        direction = vector[0]
        length = vector[1..-1].to_i
        segment = {xa: x, ya: y}
        case direction.downcase
        when 'u'
            segment[:yb] = (y += length)
        when 'd'
            segment[:yb] = (y -= length)
        when 'r'
            segment[:xb] = (x += length)
        when 'l'
            segment[:xb] = (x -= length)
        end
        at_end = endpoint && pointin?(segment,endpoint)
        segment[:xb] = endpoint[0] if at_end
        segment[:yb] = endpoint[1] if at_end
        segments << segment.clone
        break if at_end
    end
    segments
end

def pointin?(seg,point)
  line = seg.clone
  # Flesh out the line segment
  line[:xb] = seg[:xb] || seg[:xa]
  line[:yb] = seg[:yb] || seg[:ya]

  # Return true if the point is along that segment
  point[0].between?(*[line[:xa], line[:xb]].sort) &&
  point[1].between?(*[line[:ya], line[:yb]].sort)
end

def manhat(point)
    return 0 unless point
    point[0].abs + point[1].abs
end

def intersects(red_seg, sam_seg)
    intersections = []
    # The easiest case is when they're crosswise
    if red_seg.keys != sam_seg.keys then
        horiz, vert = red_seg.key?(:xb) ? [red_seg, sam_seg] : [sam_seg, red_seg]
        intersections << [vert[:xa], horiz[:ya]] if horiz[:ya].between?(*[vert[:ya], vert[:yb]].sort) && vert[:xa].between?(*[horiz[:xa], horiz[:xb]].sort)
    elsif red_seg.key?(:xb) && red_seg[:ya] == sam_seg[:ya] then # Both are horizontal
        intersections << [red_seg[:xa], red_seg[:ya]] if red_seg[:xa].between?(*[sam_seg[:xa], sam_seg[:xb]].sort)
        intersections << [red_seg[:xb], red_seg[:ya]] if red_seg[:xb].between?(*[sam_seg[:xa], sam_seg[:xb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:ya]] if sam_seg[:xa].between?(*[red_seg[:xa], red_seg[:xb]].sort)
        intersections << [sam_seg[:xb], sam_seg[:ya]] if sam_seg[:xb].between?(*[red_seg[:xa], red_seg[:xb]].sort)
    elsif red_seg.key?(:yb) && red_seg[:xa] == sam_seg[:xa] then # Both are vertical.
        intersections << [red_seg[:xa], red_seg[:ya]] if red_seg[:ya].between?(*[sam_seg[:ya], sam_seg[:yb]].sort)
        intersections << [red_seg[:xa], red_seg[:yb]] if red_seg[:yb].between?(*[sam_seg[:ya], sam_seg[:yb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:ya]] if sam_seg[:ya].between?(*[red_seg[:ya], red_seg[:yb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:yb]] if sam_seg[:yb].between?(*[red_seg[:ya], red_seg[:yb]].sort)
    end
    intersections
end

def get_intersections(raw_wires)
    # Parse the input file into line segments
    red = path2segments(raw_wires[0])
    sam = path2segments(raw_wires[1])

    # Loop through wire 2's line segments vs wire 1 and get the list of intersections
    intersections=[]
    red.each do |red_seg|
        sam.each do |sam_seg|
            intersections += intersects(red_seg, sam_seg)
        end
    end
    # Sort on Manhattan distance
    intersections =  intersections.sort { |a,b| manhat(a) <=> manhat(b) }.select{ |point| point != [0,0]}
end

def part1(raw_wires)
  intersections = get_intersections(raw_wires)
  manhat(intersections[0])
end

def pedometer(segments)
  total = []
  segments.each do |segment|
    total << ((segment[:yb]||segment[:ya])-segment[:ya]).abs
    total << ((segment[:xb]||segment[:xa])-segment[:xa]).abs
  end

  total.inject(:+)
end

def part2(raw_wires)
  intersections = get_intersections(raw_wires)
  stepz = []
  intersections.each do |intersection|
    stepz << pedometer(path2segments(raw_wires[0], intersection)) + pedometer(path2segments(raw_wires[1], intersection))
  end
  stepz.sort()[0]
end

puts "Part 1: #{part1(raw_wires)}"
puts "Part 2: #{part2(raw_wires)}"
