require 'ruby_markovify/chain'
require 'ruby_markovify/splitters'
require 'unidecode'

module RubyMarkovify
  class Text

    def initialize(input_text, state_size = nil, chain = nil)
      runs = generate_corpus(input_text)
      @rejoined_text = sentence_join(runs.map { |e| word_join(e) })
      state_size ||= 2
      @chain = chain || Chain.new(runs, state_size)
    end

    include RubyMarkovify::Splitters
    def sentence_split(text)
      split_into_sentences(text)
    end

    def sentence_join(sentences)
      sentences.join ' '
    end

    WORD_SPLIT_PATTERN = /\s+/
    def word_split(sentence)
      sentence.split(WORD_SPLIT_PATTERN)
    end

    def word_join(words)
      words.join ' '
    end

    REJECT_PATTERN = /(^')|('$)|\s'|'\s|["(\(\)\[\])]/

    def test_sentence_input(sentence)
      !!(sentence.to_ascii =~ REJECT_PATTERN)
    end

    def generate_corpus(text)
      sentences = sentence_split text
      sentences.reject! { |e| test_sentence_input(e) }
      sentences.map { |e| word_split(e) }
    end

    def test_sentence_output(words, max_overlap_ratio, max_overlap_total)
      overlap_ratio = (max_overlap_ratio * words.length).round
      overlap_max = [max_overlap_total, overlap_ratio].min
      overlap_over = overlap_max + 1
      gram_count = [words.length - overlap_max, 1].max

      grams = [*0..gram_count].map { |i| words[i..i+overlap_over] }
      grams.each do |g|
        gram_joined = word_join(g)
        return false if @rejoined_text.include? gram_joined
      end

      true
    end

    DEFAULT_MAX_OVERLAP_RATIO = 0.7
    DEFAULT_MAX_OVERLAP_TOTAL = 15
    DEFAULT_TRIES = 10

    def make_sentence(init_state = nil, options = {})
      tries = options[:tries] || DEFAULT_TRIES
      mor = options[:max_overlap_ratio] || DEFAULT_MAX_OVERLAP_RATIO
      mot = options[:max_overlap_total] || DEFAULT_MAX_OVERLAP_TOTAL

      tries.times do
        words = @chain.walk(init_state)
        return word_join(words) if test_sentence_output(words, mor, mot)
      end
      nil
    end

    def make_short_sentence(char_limit, options = {})
      loop do
        sentence = make_sentence(nil, options)
        return sentence if sentence && sentence.length < char_limit
      end
    end

    def make_sentence_with_start(beginning, options = {})
      make_sentence(word_split(beginning), options)
    end
  end
end
