# frozen_string_literal: true
require "nanacl/graph"
require "nanacl/dijkstra"

RSpec.describe "graph" do
  describe Nanacl::Graph do
    subject(:graph) { described_class.new }

    it "returns empty edges for an unknown vertex without inserting it" do
      expect(graph[:missing]).to eq([])
      expect(graph).to be_empty
    end

    it "adds a directed edge with a default weight of one" do
      graph.add_edge(:a, :b)

      expect(graph[:a]).to eq([[:b, 1]])
      expect(graph[:b]).to eq([])
    end

    it "preserves parallel edges and their insertion order" do
      graph.add_edge(:a, :b, 5)
      graph.add_edge(:a, :c, 0)
      graph.add_edge(:a, :b, -2)

      expect(graph[:a]).to eq([[:b, 5], [:c, 0], [:b, -2]])
    end

    it "adds edges in both directions with the default weight" do
      graph.add_dual_edge(:a, :b)

      expect(graph[:a]).to eq([[:b, 1]])
      expect(graph[:b]).to eq([[:a, 1]])
    end

    it "adds edges in both directions with the specified weight" do
      graph.add_dual_edge(:a, :b, 3)

      expect(graph[:a]).to eq([[:b, 3]])
      expect(graph[:b]).to eq([[:a, 3]])
    end

    it "allows self loops" do
      graph.add_edge(:a, :a, 2)

      expect(graph[:a]).to eq([[:a, 2]])
    end

    it "can be used for dijkstra" do
      graph.add_edge(:a, :b, 5)
      graph.add_edge(:a, :c, 0)
      graph.add_edge(:a, :b, -2)
      graph.add_edge(:b, :d, 1)
      graph.add_edge(:c, :d, 2)

      expect(Nanacl.dijkstra_all(graph, :a)).to eq({ a: 0, b: -2, c: 0, d: -1 })
    end
  end

  describe Nanacl::MinGraph do
    subject(:graph) { described_class.new }

    it "returns empty edges for an unknown vertex without inserting it" do
      expect(graph[:missing]).to eq({})
      expect(graph).to be_empty
    end

    it "adds a directed edge with a default weight of one" do
      graph.add_edge(:a, :b)

      expect(graph[:a]).to eq({ b: 1 })
      expect(graph[:b]).to eq({})
    end

    it "keeps the minimum weight for each destination" do
      graph.add_edge(:a, :b, 5)
      graph.add_edge(:a, :c, 4)
      graph.add_edge(:a, :b, 0)
      graph.add_edge(:a, :b, 3)
      graph.add_edge(:a, :b, 0)

      expect(graph[:a]).to eq({ b: 0, c: 4 })

      graph.add_edge(:a, :b, -2)
      expect(graph[:a]).to eq({ b: -2, c: 4 })
    end

    it "adds edges in both directions with the default weight" do
      graph.add_dual_edge(:a, :b)

      expect(graph[:a]).to eq({ b: 1 })
      expect(graph[:b]).to eq({ a: 1 })
    end

    it "minimizes each direction independently when adding dual edges" do
      graph.add_edge(:a, :b, 2)
      graph.add_edge(:b, :a, 5)
      graph.add_dual_edge(:a, :b, 3)

      expect(graph[:a]).to eq({ b: 2 })
      expect(graph[:b]).to eq({ a: 3 })
    end

    it "allows self loops" do
      graph.add_edge(:a, :a, 2)

      expect(graph[:a]).to eq({ a: 2 })
    end

    it "can be used for dijkstra" do
      graph.add_edge(:a, :b, 5)
      graph.add_edge(:a, :c, 0)
      graph.add_edge(:a, :b, -2)
      graph.add_edge(:b, :d, 1)
      graph.add_edge(:c, :d, 2)

      expect(Nanacl.dijkstra_all(graph, :a)).to eq({ a: 0, b: -2, c: 0, d: -1 })
    end
  end
end
