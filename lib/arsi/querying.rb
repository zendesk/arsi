module Arsi::Querying
  def without_arsi
    scope = (ActiveRecord::VERSION::MAJOR == 3 ? scoped : where(nil))
    scope.without_arsi
  end
end
