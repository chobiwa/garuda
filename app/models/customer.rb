class Customer < ActiveRecord::Base
   validates :name, :presence => true
   validates :email, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
   validates :mobile, :presence => true, format: {with: /\A^[0-9]{10,10}$\Z/}

   has_many :transactions

   def is_winner?
    t = self.transactions.find {|t| t.is_winner?}
    !t.nil?
   end

end