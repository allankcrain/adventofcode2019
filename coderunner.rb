#!/usr/bin/env ruby

require './intcode'

memcore = Intcode.file2mem(ARGF)

vm = Intcode.new(memcore, true)
vm.run
