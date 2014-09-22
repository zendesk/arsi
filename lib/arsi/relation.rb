module Arsi
  module Relation
    attr_accessor :without_id_check

    def initialize(*)
      super
      @without_id_check = false
    end

    def without_id_check
      @without_id_check = true
      self
    end

    def delete_all(*)
      @klass.connection.without_id_check = @without_id_check

      super
    end

    def update_all(*)
      @klass.connection.without_id_check = @without_id_check

      super
    end
  end
end