module RubyMarkovify
  module Splitters
    ASCII_LOWERCASE = 'abcdefghijklmnopqrstuvwxyz'
    ASCII_UPPERCASE = ASCII_LOWERCASE.upcase

    # States w/ with thanks to https://github.com/unitedstates/python-us
    # Titles w/ thanks to https://github.com/nytimes/emphasis and @donohoe
    STATES = %w{
      ala ariz ark calif colo conn del fla ga ill ind kan ky la md mass mich minn miss mo mont neb nev okla
      ore pa tenn vt va wash wis wyo
    }
    UNITED_STATES = %w{u.s}
    TITLES = %w{mr ms mrs msr dr gov pres sen sens rep reps prof gen messrs col sr jf sgt mgr fr rev jr snr atty supt}
    STREETS = %w{ave blvd st rd hwy}
    MONTHS = %w{jan feb mar apr jun jul aug sep sept oct nov dec}
    INITIALS = ASCII_LOWERCASE.chars

    ABBR_CAPPED = STATES + UNITED_STATES + TITLES + STREETS + MONTHS + INITIALS
    ABBR_LOWERCASE = %w{etc v vs viz al pct}
    EXCEPTIONS = %w{U.S. U.N. E.U. F.B.I. C.I.A.}

    PUNCTUATION = %w{? !}

    def is_abbreviation(dotted_word)
      clipped = dotted_word[0..-2]
      if ASCII_UPPERCASE.include? clipped[0]
        ABBR_CAPPED.include? clipped.downcase
      else
        ABBR_LOWERCASE.include? clipped
      end
    end

    def is_sentence_ender(word)
      return false if EXCEPTIONS.include? word
      return true if PUNCTUATION.include? word[-1]
      return true if word.sub(/[^A-Z]/, '').length > 1
      return true if word[-1] == '.' && !is_abbreviation(word)
      false
    end

    # A word that ends with punctuation
    # Followed by optional quote/parens/etc
    # Followed by whitespace + non-(lowercase or dash)
    END_PATTERN = /([\w\.'’&\]\)]+[\.\?!])([‘’“”'\"\)\]]*)(\s+(?![a-z\-–—]))/

    def split_into_sentences(text)
      res = []
      text.scan(END_PATTERN) do |c|
        res << [c, $~.offset(0)[0]]
      end

      end_indices = res.select do |e|
        groups, _ = e
        is_sentence_ender(groups[0])
      end.map do |e|
        groups, index = e
        index + groups[0].length + groups[1].length
      end

      spans = [[nil] + end_indices].zip(end_indices + [nil])

      spans.map do |elem|
        start_idx, end_idx = elem
        text[start_idx..end_idx].strip
      end
    end
  end
end