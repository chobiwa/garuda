class CreateVoucherMaster < ActiveRecord::Migration
  def change
    create_table :voucher_masters do |t|
      t.string   :barcode_number, :null => false
    end
  end
end
