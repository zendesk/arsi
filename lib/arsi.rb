require 'arsi/arel_tree_manager'
require 'arsi/mysql2_adapter'
require 'arsi/relation'
require 'active_record'
require 'active_record/connection_adapters/mysql2_adapter'

module Arsi
  class UnscopedSQL < StandardError; end
  Arel::TreeManager.include(ArelTreeManager)
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

    def sql_check!(sql, relation)
      return if !@enabled || relation.try(:without_arsi?)
      return if SQL_MATCHER.match?(sql)
      report_violation(sql, relation)
    end

    def arel_check!(arel, relation)
      return unless @enabled
      sql = arel.respond_to?(:ast) ? arel.where_sql : arel.to_s
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
