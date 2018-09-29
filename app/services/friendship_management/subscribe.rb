class FriendshipManagement::Subscribe
  attr_reader :subscription, :errors

  def run
    requestor = User.find_or_create_by(email: @requestor)
    target    = User.find_or_create_by(email: @target)
    @errors << requestor.errors.full_messages unless requestor.persisted?
    @errors << target.errors.full_messages unless target.persisted?
    return if @errors.any?

    @subscription = Subscription.find_or_initialize_by(requestor_id: requestor.id, target_id: target.id)
    @subscription.blocked = !!@options[:blocked]
    return if @subscription.save

    @errors << @subscription.errors.full_messages
  end

  def flat_errors
    @errors.flatten
  end

  private

  def initialize(params, options = {})
    @requestor    = params[:requestor]
    @target       = params[:target]
    @errors       = []
    @options      = options
  end
end
