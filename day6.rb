#!/usr/bin/env ruby
require 'pp'

def build_treee(input)
  treee = {}
  input.each do |tuple|
    tuple.each { |name| treee[name] = {parent:nil, name: name} unless treee.key? name }
    parent, node = tuple
    treee[node][:parent] = treee[parent]
  end
  treee
end


def part1(treee)
  total = 0
  # For each node in the tree, count how many parents it has.
  treee.keys.each do |key|
    node = treee[key]
    while (node = node[:parent]) do
      total += 1
    end
  end
  total
end

def path_home(node)
  path = [node[:name]]
  while (node = node[:parent]) do
    path << node[:name]
  end
  path
end

def part2(treee)
  # Get the path between YOU and SAN to COM
  fromu = path_home(treee['YOU']).reverse
  froms = path_home(treee['SAN']).reverse

  # Go through the paths and drop the identicle leading junk
  while fromu[0] == froms[0] do
    fromu.shift
    froms.shift
  end
  fromu.length + froms.length - 2
end

# Read in the input file, split into [orbitee, orbiter], then build that into a tree.
treee = build_treee(ARGF.readlines.map { |tuple| tuple.chomp.split(')') } )

pp part1(treee)
pp part2(treee)
