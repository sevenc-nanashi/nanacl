# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
#
require "nanacl/dijkstra"

in_n, in_m, in_s, in_t = gets.chomp.split.map(&:to_i)
in_abc = in_m.times.map { gets.split.map(&:to_i) }

graph = {}

in_abc.each do |a, b, c|
  graph[a] ||= {}
  graph[a][b] = c
end

path = Nanacl.dijkstra_path(graph, in_s, in_t, allow_separated: true)
if path
  cost, route = path
  puts "#{cost} #{route.size - 1}"
  route.each_cons(2).each { |u, v| puts "#{u} #{v}" }
else
  puts -1
end
