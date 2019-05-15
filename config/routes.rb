Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books, only: [:show, :index, :create]
      # books#show will serialize annotations(filtered by subscription)

      resources :annotations, except: [:new, :edit]
      # annotaitions#index for a particular user's annotations, or books annotations

      get "/users/home", to: "users#show"
      resources :users, only: [:create, :update]

      # show and update are perhaps unneccessary

      resources :categories, only: [:index, :show]

      resources :studies, only: [:index, :show, :create, :update, :destroy]

      post "/login", to: "authentication#authorize"

      #NO CONTROLLER
      #Likes
      #Subscribers
      #Contributors
    end
  end
end
