require "nanacl/unionfind_map"

RSpec.describe "Nanacl::UnionFindMap" do
  it "works" do
    ufm = Nanacl::UnionFindMap.new(5, values: [1, 2, 3, 4, 5]) { |a, b| a + b }

    ufm.merge(0, 1)
    ufm.merge(1, 2)

    expect(ufm[0]).to eq(6)
    expect(ufm[1]).to eq(6)
    expect(ufm[2]).to eq(6)

    ufm.merge(3, 4)
    expect(ufm[3]).to eq(9)
    expect(ufm[4]).to eq(9)
    ufm[3] = 10
    expect(ufm[3]).to eq(10)
    expect(ufm[4]).to eq(10)
  end
end
