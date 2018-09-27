class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :subscriptions, foreign_key: "requestor_id"
  has_many :inverse_subscriptions, class_name: "Subscription", foreign_key: "target_id"

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true, message: "has invalid format"
end
