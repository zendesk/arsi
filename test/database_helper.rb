ActiveRecord::Base.establish_connection(adapter: "mysql2", database: "arsi")
#ActiveRecord::Schema.verbose = false

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')
  fixtures :all

  def before_setup
    setup_db
    super
  end

  def after_teardown
    teardown_db
    super
  end

  def setup_db
    # AR caches columns options like defaults etc. Clear them!
    ActiveRecord::Base.connection.create_table :users do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :password, :string
      t.column :account_id, :integer
    end
  end

  def teardown_db
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end


end
