class CreateTransactionitem < ActiveRecord::Migration
  def change
    create_table :transactionitems do |t|

    	t.integer  :transaction_id, :null => false
    	t.string   :item_id, :null => false
    	t.integer  :store_id, :null => false
    	t.integer  :amount, :null => false
    	t.date     :date, :null => false

    end
    add_index :transactionitems, [:item_id, :store_id], :unique => true
  end
end
