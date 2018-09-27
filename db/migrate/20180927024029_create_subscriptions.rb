class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :requestor_id
      t.integer :target_id
    end
    add_index :subscriptions, :requestor_id
    add_index :subscriptions, :target_id
  end
end
