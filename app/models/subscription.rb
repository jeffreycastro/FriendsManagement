class Subscription < ApplicationRecord
  belongs_to :requestor, class_name: "User"
  belongs_to :target, class_name: "User"

  delegate :email, to: :requestor, prefix: true

  validate :not_yet_subscribed, on: :create
  validate :not_subscribing_to_self

  scope :blocked,         ->{ where(blocked: true) }
  scope :subscribed_list, ->(target_id) { where("target_id = ? AND blocked = ?", target_id, false) }
  scope :blocked_list,    ->(target_id) { where("target_id = ? AND blocked = ?", target_id, true) }

  def not_yet_subscribed
    return if requestor_id.nil? || target_id.nil?
    sql_query = "(requestor_id = #{requestor_id} AND target_id = #{target_id})"
    errors.add(:base, "already subscribed!") if Subscription.where(sql_query).exists?
  end

  def not_subscribing_to_self
    return if requestor_id.nil? || target_id.nil?
    errors.add(:base, "cannot #{blocked ? 'block' : 'subscribe to'} self!") if requestor_id == target_id
  end
end
