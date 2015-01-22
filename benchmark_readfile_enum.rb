require 'benchmark'
require 'benchmark/ips'

class EnumTest
  FILENAME = "user_group.txt"

  def self.test_without_enum(n)
    File.open(FILENAME) do |f|
      file_lines = f.readlines

      file_lines.select do |line|
        EnumTest.even_id?(line)
      end.take(n)
    end
  end

  def self.test_with_enum(n)
    File.open(FILENAME) do |f|
      file_enum = f.each_line

      Enumerator.new do |yielder|
        file_enum.each do |line|
          yielder.yield(line) if EnumTest.even_id?(line)
        end
      end.take(n)
    end
  end

  def self.test_with_lazy(n)
    File.open(FILENAME) do |f|
      file_enum = f.each_line

      file_enum.lazy.select do |line|
        EnumTest.even_id?(line)
      end.take(n).to_a
    end
  end

  def self.even_id?(line)
    line.split(/\t/).first.to_i.even?
  end
end

Benchmark.ips do |b|
  puts EnumTest.test_without_enum(5)
  puts EnumTest.test_with_enum(5)
  puts EnumTest.test_with_lazy(5)

  [5, 50, 500].each do |num|
    b.report("taking #{num} elements from the file without using Enumerator") do
      EnumTest.test_without_enum(num)
    end

    b.report("taking #{num} elements from the file with using Enumerator") do
      EnumTest.test_with_enum(num)
    end

    b.report("taking #{num} elements from the file with using lazy") do
      EnumTest.test_with_lazy(num)
    end
  end
end
