class Subscription < ApplicationRecord
  belongs_to :requestor, class_name: "User"
  belongs_to :target, class_name: "User"

  validate :not_yet_subscribed
  validate :not_subscribing_to_self

  def not_yet_subscribed
    return if requestor_id.nil? || target_id.nil?
    sql_query = "(requestor_id = #{requestor_id} AND target_id = #{target_id}) OR (requestor_id = #{target_id} AND target_id = #{requestor_id})"
    errors.add(:base, "already subscribed!") if Subscription.where(sql_query).exists?
  end

  def not_subscribing_to_self
    return if requestor_id.nil? || target_id.nil?
    errors.add(:base, "cannot subscribe to self!") if requestor_id == target_id
  end
end
