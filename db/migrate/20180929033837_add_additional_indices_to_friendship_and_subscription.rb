class AddAdditionalIndicesToFriendshipAndSubscription < ActiveRecord::Migration[5.1]
  def change
    add_index :friendships, [:user_id, :friend_id]
    add_index :subscriptions, [:requestor_id, :target_id]
  end
end
