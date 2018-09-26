Rails.application.routes.draw do
  scope 'api', module: :api, constraints: { format: :json } do
    namespace :v1 do
      # friendship management
      post '/friendship_management/connect_friends',     to: 'friendship_management#connect_friends'
      get  '/friendship_management/friends_list',        to: 'friendship_management#friends_list'
      get  '/friendship_management/common_friends_list', to: 'friendship_management#common_friends_list'
    end
  end
end
