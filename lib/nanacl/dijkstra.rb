# frozen_string_literal: true

require_relative "const"
require "ac-library-rb/priority_queue"

module Nanacl
  module_function

  def dijkstra(graph, start, allow_separated: false)
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
      graph[current].each do |neighbor, distance|
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

  def dijkstra_path(graph, start, allow_separated: false)
    # @type var result: Hash[Integer, [Integer, Array[Integer]]?]
    result = graph.keys.each_with_object({}) { |node, hash| hash[node] = nil }

    queue = AcLibraryRb::PriorityQueue.new { |a, b| a[1] < b[1] }
    result[start] = [0, []]
    queue.push([start, [0, []]])

    # @type var seen: Hash[Integer, TrueClass]
    seen = {}

    while (current, = queue.pop)
      next if seen[current]
      seen[current] = true
      graph[current].each do |neighbor, distance|
        current_distance, current_path = result[current] || [BIG, []]
        alt = current_distance + distance
        if result[neighbor].nil? || alt < result[neighbor][0]
          result[neighbor] = [alt, current_path + [neighbor]]
          queue << [neighbor, alt]
        end
      end
    end

    if seen.length < graph.length && !allow_separated
      raise DisconnectedGraphError, "Graph is not connected"
    end

    result
  end

  class DisconnectedGraphError < ArgumentError
  end
end
