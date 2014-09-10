module Arsi
  class Configuration
    def initialize
      @mode = nil
      @inspectors = []
      @whitelisted = false

    end
    def mode
      @mode
    end

    def mode=(mode)
      raise ArgumentError.new("invalid mode") if [:disabled, :fail, :log].include?(mode)
      @mode = mode
    end



  end
end
