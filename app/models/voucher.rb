class Voucher < ActiveRecord::Base
	validates :barcode_number, :scratch_code, :presence => true

  belongs_to :transact, :foreign_key => "transaction_id", class_name: "Transaction"
end
