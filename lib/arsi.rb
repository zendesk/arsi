require 'arsi/arel_tree_manager'
require 'arsi/mysql2_adapter'
require 'arsi/relation'
require 'active_record'
require 'active_record/connection_adapters/mysql2_adapter'

module Arsi
  class UnscopedSQL < StandardError; end
  Arel::UpdateManager.include(ArelTreeManager)
  Arel::DeleteManager.include(ArelTreeManager)
  ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(Mysql2Adapter)
  ActiveRecord::Relation.prepend(Relation)
  ActiveRecord::Querying.delegate(:without_arsi, :to => :relation)

  @enabled = true

  ID_MATCH = "(gu|uu|u)?id"
  SCOPEABLE_REGEX = /(^|_)#{ID_MATCH}$/i               # http://rubular.com/r/hPVpG9jyoC
  SQL_MATCHER = /[\s_`(]#{ID_MATCH}`?\s+(=|<>|IN|IS)/i # http://rubular.com/r/7xuhnBiOgs
  DEFAULT_CALLBACK = lambda do |sql, relation|
    raise UnscopedSQL, "Missing ID in the where sql:\n#{sql}\nAdd id or use without_arsi"
  end

  class << self
    attr_reader :enabled
    attr_accessor :violation_callback

    def arel_check!(arel, relation)
      return unless @enabled
      return if relation && relation.without_arsi?

      # ::Arel::TreeManager, String, nil or ... ?
      sql = arel.respond_to?(:where_sql) ? arel_where_sql(arel, relation) : arel.to_s
      sql_check!(sql, relation)
    end

    def disable!
      @enabled = false
    end

    def enable!
      @enabled = true
    end

    def disable(&block)
      run_with_arsi(false, &block)
    end

    def enable(&block)
      run_with_arsi(true, &block)
    end

    private

    def arel_where_sql(arel, relation)
      return arel.where_sql if relation.nil?
      return arel.where_sql unless relation.model.respond_to?(:arel_engine)

      arel.where_sql(relation.model.arel_engine)
    end

    def sql_check!(sql, relation)
      return if SQL_MATCHER.match?(sql)
      report_violation(sql, relation)
    end

    def run_with_arsi(with_arsi)
      previous, @enabled = @enabled, with_arsi
      yield
    ensure
      @enabled = previous
    end

    def report_violation(sql, relation)
      (violation_callback || DEFAULT_CALLBACK).call(sql, relation)
    end
  end
end
