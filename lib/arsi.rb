require 'arsi/version'
require 'arsi/basic_inspector'
require 'arsi/arel_tree_manager'
require 'arsi/mysql2_adapter'
require 'arsi/relation'
require 'arel'
require 'active_record'
require 'mysql2'
require 'active_record/connection_adapters/mysql2_adapter'

module Arsi
  Arel::TreeManager.send(:prepend, ArelTreeManager)
  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:prepend, Mysql2Adapter)
  ActiveRecord::Relation.send(:prepend, Relation)
  ActiveRecord::Querying.delegate(:without_id_check, :to => :scoped)


end
