# frozen_string_literal: true

require_relative "const"
require "ac-library-rb/priority_queue"

module Nanacl
  module_function

  def dijkstra(graph, start, to, allow_separated: false)
    # @type var result: Hash[Integer, Integer]
    result = graph.keys.each_with_object({}) { |node, hash| hash[node] = nil }

    queue = AcLibraryRb::PriorityQueue.new { |a, b| a[1] < b[1] }
    result[start] = 0
    queue.push([start, 0])

    # @type var seen: Hash[Integer, TrueClass]
    seen = {}

    while (current, = queue.pop)
      next if seen[current]
      seen[current] = true
      break if current == to

      graph[current]&.each do |neighbor, distance|
        alt = (result[current] or raise "Unreachable") + distance
        if result[neighbor].nil? || alt < result[neighbor]
          result[neighbor] = allow_separated ? alt : [alt, current]
          queue << [neighbor, alt]
        end
      end
    end

    if result[to].nil? && !allow_separated
      raise DisconnectedGraphError, "Graph is not connected"
    end

    result[to]
  end

  def dijkstra_all(graph, start, allow_separated: false)
    # @type var result: Hash[Integer, Integer]
    result = graph.keys.each_with_object({}) { |node, hash| hash[node] = nil }

    queue = AcLibraryRb::PriorityQueue.new { |a, b| a[1] < b[1] }
    result[start] = 0
    queue.push([start, 0])

    # @type var seen: Hash[Integer, TrueClass]
    seen = {}

    while (current, = queue.pop)
      next if seen[current]
      seen[current] = true
      graph[current]&.each do |neighbor, distance|
        alt = (result[current] or raise "Unreachable") + distance
        if result[neighbor].nil? || alt < result[neighbor]
          result[neighbor] = alt
          queue << [neighbor, alt]
        end
      end
    end

    if seen.length < graph.length && !allow_separated
      raise DisconnectedGraphError, "Graph is not connected"
    end

    result
  end

  def dijkstra_path(graph, start, to, allow_separated: false)
    # @type var result: Hash[Integer, [Integer, Integer]]
    result = graph.keys.each_with_object({}) { |node, hash| hash[node] = nil }

    queue = AcLibraryRb::PriorityQueue.new { |a, b| a[2] < b[2] }
    result[start] = [0, -1]
    queue.push([start, [0, -1, 0]])
    # @type var previous_vertex: Hash[Integer, Integer]
    previous_vertex = {}

    # @type var seen: Hash[Integer, TrueClass]
    seen = {}

    while (current, previous = queue.pop)
      next if seen[current]
      seen[current] = true
      previous_vertex[current] = previous
      break if current == to
      graph[current]&.each do |neighbor, distance|
        current_distance,  = result[current] || [BIG, -1]
        alt_distance = current_distance + distance
        if result[neighbor].nil? || alt_distance < result[neighbor][0]
          result[neighbor] = [alt_distance, current]
          queue << [neighbor, current, alt_distance]
        end
      end
    end

    if result[to].nil? && !allow_separated
      raise DisconnectedGraphError, "Graph is not connected"
    end

    return nil if result[to].nil?

    cost, previous = result[to]
    route = [to]
    while previous != -1
      route << previous
      previous = result[previous][1]
    end

    [cost, route.reverse]
  end

  class DisconnectedGraphError < ArgumentError
  end
end
