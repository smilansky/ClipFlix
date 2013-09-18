class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.integer :amount
      t.string :reference_id

      t.timestamps
    end
  end

  def down
    drop_table :payments
  end
end
