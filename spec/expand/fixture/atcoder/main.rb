require "ac-library-rb/dsu"

dsu = AcLibraryRb::DSU.new(10)
dsu.merge(1, 2)

puts "Union of 1 and 2: #{dsu.find(1)}"
