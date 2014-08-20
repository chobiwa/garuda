class Transaction < ActiveRecord::Base
	belongs_to :customer, :foreign_key => "customer_id"
	validates :customer, :presence => true

	validates :customer_id, :presence => true
	validates :date, :presence => true
end