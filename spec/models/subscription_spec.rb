require 'rails_helper'

RSpec.describe Subscription, type: :model do
  before(:all) do
    puts "\n========= Model - subscription_spec"
  end

  subject { build(:subscription) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a requestor_id" do
      subject.requestor_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a target_id" do
      subject.target_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if the requestor is already subscribed with the target" do
      user1 = create(:user, email: "user1@test.com")
      user2 = create(:user, email: "user2@test.com")
      subscription_bet_1_and_2 = Subscription.create(requestor_id: user1.id, target_id: user2.id)

      expect(Subscription.new(requestor_id: user1.id, target_id: user2.id)).to_not be_valid
      expect(Subscription.new(requestor_id: user2.id, target_id: user1.id)).to_not be_valid
    end

    it "is not valid if the user is subscribing to self" do
      user1 = create(:user)
      expect(Subscription.new(requestor_id: user1.id, target_id: user1.id)).to_not be_valid
    end
  end

  describe "Associations" do
    it "belongs_to requestor" do
      expect(described_class.reflect_on_association(:requestor).macro).to eq(:belongs_to)
    end

    it "belongs_to target" do
      expect(described_class.reflect_on_association(:target).macro).to eq(:belongs_to)
    end
  end

  describe "Methods" do
  end
end
