class FriendshipManagement::RecipientsList
  attr_reader :user, :recipients_list

  def run
    @user = User.find_by(email: @email)
    return if @user.nil?

    @recipients_list = @user.recipients_list(@text)
  end

  private

  def initialize(params)
    @email           = params[:sender]
    @text            = params[:text]
    @recipients_list = []
  end
end
