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

Customer.create! name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

user = User.new(:email => 'mln@tws.com', :password => 'password', :password_confirmation => 'password', :name => "MLN Krishnan")
user.save!



current_path = File.dirname(__FILE__)
File.open(current_path+"/stores.csv").each do |line|
  s = Store.new name:line.strip
  s.save!
end

