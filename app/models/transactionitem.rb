class Transactionitem < ActiveRecord::Base
	belongs_to :store, :foreign_key => "store_id"
	validates :store, :presence => true

	belongs_to :transaction1, :foreign_key => "transaction_id", class_name: "Transaction"
	validates :transaction1, :presence => true

	validates :store_id , :transaction_id, :amount, :date, :item_id, :presence => true
end