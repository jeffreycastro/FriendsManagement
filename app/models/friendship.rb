class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :not_yet_friends

  def not_yet_friends
    return if user_id.nil? || friend_id.nil?
    sql_query = "(user_id = #{user_id} AND friend_id = #{friend_id}) OR (user_id = #{friend_id} AND friend_id = #{user_id})"
    errors.add(:user_id, "already friends with each other!") if Friendship.where(sql_query).exists?
  end
end
