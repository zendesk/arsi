module Arsi
  module Mysql2Adapter
    attr_accessor :without_id_check

    def delete(arel, *)
      if arel.respond_to?(:ast) && !@without_id_check && arel.failed_id_check?
        raise "You must always specify an *id in the WHERE clause of DELETE\n\t#{to_sql(arel, []).inspect}"
      end

      super
    end

    def update(arel, *)
      if arel.respond_to?(:ast) && !@without_id_check && arel.failed_id_check?
        raise "You must always specify an *id in the WHERE clause of UPDATE\n\t#{to_sql(arel, []).inspect}"
      end

      super
    end
  end
end
