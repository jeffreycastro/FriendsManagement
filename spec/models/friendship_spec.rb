require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:all) do
    puts "\n========= Model - friendship_spec"
  end

  subject { build(:friendship) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a user_id" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a friend_id" do
      subject.friend_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if the user is already friends with the other user" do
      user1 = create(:user, email: "user1@test.com")
      user2 = create(:user, email: "user2@test.com")
      friendship_bet_1_and_2 = Friendship.create(user_id: 1, friend_id: 2)

      expect(Friendship.new(user_id: user1.id, friend_id: user2.id)).to_not be_valid
      expect(Friendship.new(user_id: user2.id, friend_id: user1.id)).to_not be_valid
    end
  end

  describe "Associations" do
    it "belongs_to user" do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs_to friend" do
      expect(described_class.reflect_on_association(:friend).macro).to eq(:belongs_to)
    end
  end

  describe "Methods" do
  end
end
