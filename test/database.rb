ActiveRecord::Base.establish_connection(adapter: "mysql2", database: "arsi_test", host: "127.0.0.1")
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

  create_table :migrations, :id => false, :force => true do |t|
    t.column :name, :string
  end
end

class User < ActiveRecord::Base
  belongs_to :account
  has_many :entries
end

class Entry < ActiveRecord::Base
  belongs_to :user
end

class Account < ActiveRecord::Base
  has_many :users
end

class Migration < ActiveRecord::Base
end
