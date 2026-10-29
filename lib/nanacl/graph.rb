# frozen_string_literal: true

module Nanacl
  class Graph < Hash
    def add_edge(from, to, weight = 1)
      self[from] = [] unless key?(from)
      self[from] << [to, weight]
    end

    def add_dual_edge(from, to, weight = 1)
      add_edge(from, to, weight)
      add_edge(to, from, weight)
    end

    def [](key)
      super || []
    end
  end

  class MinGraph < Hash
    def add_edge(from, to, weight = 1)
      self[from] = {} unless key?(from)
      return unless !self[from][to] || weight < self[from][to]
      self[from][to] = weight
    end

    def add_dual_edge(from, to, weight = 1)
      add_edge(from, to, weight)
      add_edge(to, from, weight)
    end

    def [](key)
      super || {}
    end
  end
end
