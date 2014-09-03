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
VoucherMaster.delete_all
Voucher.delete_all
User.delete_all


User.create!(:email => 'mln@tws.com', :password => 'password', :password_confirmation => 'password', :name => "MLN Krishnan")
User.create!(:email => 'admin@siiplconsulting.com', :password => 'garuda@admin@123', :password_confirmation => 'garuda@admin@123', :name => "Garuda Event Admin", :role => "admin")
User.create!(:email => 'garudaevent@siiplconsulting.com', :password => 'garuda@123', :password_confirmation => 'garuda@123', :name => "Garuda Event")

(1..30).to_a.each {|n| User.create!(:email => "user#{n}@email.com", :password => 'password', :password_confirmation => 'password', :name => "User#{n}")}

(1..100).to_a.each{|n| VoucherMaster.create! barcode_number: "V#{n}"}

current_path = File.dirname(__FILE__)
File.open(current_path+"/stores.csv").each do |line|
  s = Store.new name:line.strip
  s.save!
end

