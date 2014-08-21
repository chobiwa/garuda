class Transaction < ActiveRecord::Base
	belongs_to :customer
	validates :customer, :presence => true

	validates :date, :presence => true

  has_many :transaction_items
end