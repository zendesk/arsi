module Arsi::Table
  def columns
    @columns ||= attributes_for @engine.connection.columns(@name)
  end
end
