require 'benchmark'
require 'benchmark/ips'

TEXT_BLOCK = "Just a reasonable sentence here. A quick brown fox jumped over the lazy dog.\n\n"

LEXICON = {
  "reasonable" => "mediocre",
  "quick"      => "swift",
  "brown"      => "ochre",
  "lazy"       => "lackadaisical",
  "Just"       => "Once again,",
  "A"          => "Multitudes"
}

PATTERN = Regexp.new(LEXICON.keys.join("|"))


class GsubTest
  def self.test_with_each(text_block)
    sanitized = text_block
    LEXICON.each do |term, replacement|
      sanitized.gsub!(term, replacement)
    end
    sanitized
  end

  private
  def self.test_with_block(text_block)
    text_block.gsub(PATTERN) {|match| LEXICON[match] }
  end

  def self.test_with_passing_hash(text_block)
    text_block.gsub(PATTERN, LEXICON)
  end
end

Benchmark.ips do |b|
  [10, 30, 50, 100].each do |num|
    text_block = TEXT_BLOCK*num

    %i(test_with_each test_with_block test_with_passing_hash).each do |method_name|
      b.report("With #{num} lines in the text block:\n\tuse gsub with '#{method_name}'") do
        GsubTest.send(method_name, text_block)
        GsubTest.test_with_passing_hash(text_block)
      end
    end
  end
end
