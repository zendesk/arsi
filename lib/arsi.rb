require 'arsi/arel_tree_manager'
require 'arsi/mysql2_adapter'
require 'arsi/relation'
require 'arel'
require 'active_record'
require 'mysql2'
require 'active_record/connection_adapters/mysql2_adapter'
require 'active_support/core_ext/class/attribute'

module Arsi
  class UnscopedSQL < StandardError; end
  Arel::TreeManager.send(:include, ArelTreeManager)
  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:prepend, Mysql2Adapter)
  ActiveRecord::Relation.send(:prepend, Relation)
  ActiveRecord::Querying.delegate(:without_arsi, :to => :scoped)
  @enabled = true

  class << self
    attr_accessor :violation_callback
    SQL_MATCHER = /[\s_`(](gu|uu|u)?id`?\s+(=|<>|IN|IS)/i
    DEFAULT_CALLBACK = lambda do |sql, relation|
      raise UnscopedSQL, "Missing ID in the where sql:\n#{sql}\nAdd id or use without_arsi"
    end

    def sql_check!(sql, relation)
      return if !@enabled || relation.try(:without_arsi?)
      return if sql =~ SQL_MATCHER
      report_violation(sql, relation)
    end

    def arel_check!(arel, relation)
      sql = arel.respond_to?(:ast) ? arel.where_sql : arel.to_s
      sql_check!(sql, relation)
    end

    def disable
      old, @enabled = @enabled, false
      yield
    ensure
      @enabled = old
    end

    private

    def report_violation(sql, relation)
      (violation_callback || DEFAULT_CALLBACK).call(sql, relation)
    end
  end
end