class CreateVoucher < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|

    	t.string :barcode_number, :null => false
    	t.string :scratch_code, :null => false
    end
    add_index :vouchers, :barcode_number, :unique => true
    add_index :vouchers, :scratch_code, :unique => true
  end
end
