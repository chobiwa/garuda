# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Customer.delete_all
Store.delete_all
Transaction.delete_all
TransactionItem.delete_all
Voucher.delete_all
User.delete_all


user = User.new(:email => 'mln@tws.com', :password => 'password', :password_confirmation => 'password', :name => "MLN Krishnan")
user.save!
user = User.new(:email => 'user1@email.com', :password => 'password', :password_confirmation => 'password', :name => "User1")
user.save!
user = User.new(:email => 'user2@email.com', :password => 'password', :password_confirmation => 'password', :name => "user2")
user.save!
user = User.new(:email => 'user3@email.com', :password => 'password', :password_confirmation => 'password', :name => "User2")
user.save!



current_path = File.dirname(__FILE__)
File.open(current_path+"/stores.csv").each do |line|
  s = Store.new name:line.strip
  s.save!
end

