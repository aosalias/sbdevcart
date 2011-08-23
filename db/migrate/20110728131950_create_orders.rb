class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email
      t.string :state
      t.datetime :purchased_at
      t.timestamps
    end
  end
end
