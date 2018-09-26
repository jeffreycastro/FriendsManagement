class FriendshipManagement::CommonFriendsList
  attr_reader :errors, :common_friends_list

  def run
    user1 = User.find_by(email: @email1)
    user2 = User.find_by(email: @email2)
    @errors << "User with given first email not found" if user1.nil?
    @errors << "User with given second email not found" if user2.nil?
    @errors << "Duplicate emails given" if @email1.present? && @email2.present? && (@email1 == @email2)
    return if @errors.any?
    
    service1 = FriendshipManagement::FriendsList.new(email: @email1)
    service2 = FriendshipManagement::FriendsList.new(email: @email2)
    service1.run
    service2.run
    @common_friends_list = service1.friends_list & service2.friends_list
  end

  private

  def initialize(params)
    @email1              = params[:friends].first
    @email2              = params[:friends].last
    @errors              = []
    @common_friends_list = []
  end
end
