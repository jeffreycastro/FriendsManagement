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

  # Test suite for GET /api/v1/friendship_management/friends_list
  describe 'GET /api/v1/friendship_management/friends_list' do
    context "invalid request" do
      context "no parameters given" do
        before(:each) do
          get "/api/v1/friendship_management/friends_list", params: {}
        end

        it "renders status code for :bad_request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the correct json response" do
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Invalid parameters given")
        end
      end

      context "no email address given" do
        before(:each) do
          get "/api/v1/friendship_management/friends_list", params: { email: "" }
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
      let!(:user1) { create(:user, email: "user1@example.com") }
      let!(:friends_list_params) {{ email: user1.email }}

      it "calls on the FriendshipManagement::FriendsList service" do
        expect(FriendshipManagement::FriendsList).to receive(:new).and_call_original
        get "/api/v1/friendship_management/friends_list", params: friends_list_params
      end

      context "given email address does not have User record yet" do
        let!(:friends_list_params_2) {{ email: "someotheremail@example.com" }}

        it "returns status code for :not_found" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params_2
          expect(response).to have_http_status(:not_found)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params_2
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("User with given email does not exist")
        end
      end

      context "given email address does not have friends yet" do
        it "returns status code for :ok" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params
          expect(response).to have_http_status(:ok)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
          expect(JSON.parse(response.body)["friends"]).to eq([])
          expect(JSON.parse(response.body)["count"]).to eq(0)
        end
      end

      context "given email address has friends" do
        let!(:user2) { create(:user, email: "user2@example.com") }
        let!(:user3) { create(:user, email: "user3@example.com") }
        before(:each) do
          create(:friendship, user: user1, friend: user2)
          create(:friendship, user: user3, friend: user1)
        end

        it "returns status code for :ok" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params
          expect(response).to have_http_status(:ok)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/friends_list", params: friends_list_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
          expect(JSON.parse(response.body)["friends"]).to include(user2.email)
          expect(JSON.parse(response.body)["friends"]).to include(user3.email)
          expect(JSON.parse(response.body)["count"]).to eq(2)
        end
      end
    end
  end

  # Test suite for GET /api/v1/friendship_management/common_friends_list
  describe 'GET /api/v1/friendship_management/common_friends_list' do
    context "invalid request" do
      context "no parameters given" do
        before(:each) do
          get "/api/v1/friendship_management/common_friends_list", params: {}
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
      let!(:user1) { create(:user, email: "user1@example.com") }
      let!(:user2) { create(:user, email: "user2@example.com") }
      let!(:common) { create(:user, email: "common@example.com") }
      let!(:common_friends_list_params) {{ friends: [user1.email, user2.email] }}

      it "calls on the FriendshipManagement::CommonFriendsList service" do
        expect(FriendshipManagement::CommonFriendsList).to receive(:new).and_call_original
        get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params
      end

      context "valid emails given" do
        it "returns status code for :ok" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params
          expect(response).to have_http_status(:ok)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
          expect(JSON.parse(response.body)["friends"]).to eq([])
          expect(JSON.parse(response.body)["count"]).to eq(0)

          create(:friendship, user: user1, friend: common)
          create(:friendship, user: user2, friend: common)
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
          expect(JSON.parse(response.body)["friends"]).to include(common.email)
          expect(JSON.parse(response.body)["count"]).to eq(1)
        end
      end

      context "duplicate emails given" do
        let!(:common_friends_list_params_2) {{ friends: [user1.email, user1.email] }}

        it "returns status code for :bad_request" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params_2
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params_2
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Duplicate emails given")
        end
      end

      context "given email address does not have User record yet" do
        let!(:common_friends_list_params_2) {{ friends: ["other1@example.com", "other2@example.com"] }}

        it "returns status code for :bad_request" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params_2
          expect(response).to have_http_status(:bad_request)
        end

        it "returns the correct json response" do
          get "/api/v1/friendship_management/common_friends_list", params: common_friends_list_params_2
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("User with given first email not found")
          expect(JSON.parse(response.body)["messages"]).to include("User with given second email not found")
        end
      end
    end
  end

  # Test suite for POST /api/v1/friendship_management/subscribe
  describe 'POST /api/v1/friendship_management/subscribe' do
    context "invalid request" do
      context "no parameters given" do
        before(:each) do
          post '/api/v1/friendship_management/subscribe', params: {}
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
      let!(:subscribe_params) {{ requestor: "user1@example.com", target: "user2@example.com" }}

      it "calls on the FriendshipManagement::Subscribe service" do
        expect(FriendshipManagement::Subscribe).to receive(:new).and_call_original
        post '/api/v1/friendship_management/subscribe', params: subscribe_params
      end

      context "requestor is not yet subscribed to the target" do
        it "creates a Subscription record" do
          expect {
            post '/api/v1/friendship_management/subscribe', params: subscribe_params
          }.to change(Subscription, :count).by(1)
          expect(Subscription.last.requestor.email).to eq(subscribe_params[:requestor])
          expect(Subscription.last.target.email).to eq(subscribe_params[:target])
        end

        it "returns status code for :ok" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params
          expect(response).to have_http_status(:ok)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params
          expect(JSON.parse(response.body)["success"]).to eq(true)
        end
      end

      context "requestor is already subscribed to the target" do
        let!(:user1) { create(:user, email: subscribe_params[:requestor]) }
        let!(:user2) { create(:user, email: subscribe_params[:target]) }
        let!(:existing_sub) { create(:subscription, requestor: user1, target: user2) }

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("already subscribed!")
        end

        it "does not create a Subscription" do
          expect {
            post '/api/v1/friendship_management/subscribe', params: subscribe_params
          }.to not_change(Subscription, :count)
        end
      end

      context "given email addresses are the same" do
        let!(:subscribe_params_2) {{ requestor: "user1@example.com", target: "user1@example.com" }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_2
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_2
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("cannot subscribe to self!")
        end

        it "does not create a Subscription" do
          expect {
            post '/api/v1/friendship_management/subscribe', params: subscribe_params_2
          }.to not_change(Subscription, :count)
        end
      end

      context "one or more of the given email addresses have invalid format" do
        let!(:subscribe_params_3) {{ requestor: "user1@example.com", target: "invalidemail" }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_3
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_3
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Email has invalid format")
        end

        it "does not create a Subscription" do
          expect {
            post '/api/v1/friendship_management/subscribe', params: subscribe_params_3
          }.to not_change(Subscription, :count)
        end
      end

      context "one or more of the given email addresses are blank" do
        let!(:subscribe_params_4) {{ requestor: "user1@example.com", target: "" }}

        it "returns status code for :unprocessable_entity" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_4
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns the correct json response" do
          post '/api/v1/friendship_management/subscribe', params: subscribe_params_4
          expect(JSON.parse(response.body)["success"]).to eq(false)
          expect(JSON.parse(response.body)["messages"]).to include("Email can't be blank")
        end

        it "does not create a Subsription" do
          expect {
            post '/api/v1/friendship_management/subscribe', params: subscribe_params_4
          }.to not_change(Subscription, :count)
        end
      end
    end
  end
end
