# frozen_string_literal: true
# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind_with_potential

require "nanacl/unionfind_weight"
require "nanacl/const"
require "ac-library-rb/modint"

in_n, in_q = gets.chomp.split.map(&:to_i)
AcLibraryRb::ModInt.set_mod(Nanacl::MOD)
uf =
  Nanacl::UnionFindWeight.new(in_n, default_weight: AcLibraryRb::ModInt.new(0))
in_q.times do
  query = gets.chomp.split.map(&:to_i)
  case query
  in [0, in_u, in_v, in_w]
    is_valid = false
    is_valid = true if !is_valid && !uf.same?(in_u, in_v)
    if !is_valid
      current_diff = uf.diff(in_v, in_u)
      is_valid = current_diff == AcLibraryRb::ModInt.new(in_w)
    end
    if is_valid
      uf.merge(in_v, in_u, AcLibraryRb::ModInt.new(in_w))
      puts 1
    else
      puts 0
    end
  in [1, in_u, in_v]
    if uf.same?(in_u, in_v)
      puts uf.diff(in_v, in_u)
    else
      puts -1
    end
  end
end
