class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
end
