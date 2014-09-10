# TODO:
#   make matches case & whitepsace insensitive
#   should we inherit from a base inspector class
#   how about an inspector that can inspect the arel AST?

module Arsi
  class BasicInspector
    def initialize(string_or_regex = nil, &proc)
      #TODO: Should we convert the regex to a proc here? Will simplify the code but overhead?
      if string_or_regex
        @regex = normalize_string(string_or_regex)
      elsif block
        @proc = block
      else
        raise ArgumentError.new("must initialize with a string, regex, or block")
      end
    end

    def check?(sql)
      !!(@proc ? @proc.call(sql) : @regex.match(sql))
    end

    private

    def normalize_string(string_or_regexp)
      if string_or_regexp.is_a?(Regexp)
        string_or_regexp
      else
        Regexp.new(Regexp.escape(string_or_regexp), Regexp::IGNORECASE)
      end
    end

  end
end
