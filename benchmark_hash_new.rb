require 'benchmark'
require 'benchmark/ips'

class HashTest
  TEST_TEXT = "Just a reasonable sentence here. A quick brown fox jumped over the lazy dog.\n\n"

  def self.test_without_new(n)
    count_hash = {}
    test_chars = TEST_TEXT.chars*n

    test_chars.each{|char| count_hash[char] ||= 0; count_hash[char] += 1 }
  end

  def self.test_with_new(n)
    count_hash = Hash.new{|h, k| h[k] = 0}
    test_chars = TEST_TEXT.chars*n

    test_chars.each{|char| count_hash[char] += 1 }
  end
end

Benchmark.ips do |b|
  [5, 50, 500].each do |num|
    b.report("without 'new' for #{num} text blocks") do
      HashTest.test_without_new(num)
    end

    b.report("with 'new' for #{num} text blocks") do
      HashTest.test_with_new(num)
    end
  end
end
