# frozen_string_literal: true
require "nanacl/dijkstra"

RSpec.describe "dijkstra" do
  describe "Nanacl.dijkstra_all" do
    it "works with connected graph" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        }
      }

      result = Nanacl.dijkstra_all(graph, 1)
      expect(result).to eq({ 1 => 0, 2 => 1, 3 => 3, 4 => 4 })
    end

    it "works with disconnected graph" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        },
        5 => {
        }
      }

      result = Nanacl.dijkstra_all(graph, 1, allow_separated: true)
      expect(result).to eq({ 1 => 0, 2 => 1, 3 => 3, 4 => 4, 5 => nil })
    end

    it "raises error when graph is not connected" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        },
        5 => {
        }
      }

      expect do
        Nanacl.dijkstra_all(graph, 1, allow_separated: false)
      end.to raise_error(Nanacl::DisconnectedGraphError)
    end
  end

  describe "Nanacl.dijkstra_path" do
    it "works with connected graph" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        }
      }

      cost, route = Nanacl.dijkstra_path(graph, 1, 4)
      expect(cost).to eq(4)
      expect(route).to eq([1, 2, 3, 4])
    end

    it "works with disconnected graph" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        },
        5 => {
        }
      }

      cost, route = Nanacl.dijkstra_path(graph, 1, 4, allow_separated: true)
      expect(cost).to eq(4)
      expect(route).to eq([1, 2, 3, 4])

      expect(Nanacl.dijkstra_path(graph, 1, 5, allow_separated: true)).to be_nil
    end

    it "raises error when graph is not connected" do
      graph = {
        1 => {
          2 => 1,
          3 => 4
        },
        2 => {
          3 => 2,
          4 => 5
        },
        3 => {
          4 => 1
        },
        4 => {
        },
        5 => {
        }
      }

      expect do
        Nanacl.dijkstra_path(graph, 1, 5, allow_separated: false)
      end.to raise_error(Nanacl::DisconnectedGraphError)
    end
  end
end
