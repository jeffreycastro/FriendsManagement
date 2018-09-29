class AddBlockedIndexToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_index :subscriptions, :blocked
  end
end
