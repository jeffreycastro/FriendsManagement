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
  end

  describe "Associations" do
  end

  describe "Methods" do
  end
end
