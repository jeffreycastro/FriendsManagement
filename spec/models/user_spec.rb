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
  end
end
