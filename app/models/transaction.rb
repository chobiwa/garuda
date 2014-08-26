class Transaction < ActiveRecord::Base
	belongs_to :customer
	validates :customer, :presence => true

	validates :date, :presence => true

  has_many :transaction_items
  has_many :vouchers

  def total_amount
    self.transaction_items.map{|ti| ti.amount}.inject {|total, t| total + t}
  end

  def is_winner?
    v = self.vouchers.find {|v| v.is_winner?}
    !v.nil?
  end

  def all_coupons
    self.vouchers.map {|v| v.barcode_number}
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      columns = column_names + ["total"]
      csv <<  columns
      all.each do |c|
         v = c.attributes.values_at(*column_names) + [c.total_amount]
        csv << v
      end
    end
  end

end