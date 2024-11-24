# frozen_string_literal: true
# verification-helper: PROBLEM https://atcoder.jp/contests/abc215/tasks/abc215_b

require "nanacl/logi"
in_n = gets.chomp.to_i

puts Nanacl.logi(in_n, 2)
