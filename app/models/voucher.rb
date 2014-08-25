class Voucher < ActiveRecord::Base
	validates :barcode_number, :presence => true

  belongs_to :transact, :foreign_key => "transaction_id", class_name: "Transaction"

  def mark_as_winner
    self.winner = true
    self.win_date = Date.today
  end

  def is_winner
    self.winner
  end
end
