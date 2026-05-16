# frozen_string_literal: true

require "ac-library-rb/modint"

AcLibraryRb::ModInt.set_mod(998_244_353)

require "nanacl/factorial"

RSpec.describe "Nanacl::Factorial" do
  describe ".n_permute_k" do
    it "returns permutation count as modint" do
      expect(Nanacl::Factorial.n_permute_k(5, 3).val).to eq(60)
    end

    it "raises error with invalid k" do
      expect { Nanacl::Factorial.n_permute_k(5, -1) }.to raise_error(ArgumentError)
      expect { Nanacl::Factorial.n_permute_k(5, 6) }.to raise_error(ArgumentError)
    end
  end

  describe ".n_choose_k" do
    it "returns combination count as modint" do
      expect(Nanacl::Factorial.n_choose_k(5, 3).val).to eq(10)
    end

    it "raises error with invalid k" do
      expect { Nanacl::Factorial.n_choose_k(5, -1) }.to raise_error(ArgumentError)
      expect { Nanacl::Factorial.n_choose_k(5, 6) }.to raise_error(ArgumentError)
    end
  end

  describe ".n_multichoose_k" do
    it "returns nHk as modint" do
      expect(Nanacl::Factorial.n_multichoose_k(3, 4).val).to eq(15)
    end

    it "raises error with invalid arguments" do
      expect { Nanacl::Factorial.n_multichoose_k(0, 1) }.to raise_error(ArgumentError)
      expect { Nanacl::Factorial.n_multichoose_k(3, -1) }.to raise_error(ArgumentError)
    end
  end

  describe ".n_multichoose_k_at_least_one" do
    it "returns count with at least one of each kind as modint" do
      expect(Nanacl::Factorial.n_multichoose_k_at_least_one(3, 4).val).to eq(3)
    end

    it "returns zero when k is less than n" do
      expect(Nanacl::Factorial.n_multichoose_k_at_least_one(3, 2).val).to eq(0)
    end

    it "raises error with invalid arguments" do
      expect { Nanacl::Factorial.n_multichoose_k_at_least_one(0, 1) }.to raise_error(ArgumentError)
      expect { Nanacl::Factorial.n_multichoose_k_at_least_one(3, -1) }.to raise_error(ArgumentError)
    end
  end

  describe "Integer#factorial" do
    it "returns factorial as modint" do
      expect(5.factorial.val).to eq(120)
    end

    it "uses modint" do
      naive = 1
      (1..1000).each { |i| naive = (naive * i) % 998_244_353 }
      expect(1000.factorial.val).to eq(naive)
    end

    it "raises error with negative integer" do
      expect { -1.factorial }.to raise_error(ArgumentError)
    end
  end

  describe "AcLibraryRb::ModInt#factorial" do
    it "returns factorial of its value as modint" do
      expect(5.to_modint.factorial.val).to eq(120)
    end
  end
end
