# frozen_string_literal: true
require "ac-library-rb/dsu"

dsu = AcLibraryRb::DSU.new(10)
dsu.merge(1, 2)

puts "Union of 1 and 2: #{dsu.find(1)}"
puts "dsu.same?(1, 2): #{dsu.same?(1, 2)}"
puts "dsu.same?(1, 3): #{dsu.same?(1, 3)}"
