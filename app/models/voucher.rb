class Voucher < ActiveRecord::Base
	validates :barcode_number, :presence => true

  belongs_to :transact, :foreign_key => "transaction_id", class_name: "Transaction"

  validates_uniqueness_of :barcode_number, :message => "Voucher Taken"

  def mark_as_winner
    self.winner = true
    self.win_date = Date.today
  end

  def is_winner?
    self.winner
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv <<  column_names
      all.each do |c|
         v = c.attributes.values_at(*column_names)
        csv << v
      end
    end
  end

end
