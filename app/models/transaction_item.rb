class TransactionItem < ActiveRecord::Base
	belongs_to :store
	validates :store, :presence => true

	belongs_to :transact, :foreign_key => "transaction_id", class_name: "Transaction"

	validates :amount, :date, :item_id, :presence => true

  validates_uniqueness_of :item_id, :scope => :store_id, :message => "Receipt Taken"
end