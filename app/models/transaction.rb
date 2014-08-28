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

  def vouchers_length
    self.vouchers.length
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      columns = ["id"] + ["date"] + ["customer_id"] + ["total"]
      csv <<  columns
      all.each do |c|
         v = [c.id] + [c.date.localtime.strftime("%Y-%m-%d %H:%M:%S")] +[c.customer_id] + [c.total_amount]
        csv << v
      end
    end
  end

end