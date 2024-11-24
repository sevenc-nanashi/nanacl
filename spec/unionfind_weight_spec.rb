# frozen_string_literal: true
require "nanacl/unionfind_weight"

RSpec.describe "Nanacl::UnionFindWeight" do
  # https://atcoder.jp/contests/abc373/tasks/abc373_d
  it "works on ABC373 - D's first example" do
    ufw = Nanacl::UnionFindWeight.new(5)

    ufw.merge(0, 1, 2)
    ufw.merge(1, 2, 3)
    ufw.merge(1, 3, -1)

    expect(ufw.weight(0)).to eq(0)
    expect(ufw.weight(1)).to eq(2)
    expect(ufw.weight(2)).to eq(5)
  end

  it "works on ABC373 - D's second example" do
    ufw = Nanacl::UnionFindWeight.new(5)

    ufw.merge(1, 0, 5)
    ufw.merge(2, 3, -3)

    expect(ufw.weight(0)).to eq(5)
    expect(ufw.weight(1)).to eq(0)
    expect(ufw.weight(2)).to eq(0)
    expect(ufw.weight(3)).to eq(-3)
  end

  it "works on handmade example" do
    ufw = Nanacl::UnionFindWeight.new(4)

    ufw.merge(0, 1, 2)
    ufw.merge(2, 3, 2)
    ufw.merge(1, 2, 3)

    expect(ufw.weight(0)).to eq(0)
    expect(ufw.weight(1)).to eq(2)
    expect(ufw.weight(2)).to eq(5)
    expect(ufw.weight(3)).to eq(7)
  end
end
