require 'rails_helper'

RSpec.describe 'FriendshipManagement API v1', type: :request do
  before(:all) do
    puts "\n========= API controller - friendship_management_spec"
  end

  # Test suite for POST /api/v1/friendship_management/connect_friends
  describe 'POST /api/v1/friendship_management/connect_friends' do
    context "invalid request" do
      context "no parameters given" do
        before(:each) do
          post '/api/v1/friendship_management/connect_friends', params: {}
        end

        it "renders status code for :bad_request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the correct json response" do
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Invalid parameters given")
        end
      end
    end

    context "valid request" do
      let!(:connect_friends_params) {{ friends: ["user1@example.com", "user2@example.com"] }}

      it "calls on the FriendshipManagement::ConnectFriends service" do
        expect(FriendshipManagement::ConnectFriends).to receive(:new).and_call_original
        post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
      end

      context "given email addresses are not yet friends" do
        it "connects them by creating a Friendship record" do
          expect {
            post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          }.to change(Friendship, :count).by(1)
          expect(Friendship.last.user.email).to eq(connect_friends_params[:friends].first)
          expect(Friendship.last.friend.email).to eq(connect_friends_params[:friends].last)
        end

        it "returns status code for :ok" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          expect(response).to have_http_status(:ok)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
        end
      end

      context "given email addresses are already friends" do
        let!(:user1) { create(:user, email: connect_friends_params[:friends].first) }
        let!(:user2) { create(:user, email: connect_friends_params[:friends].last) }
        let!(:existing_friendship) { create(:friendship, user: user1, friend: user2) }

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("already friends with each other!")
        end

        it "does not connect the users" do
          expect {
            post '/api/v1/friendship_management/connect_friends', params: connect_friends_params
          }.to not_change(Friendship, :count)
        end
      end

      context "given email addresses are the same" do
        let!(:connect_friends_params_2) {{ friends: ["user1@example.com", "user1@example.com"] }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_2
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_2
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("cannot befriend self!")
        end

        it "does not connect the users" do
          expect {
            post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_2
          }.to not_change(Friendship, :count)
        end
      end

      context "one or more of the given email addresses have invalid format" do
        let!(:connect_friends_params_3) {{ friends: ["user1@example.com", "user2"] }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_3
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_3
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Email has invalid format")
        end

        it "does not connect the users" do
          expect {
            post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_3
          }.to not_change(Friendship, :count)
        end
      end

      context "one or more of the given email addresses are blank" do
        let!(:connect_friends_params_4) {{ friends: ["user1@example.com", ""] }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_4
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_4
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Email can't be blank")
        end

        it "does not connect the users" do
          expect {
            post '/api/v1/friendship_management/connect_friends', params: connect_friends_params_4
          }.to not_change(Friendship, :count)
        end
      end
    end
  end
end
