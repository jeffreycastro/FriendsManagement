class Api::V1::FriendshipManagementController < ApplicationController
  # POST /api/v1/friendship_management/connect_friends
  def connect_friends
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if connect_friends_params.blank?

    service = FriendshipManagement::ConnectFriends.new(connect_friends_params)
    service.run

    if service.friendship.persisted?
      render json: { success: true }, status: :ok
    else
      render json: { success: false, messages: service.flat_errors }, status: :unprocessable_entity
    end
  end

  private

  def connect_friends_params
    params.permit(friends: [])
  end
end
