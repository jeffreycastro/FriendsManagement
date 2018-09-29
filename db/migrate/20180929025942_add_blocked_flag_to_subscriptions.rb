class AddBlockedFlagToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :blocked, :boolean, default: false
  end
end
