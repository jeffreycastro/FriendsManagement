class FriendshipManagement::FriendsList
  attr_reader :user, :friends_list

  def run
    @user = User.find_by(email: @email)
    return if @user.nil?

    @friends_list = Friendship.friends_list(@user.id).map { |f| f.friend_email(@user.id) }
  end

  private

  def initialize(params)
    @email        = params[:email]
    @friends_list = []
  end
end
