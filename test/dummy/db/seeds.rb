# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!([
  {name: 'Bob Smith', email: 'bob.smith@example.com', password:'123456', account_id: 1},
  {name: 'Jane Smith', email: 'jane.smith@example.com', password:'password', account_id: 1},
  {name: 'John Doe', email: 'john.doe@example.com', password:'abcdef', account_id: 2},
  {name: 'Jane Doe', email: 'jane.smith@example.com', password:'janedoe', account_id: 2}
])