class User < ApplicationRecord
  EMAIL_REGEXP = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :subscriptions, foreign_key: "requestor_id"
  has_many :inverse_subscriptions, class_name: "Subscription", foreign_key: "target_id"

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true, message: "has invalid format"

  def recipients_list(text_to_scan = nil)
    blocks             = Subscription.blocked_list(id).map { |s| s.requestor_email }
    friend_connections = Friendship.friends_list(id).map { |f| f.friend_email(id) }
    subscriptions      = Subscription.subscribed_list(id).map { |s| s.requestor_email }
    email_mentions     = text_to_scan.to_s.scan(EMAIL_REGEXP)
    return (friend_connections + subscriptions + email_mentions - blocks).uniq
  end
end
