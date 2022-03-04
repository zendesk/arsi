require 'uri'
mysql_url = URI(ENV['MYSQL_URL'] || 'mysql://root@127.0.0.1')
connection_options = {
  adapter: "mysql2",
  host: mysql_url.host,
  port: mysql_url.port,
  username: mysql_url.user,
  password: mysql_url.password
}
database = 'arsi_test'
ActiveRecord::Base.establish_connection(connection_options)
begin
  ActiveRecord::Base.connection.create_database(database)
rescue ActiveRecord::StatementInvalid
  # already exists ...
end
ActiveRecord::Base.establish_connection(connection_options.merge(database: database))

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :name, :string
    t.column :email, :string
    t.column :password, :string
    t.column :account_id, :integer
    t.column :android, :integer
    t.column :guid, :string
    t.column :uuid, :string
    t.column :uid, :string
  end

  create_table :entries, :force => true do |t|
    t.column :title, :string
    t.column :body, :string
    t.column :user_id, :integer
  end

  create_table :accounts, :force => true do |t|
    t.column :name, :string
  end

  create_table :heads, :force => true do |t|
    t.column :nose_count, :integer
    t.column :user_id, :integer
  end

  create_table :migrations, :id => false, :force => true do |t|
    t.column :name, :string
  end
end

class User < ActiveRecord::Base
  belongs_to :account
  has_many :entries
  has_one :head
end

class Entry < ActiveRecord::Base
  belongs_to :user
end

class Account < ActiveRecord::Base
  has_many :users
end

class Head < ActiveRecord::Base
  belongs_to :user
end

class Migration < ActiveRecord::Base
end
