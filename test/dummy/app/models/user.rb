class User < ActiveRecord::Base
   attr_accessible :name, :email, :password, :account_id
end
