module RubyMarkovify
  def self.cumulative_sum(array)
    sum = 0
    array.map { |x| sum += x }
  end

  class Chain
    def initialize(corpus, state_size, model = nil)
      @state_size = state_size
      @model = model || build(corpus, @state_size)
    end

    def build(corpus, state_size)
      fail ArgumentError, '`corpus` must be an Array of Arrays!' unless corpus.is_a?(Array) && corpus[0].is_a?(Array)

      model = {}

      corpus.each do |run|
        items = [:begin] * state_size + run + [:end]

        0.upto(run.length + 1) do |i|
          state = items[i...i+state_size]
          follow = items[i+state_size]

          model[state] ||= {}
          model[state][follow] ||= 0
          model[state][follow] += 1
        end
      end

      model
    end

    def move(state)
      choices, weights = @model[state].keys, @model[state].values
      cumdist = RubyMarkovify.cumulative_sum(weights)
      r = rand * cumdist[-1]
      choices[cumdist.index { |e| e >= r }]
    end

    def gen(init_state = nil)
      state = init_state || [:begin] * @state_size
      result = []
      loop do
        next_word = move(state)
        break if next_word == :end
        result << next_word
        state = state[1..-1] + [next_word]
      end
      result
    end

    # As Ruby doesn't have the concept of generators, #gen returns an array itself,
    # so we don't need to make a separate method for walk
    alias_method :walk, :gen
  end
end