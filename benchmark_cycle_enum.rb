require 'benchmark'
require 'benchmark/ips'

class EnumTest
  TEST_TEXT = "Just a reasonable sentence here. A quick brown fox jumped over the lazy dog.\n\n"

  def self.test_without_enum(n)
    TEST_TEXT.split('')*n
  end

  def self.test_with_enum(n)
    test_array = TEST_TEXT.split('')
    test_array.cycle(n)
  end
end

Benchmark.ips do |b|
  [5, 50, 500].each do |num|
    b.report("taking #{num} elements without using the enumerator for #{num**2} cycles") do
      EnumTest.test_without_enum(num**2).take(num)
    end

    b.report("taking #{num} elements with using the enumerator for #{num**2} cycles") do
      EnumTest.test_with_enum(num**2).take(num)
    end
  end

  [1000, 3000, 5000].each do |num|
    b.report("taking #{num} elements with using the enumerator for #{num**2} cycles") do
      EnumTest.test_with_enum(num**2).take(num)
    end
  end
end
