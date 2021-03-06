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

  # GET /api/v1/friendship_management/friends_list
  def friends_list
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if friends_list_params[:email].blank?

    service = FriendshipManagement::FriendsList.new(friends_list_params)
    service.run

    if service.user.nil?
      render json: { success: false, messages: ["User with given email does not exist"] }, status: :not_found
    else
      render json: { success: true, friends: service.friends_list, count: service.friends_list.count }, status: :ok
    end
  end

  # GET /api/v1/friendship_management/common_friends_list
  def common_friends_list
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if common_friends_list_params.blank?

    service = FriendshipManagement::CommonFriendsList.new(common_friends_list_params)
    service.run

    if service.errors.any?
      render json: { success: false, messages: service.errors }, status: :bad_request
    else
      render json: { success: true, friends: service.common_friends_list, count: service.common_friends_list.count }, status: :ok
    end
  end

  # POST /api/v1/friendship_management/subscribe
  def subscribe
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if subscribe_params.blank?

    service = FriendshipManagement::Subscribe.new(subscribe_params)
    service.run

    if service.subscription.try(:persisted?)
      render json: { success: true }, status: :ok
    else
      render json: { success: false, messages: service.flat_errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/friendship_management/block
  def block
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if block_params.blank?

    service = FriendshipManagement::Subscribe.new(block_params, blocked: true)
    service.run

    if service.subscription.try(:persisted?)
      render json: { success: true }, status: :ok
    else
      render json: { success: false, messages: service.flat_errors }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/friendship_management/recipients_list
  def recipients_list
    return render json: { success: false, messages: ["Invalid parameters given"] }, status: :bad_request if recipients_list_params[:sender].blank?

    service = FriendshipManagement::RecipientsList.new(recipients_list_params)
    service.run

    if service.user.nil?
      render json: { success: false, messages: ["User with given email does not exist"] }, status: :not_found
    else
      render json: { success: true, recipients: service.recipients_list }, status: :ok
    end
  end

  private

  def connect_friends_params
    params.permit(friends: [])
  end

  def friends_list_params
    params.permit(:email)
  end

  def common_friends_list_params
    params.permit(friends: [])
  end

  def subscribe_params
    params.permit(:requestor, :target)
  end

  def block_params
    params.permit(:requestor, :target)
  end

  def recipients_list_params
    params.permit(:sender, :text)
  end
end
