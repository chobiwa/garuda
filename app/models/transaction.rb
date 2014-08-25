class Transaction < ActiveRecord::Base
	belongs_to :customer
	validates :customer, :presence => true

	validates :date, :presence => true

  has_many :transaction_items
  has_many :vouchers

  def is_winner?
    v = self.vouchers.find {|v| v.is_winner?}
    !v.nil?
  end
end