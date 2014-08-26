class Store < ActiveRecord::Base
  validates :name, :presence => true

  has_many :transaction_items
end