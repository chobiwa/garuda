class TransactionItem < ActiveRecord::Base
	belongs_to :store
	validates :store, :presence => true

	belongs_to :transact, :foreign_key => "transaction_id", class_name: "Transaction"

	validates :amount, :date, :item_id, :presence => true
end