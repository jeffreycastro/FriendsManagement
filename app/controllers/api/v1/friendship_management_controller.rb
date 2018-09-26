class Api::V1::FriendshipManagementController < ApplicationController
  # POST /api/v1/friendship_management/connect_friends
  def connect_friends
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if connect_friends_params.blank?

    errors = []
    user1 = User.find_or_create_by(email: connect_friends_params[:friends].first)
    user2 = User.find_or_create_by(email: connect_friends_params[:friends].last)
    errors << user1.errors.full_messages unless user1.persisted?
    errors << user2.errors.full_messages unless user2.persisted?

    friendship = Friendship.new(user_id: user1.try(:id), friend_id: user2.try(:id))
    if friendship.save
      render json: { success: true }, status: :ok
    else
      errors << friendship.errors.full_messages
      render json: { success: false, messages: errors.flatten }, status: :unprocessable_entity
    end
  end

  private

  def connect_friends_params
    params.permit(friends: [])
  end
end
