FactoryBot.define do
  factory :subscription do
    association :requestor, factory: :user
    association :target, factory: :user

    factory :blocked_subscription do
      blocked { true }
    end
  end
end
