# frozen_string_literal: true
# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum

require "nanacl/array_sum"

in_n, in_q = gets.chomp.split.map(&:to_i)
in_a = gets.chomp.split.map(&:to_i)
in_q.times do
  q_l, q_r = gets.chomp.split.map(&:to_i)
  puts in_a.sum_in_range(q_l...q_r)
end
