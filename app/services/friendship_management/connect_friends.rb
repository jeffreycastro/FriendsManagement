class FriendshipManagement::ConnectFriends
  attr_reader :friendship, :errors

  def run
    user1 = User.find_or_create_by(email: @email1)
    user2 = User.find_or_create_by(email: @email2)
    @errors << user1.errors.full_messages unless user1.persisted?
    @errors << user2.errors.full_messages unless user2.persisted?
    return if @errors.any?

    @friendship.user_id   = user1.id
    @friendship.friend_id = user2.id
    return if @friendship.save

    @errors << @friendship.errors.full_messages
  end

  def flat_errors
    @errors.flatten
  end

  private

  def initialize(params)
    @email1     = params[:friends].first
    @email2     = params[:friends].last
    @friendship = Friendship.new
    @errors     = []
  end
end
