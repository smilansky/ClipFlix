class CreateInvites < ActiveRecord::Migration
def change
  create_table :invites do |t|
    t.string :name, :email
    t.text :message
    t.string :token
    t.integer :user_id

    t.timestamps
  end
end
end
