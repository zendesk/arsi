module Arsi
  module Mysql2Adapter
    attr_accessor :arsi_relation

    def delete(arel, *)
      Arsi.arel_check!(arel, arsi_relation)
      super
    end

    def update(arel, *)
      Arsi.arel_check!(arel, arsi_relation)
      super
    end
  end
end
