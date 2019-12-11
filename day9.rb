#!/usr/bin/env ruby
require './intcode'

vm = Intcode.new(Intcode.file2mem(ARGF))

vm.run
