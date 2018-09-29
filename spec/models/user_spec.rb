require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    puts "\n========= Model - user_spec"
  end

  subject { build(:user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a unique email" do
      User.create(email: "user1@example.com")
      subject.email = "user1@example.com"
      expect(subject).to_not be_valid
    end

    it "is not valid if email has wrong format" do
      subject.email = "user1.com"
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it "has_many friendships" do
      expect(described_class.reflect_on_association(:friendships).macro).to eq(:has_many)
    end

    it "has_many friends" do
      expect(described_class.reflect_on_association(:friends).macro).to eq(:has_many)
    end

    it "has_many inverse_friendships" do
      expect(described_class.reflect_on_association(:inverse_friendships).macro).to eq(:has_many)
    end

    it "has_many inverse_friends" do
      expect(described_class.reflect_on_association(:inverse_friends).macro).to eq(:has_many)
    end
  end

  describe "Methods" do
    describe "#recipients_list" do
      let!(:user1) { create(:user, email: "user1@example.com") }
      let!(:user2) { create(:user, email: "user2@example.com") }
      let!(:user3) { create(:user, email: "user3@example.com") }

      context "user has friend connections" do
        it "returns the correct output" do
          create(:friendship, user: user1, friend: user2)
          create(:friendship, user: user1, friend: user3)

          expect(user1.recipients_list).to eq([user2.email, user3.email])
        end
      end

      context "user has subscriptions from other users" do
        it "returns the correct output" do
          create(:friendship, user: user1, friend: user2)
          create(:subscription, requestor: user3, target: user1)

          expect(user1.recipients_list).to eq([user2.email, user3.email])
        end
      end

      context "user has been blocked by other users" do
        it "returns the correct output" do
          create(:friendship, user: user1, friend: user2)
          create(:subscription, requestor: user3, target: user1)
          create(:blocked_subscription, requestor: user2, target: user1)

          expect(user1.recipients_list).to eq([user3.email])
        end
      end

      context "has text_to_scan parameter included" do
        it "returns the correct output" do
          create(:friendship, user: user1, friend: user2)
          create(:subscription, requestor: user3, target: user1)
          create(:blocked_subscription, requestor: user2, target: user1)

          text_to_scan = "Hello world kate@example.com test@example.com"
          expect(user1.recipients_list(text_to_scan)).to eq([user3.email, "kate@example.com", "test@example.com"])
        end
      end
    end
  end
end
