Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show] do
        resources :sleep_records, only: [:index, :create, :show] do
          collection do
            get :friends_sleep_records
            get :stats
          end
        end

        resources :followings, controller: 'user_followings', only: [:index, :create] do
          collection do
            delete ':target_user_id', action: :destroy
          end
        end
      end
    end
  end
end
