module Arsi
  class ArelNode

    def self.reject(inspector)
      new InverseBasicInspector(inspector)
    end

    def self.require(inspector)
      new BasicInspector(inspector)
    end

  end

end