require "nanacl/dijkstra"

RSpec.describe "Nanacl.dijkstra" do
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

    result = Nanacl.dijkstra(graph, 1)
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

    result = Nanacl.dijkstra(graph, 1, allow_separated: true)
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

    expect { Nanacl.dijkstra(graph, 1, allow_separated: false) }.to raise_error(
      Nanacl::DisconnectedGraphError
    )
  end
end

RSpec.describe "Nanacl.dijkstra_path" do
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

    result = Nanacl.dijkstra_path(graph, 1)
    expect(result).to eq({ 1 => [0, []], 2 => [1, [2]], 3 => [3, [2, 3]], 4 => [4, [2, 3, 4]] })
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

    result = Nanacl.dijkstra_path(graph, 1, allow_separated: true)
    expect(result).to eq({ 1 => [0, []], 2 => [1, [2]], 3 => [3, [2, 3]], 4 => [4, [2, 3, 4]], 5 => nil })
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

    expect { Nanacl.dijkstra_path(graph, 1, allow_separated: false) }.to raise_error(
      Nanacl::DisconnectedGraphError
    )
  end
end
