FactoryBot.define do
  factory :subscription do
    association :requestor, factory: :user
    association :target, factory: :user
  end
end
