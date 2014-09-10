# TODO:
#   make matches case & whitepsace insensitive
#   should we inherit from a base inspector class
#   how about an inspector that can inspect the arel AST?

module Arsi
  class InverseBasicInspector < BasicInspector
    def initialize(string_or_regex = nil, &proc)
      super(string_or_regex, &proc)
    end

    def check?(sql)
      !super(sql)
    end
end
