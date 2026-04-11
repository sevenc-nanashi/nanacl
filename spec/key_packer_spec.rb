# frozen_string_literal: true

require "nanacl/key_packer"

RSpec.describe "Nanacl::KeyPacker" do
  describe "#pack" do
    it "複数の値を一意な整数に詰める" do
      packer = Nanacl::KeyPacker.new(2, 3, 4)

      expect(packer.pack(0, 0, 0)).to eq(0)
      expect(packer.pack(1, 0, 0)).to eq(1)
      expect(packer.pack(0, 1, 0)).to eq(3)
      expect(packer.pack(0, 0, 1)).to eq(12)
      expect(packer.pack(2, 3, 4)).to eq(59)
    end

    it "値の個数が maxes の個数と違う場合は例外を投げる" do
      packer = Nanacl::KeyPacker.new(2, 3)

      expect { packer.pack(1) }.to raise_error(ArgumentError, "number of values must match number of maxes")
      expect { packer.pack(1, 2, 3) }.to raise_error(ArgumentError, "number of values must match number of maxes")
    end

    it "値が範囲外の場合は例外を投げる" do
      packer = Nanacl::KeyPacker.new(2, 3)

      expect { packer.pack(-1, 0) }.to raise_error(ArgumentError, "value -1 exceeds max 2")
      expect { packer.pack(0, 4) }.to raise_error(ArgumentError, "value 4 exceeds max 3")
    end
  end

  describe "#unpack" do
    it "詰めた値を元の値に戻す" do
      packer = Nanacl::KeyPacker.new(2, 3, 4)

      (0..2).each do |a|
        (0..3).each do |b|
          (0..4).each do |c|
            values = [a, b, c]

            expect(packer.unpack(packer.pack(*values))).to eq(values)
          end
        end
      end
    end
  end
end
