class Voucher < ActiveRecord::Base
	validates :barcode_number, :scratch_code, :presence => true
end
