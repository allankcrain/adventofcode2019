#!/usr/bin/env ruby
# Load the input file
raw_wires = ARGF.readlines

require 'pp'
def path2segments(raw_wire)
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
        segments << segment.clone
    end
    segments
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
    # Goddammit. Potential overlaps. Fuck. Shit. Fuck.
    elsif red_seg.key?(:xb) && red_seg[:ya] == sam_seg[:ya] then # Both are horizontal
        p "Potential overlap"
        pp red_seg, sam_seg
        intersections << [red_seg[:xa], red_seg[:ya]] if red_seg[:xa].between?(*[sam_seg[:xa], sam_seg[:xb]].sort)
        intersections << [red_seg[:xb], red_seg[:ya]] if red_seg[:xb].between?(*[sam_seg[:xa], sam_seg[:xb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:ya]] if sam_seg[:xa].between?(*[red_seg[:xa], red_seg[:xb]].sort)
        intersections << [sam_seg[:xb], sam_seg[:ya]] if sam_seg[:xb].between?(*[red_seg[:xa], red_seg[:xb]].sort)
    elsif red_seg.key?(:yb) && red_seg[:xa] == sam_seg[:xa] then # Both are vertical.
        p "Portential hoverclap"
        pp red_seg, sam_seg
        intersections << [red_seg[:xa], red_seg[:ya]] if red_seg[:ya].between?(*[sam_seg[:ya], sam_seg[:yb]].sort)
        intersections << [red_seg[:xa], red_seg[:yb]] if red_seg[:yb].between?(*[sam_seg[:ya], sam_seg[:yb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:ya]] if sam_seg[:ya].between?(*[red_seg[:ya], red_seg[:yb]].sort)
        intersections << [sam_seg[:xa], sam_seg[:yb]] if sam_seg[:yb].between?(*[red_seg[:ya], red_seg[:yb]].sort)
    end
    intersections
end

def part1(raw_wires)
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

    # Get the smallest MD. Skip 0000.
    pp intersections
    manhat(intersections[0])
end

p "Part 1: #{part1(raw_wires)}"
